part of roster_view;

class _RosterMobile extends StatefulWidget {

  final RosterViewModel viewModel;

  _RosterMobile(this.viewModel);

  @override
  State<StatefulWidget> createState() => _RosterMobileState();

}

class _RosterMobileState extends State<_RosterMobile> {

  bool isEditEnabled;

  Player tempPlayer;

  final PlayerDetailController playerDetailController = PlayerDetailController();

  void initializeState() {
    tempPlayer = Player.clone(widget.viewModel.player);
  }

  @override
  void initState() {
    super.initState();
    isEditEnabled = widget.viewModel.isNewPlayer;
    initializeState();
  }

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) {
        widget.viewModel.onBottomBarItemChanged(context, index);
      },
      childBuilder: (BuildContext childContext, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {

        double width = 0.9 * sizingInformation.localWidgetSize.width;

        return PlayerDetailLayout(
          player: tempPlayer,
          isEditEnabled: isEditEnabled,
          controller: playerDetailController,
          onSuggestionTeamCallback: (pattern) => widget.viewModel.onSuggestionTeamCallback(pattern),
          teamCategoriesCallback: (team) => widget.viewModel.getTeamCategories(team),
          maxWidth: width,
        );
      },
    );
  }

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    String title = widget.viewModel.getAppBarTitle();
    if(isEditEnabled) {
      return PlatformAppBars.getPlatformAppBarForRosterViewInEditMode(title, () => onActionBack(context), onActionCancel, () => onActionConfirm(context));
    } else {
      return PlatformAppBars.getPlatformAppBarForRosterViewInViewMode(title, () => onActionBack(context), onActionEditPress, () => onActionAddPress(context));
    }
  }

  void onActionBack(BuildContext context) {
    if(isEditEnabled) {
      setState(() {
        isEditEnabled = false;
      });
    } else {
     Navigator.of(context).pop();
    }
  }

  void onActionCancel() {
    if(isEditEnabled) {
      setState(() {
        isEditEnabled = false;
        initializeState();
      });
    }
  }

  Future<void> onActionConfirm(BuildContext context) async {
    if(isEditEnabled) {
      print("edit $isEditEnabled");
      playerDetailController.savePlayerStatus();
      print("savePlayerStatus");
      await widget.viewModel.onPlayerSave(context, tempPlayer);
      print("onPlayerSave");
      setState(() {
        isEditEnabled = false;
      });
    }
  }

  void onActionEditPress() {
    setState(() {
      isEditEnabled = true;
      initializeState();
    });
  }

  void onActionAddPress(BuildContext context) {
    widget.viewModel.navigateToPlayerMatchesNotes(context);
  }

}
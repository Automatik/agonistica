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
      childBuilder: (BuildContext childContext, MySizingInformation sizingInformation) {

        double width = 0.9 * sizingInformation.localWidgetSize.width;

        return PlayerDetailLayout(
//          isNewPlayer: widget.isNewPlayer,
//          player: isEditEnabled ? tempPlayer : widget.viewModel.player,
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
      return Utils.getPlatformAppBarForRosterViewInEditMode(title, () => onActionBack(context), onActionCancel, onActionConfirm);
    } else {
      return Utils.getPlatformAppBarForRosterViewInViewMode(title, () => onActionBack(context), onActionEditPress, onActionAddPress);
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

  void onActionConfirm() async {
    print("onActionConfirm");
    if(isEditEnabled) {
      playerDetailController.savePlayerStatus();
      await widget.viewModel.onPlayerSave(context, tempPlayer);
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

  void onActionAddPress() {

  }

}

abstract class OnActionListener {

  void onActionConfirm();

  void onActionCancel();

}
part of roster_view;

class _RosterMobile extends StatefulWidget {

  final RosterViewModel viewModel;

  _RosterMobile(this.viewModel);

  @override
  State<StatefulWidget> createState() => _RosterMobileState();

}

class _RosterMobileState extends State<_RosterMobile> {

  late bool isEditEnabled;

  late SeasonPlayer tempSeasonPlayer;

  final PlayerDetailController playerDetailController = PlayerDetailController();

  void initializeState() {
    tempSeasonPlayer = SeasonPlayer.clone(widget.viewModel.seasonPlayer);
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
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) {
        widget.viewModel.onBottomBarItemChanged(context, index, isEditEnabled);
      },
      childBuilder: (BuildContext childContext, MySizingInformation sizingInformation, MySizingInformation? parentSizingInformation) {
        double width = 1 * sizingInformation.localWidgetSize.width;

        return PlayerDetailLayout(
          seasonPlayer: tempSeasonPlayer,
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
      return EditModeRosterViewPlatformAppBar(title: title, onActionBack: () => onActionBack(context), onActionCancel: onActionCancel, onActionConfirm: () => onActionConfirm(context));
    } else {
      return ViewModeRosterViewPlatformAppBar(title: title, onActionBack: () => onActionBack(context), onActionEditPress: onActionEditPress, onActionNotesPress: () => onActionNotesPress(context));
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
      bool isValid = playerDetailController.savePlayerStatus();
      if(isValid) {
        await widget.viewModel.onPlayerSave(context, tempSeasonPlayer);
        setState(() {
          isEditEnabled = false;
        });
      }
    }
  }

  void onActionEditPress() {
    setState(() {
      isEditEnabled = true;
      initializeState();
    });
  }

  void onActionNotesPress(BuildContext context) {
    widget.viewModel.navigateToPlayerMatchesNotes(context);
  }

}
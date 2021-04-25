part of matches_view;

class _MatchesMobile extends StatefulWidget {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  
  final MatchesViewModel viewModel;

  _MatchesMobile(this.viewModel);
  
  @override
  State<StatefulWidget> createState() => _MatchesMobileState();

}

class _MatchesMobileState extends State<_MatchesMobile> {

  bool isEditEnabled;

  Match tempMatch;

  final MatchDetailController matchDetailController = MatchDetailController();

  void initializeState() {
    tempMatch = Match.clone(widget.viewModel.match);
  }

  @override
  void initState() {
    super.initState();
    isEditEnabled = widget.viewModel.isNewMatch;
    initializeState();
  }

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      initialIndex: TabScaffoldWidget.MATCHES_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) {
        widget.viewModel.onBottomBarItemChanged(context, index, isEditEnabled);
      },
      childBuilder: (BuildContext childContext, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {
        widget._baseScaffoldService.scaffoldContext = childContext;
        double width = 0.9 * sizingInformation.localWidgetSize.width;
        return _matchDetail(childContext, isEditEnabled, tempMatch, width, matchDetailController);
      },
    );
  }

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    String title = widget.viewModel.getAppBarTitle();
    if(isEditEnabled) {
      return EditModeMatchesViewPlatformAppBar(title: title, onActionBack: () => onActionBack(context), onActionCancel: onActionCancel, onActionConfirm: () => onActionConfirm(context));
    } else {
      return ViewModeMatchesViewPlatformAppBar(title: title, onActionBack: () => onActionBack(context), onActionEditPress: onActionEditPress);
    }
  }
  
  Widget _matchDetail(BuildContext context, bool isEditEnabled, Match match, double maxWidth, MatchDetailController matchDetailController) {
    return MatchDetailLayout(
      isEditEnabled: isEditEnabled,
      match: match,
      controller: matchDetailController,
      onTeamSuggestionCallback: (pattern) => widget.viewModel.suggestTeamsByPattern(pattern),
      onTeamInserted: (teamId) => widget.viewModel.loadTeamPlayers(teamId),
      onPlayersSuggestionCallback: (namePattern, surnamePattern, teamId) => widget.viewModel.suggestPlayersByPattern(namePattern, surnamePattern, teamId),
      onViewPlayerCardCallback: (playerId) => widget.viewModel.viewPlayerCard(context, playerId),
      onInsertNotesCallback: (match, matchPlayerData) => widget.viewModel.viewNotesCard(context, match, matchPlayerData),
      maxWidth: maxWidth,
    );
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
      bool isValid = matchDetailController.saveMatchStatus();
      if(isValid) {
        await widget.viewModel.onMatchSave(context, tempMatch);
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
  
}
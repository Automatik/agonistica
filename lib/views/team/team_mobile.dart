part of team_view;

class _TeamMobile extends StatefulWidget {

  final TeamViewModel viewModel;

  final int initialTabIndex;

  _TeamMobile(this.viewModel, this.initialTabIndex);

  @override
  State<StatefulWidget> createState() => _TeamMobileState();

}

class _TeamMobileState extends State<_TeamMobile> {

  int _tabIndex;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTabIndex ?? TabScaffoldWidget.MATCHES_VIEW_INDEX;
  }

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      initialIndex: _tabIndex,
      platformAppBar: AddActionPlatformAppBar(title: widget.viewModel.getWidgetTitle(), onActionTap: () {
        // on add action pressed
        if(_tabIndex == TabScaffoldWidget.MATCHES_VIEW_INDEX)
          widget.viewModel.addNewMatch(context);
        else
          widget.viewModel.addNewPlayer(context);
      }),
      onBottomItemChanged: (index) {
        setState(() {
          _tabIndex = index;
        });
      },
      childBuilder: (BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {
        if(_tabIndex == TabScaffoldWidget.MATCHES_VIEW_INDEX) {
          return _getMatchesLayout();
        }
        else {
          return _getRosterLayout();
        }
      },
    );
  }

  Widget _getBaseLayout(Widget Function(int, double) getItem, int itemCount) {
    return BaseWidget(
      builder: (BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {

        double itemsWidth = 0.95 * sizingInformation.screenSize.width;

        return Container(
          constraints: BoxConstraints(
            maxHeight: sizingInformation.screenSize.height,
            maxWidth: sizingInformation.screenSize.width,
          ),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: itemCount,
              itemBuilder: (BuildContext listContext, int index) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    width: itemsWidth,
                    child: getItem(index, itemsWidth),
                  ),
                );
              }
          ),
        );
      },
    );
  }

  Widget _getMatchesLayout() {
    return _getBaseLayout((index, itemsWidth) => _getMatchReview(index, itemsWidth), widget.viewModel.getMatchesSize());
  }

  Widget _getRosterLayout() {
    return _getBaseLayout((index, itemsWidth) => _getPlayerReview(index, itemsWidth), widget.viewModel.getSeasonPlayersSize());
  }

  Widget _getMatchReview(int index, double itemsWidth) {
    Match match = widget.viewModel.getMatch(index);
    return MatchReview(
      onTap: () => widget.viewModel.openMatchDetail(context, index),
      onSettingsTap: (offset) => onMatchLongPress(context, offset, index),
      width: itemsWidth,
      team1: match.getHomeSeasonTeamName(),
      team2: match.getAwaySeasonTeamName(),
      result: "${match.team1Goals} - ${match.team2Goals}",
      leagueMatch: match.leagueMatch,
      matchDate: match.matchDate,
    );
  }

  Widget _getPlayerReview(int index, double itemsWidth) {
    SeasonPlayer seasonPlayer = widget.viewModel.getSeasonPlayers(index);
    return PlayerReview(
      onTap: () => widget.viewModel.openPlayerDetail(context, index),
      onSettingsTap: (offset) => onRosterLongPress(context, offset, index),
      name: "${seasonPlayer.getPlayerName()} ${seasonPlayer.getPlayerSurname()}",
      role: SeasonPlayer.positionToString(seasonPlayer.position),
      width: itemsWidth,
      birthDay: seasonPlayer.getPlayerBirthday(),
    );
  }

  Future<void> onMatchLongPress(BuildContext context, Offset offset, int index) async {
    await onItemLongPress(context, offset, index, TeamViewPopupMenu.VIEW_MATCH_CARD, TeamViewPopupMenu.DELETE_MATCH_CARD);
  }

  Future<void> onRosterLongPress(BuildContext context, Offset offset, int index) async {
    await onItemLongPress(context, offset, index, TeamViewPopupMenu.VIEW_PLAYER_CARD, TeamViewPopupMenu.DELETE_PLAYER_CARD);
  }

  Future<void> onItemLongPress(BuildContext context, Offset offset, int index, int viewItemValue, int deleteItemValue) async {
    final popupMenu = TeamViewPopupMenu(
      offset: offset,
      itemValues: [viewItemValue, deleteItemValue]
    );

    int value = await popupMenu.showPopupMenu(context);
    selectLongClickAction(context, value, index);
  }

  void selectLongClickAction(BuildContext context, int choice, int index) {
    switch(choice) {
      case TeamViewPopupMenu.VIEW_MATCH_CARD: widget.viewModel.openMatchDetail(context, index); break;
      case TeamViewPopupMenu.VIEW_PLAYER_CARD: widget.viewModel.openPlayerDetail(context, index); break;
      case TeamViewPopupMenu.DELETE_MATCH_CARD: widget.viewModel.deleteMatch(index); break;
      case TeamViewPopupMenu.DELETE_PLAYER_CARD: widget.viewModel.deletePlayer(index); break;
      default: return;
    }
  }

}
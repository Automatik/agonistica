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

  void onUpdateList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      initialIndex: _tabIndex,
      platformAppBar: PlatformAppBars.getPlatformAppBarWithAddAction(widget.viewModel.getWidgetTitle(), () {
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

  Widget _getMatchesLayout() {
    return BaseWidget(
      builder: (BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {

        double itemsWidth = 0.7 * sizingInformation.screenSize.width;

        return Container(
          constraints: BoxConstraints(
            maxHeight: sizingInformation.screenSize.height,
            maxWidth: sizingInformation.screenSize.width,
          ),
          child: ListView.builder(
//              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.viewModel.matches.length,
              itemBuilder: (BuildContext listContext, int index) {
                Match match = widget.viewModel.matches[index];
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: itemsWidth,
                    child: MatchReview(
                      onTap: () {
                        widget.viewModel.openMatchDetail(context, index, onUpdateList);
                      },
                      width: itemsWidth,
                      team1: match.team1Name,
                      team2: match.team2Name,
                      result: "${match.team1Goals} - ${match.team2Goals}",
                      leagueMatch: match.leagueMatch,
                      matchDate: match.matchDate,
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }

  Widget _getRosterLayout() {
    return BaseWidget(
      builder: (BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {

        double itemsWidth = 0.7 * sizingInformation.screenSize.width;

        return Container(
          constraints: BoxConstraints(
            maxHeight: sizingInformation.screenSize.height,
            maxWidth: sizingInformation.screenSize.width,
          ),
          child: ListView.builder(
//              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.viewModel.players.length,
              itemBuilder: (BuildContext listContext, int index) {
                Player player = widget.viewModel.players[index];
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: itemsWidth,
                    child: PlayerReview(
                      onTap: () => widget.viewModel.openPlayerDetail(context, index, onUpdateList),
                      name: "${player.name} ${player.surname}",
                      role: Player.positionToString(player.position),
                      width: itemsWidth,
                      birthDay: player.birthDay,
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }

}
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
      showAppBar: true,
      initialIndex: _tabIndex,
      platformAppBar: Utils.getPlatformAppBarWithAddAction(widget.viewModel.getWidgetTitle(), () {
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
      childBuilder: (BuildContext context, MySizingInformation sizingInformation) {
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
      builder: (BuildContext context, MySizingInformation sizingInformation) {

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
                        widget.viewModel.openMatchDetail(context, index);
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
      builder: (BuildContext context, MySizingInformation sizingInformation) {

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
                      onTap: () => widget.viewModel.openPlayerDetail(context, index),
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

  Widget _getMatchDetailOld() {

    String team1 = "Merate";
    String team2 = "Robbiate";
    String result = "2-1";
    int leagueMatch = 1;
    DateTime matchDate = DateTime.utc(2020, 09, 6, 21);


    return BaseWidget(
      builder: (BuildContext context, MySizingInformation sizingInformation) {

        double widgetWidth = 0.95 * sizingInformation.screenSize.width;
        double minHeight = 50;

        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: widgetWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(
                    minHeight: minHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 12, right: 5, top: 10),
                            child: SvgPicture.asset(
                              'assets/images/010-football.svg',
                              width: 30,
                              height: 30,
                              color: blueAgonisticaColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 10, right: 20),
                              alignment: Alignment.center,
                              child: Text(
                                team1 + " " + result + " " + team2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 12, top: 10, bottom: 10),
                              child: Text(
                                "Giornata $leagueMatch",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 15, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.calendar_today, color: blueAgonisticaColor, size: 24,),
                                  SizedBox(width: 5,),
                                  Text(
                                    "${matchDate.day} " + Utils.monthToString(matchDate.month).substring(0, 4) + " ${matchDate.year}",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 150,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
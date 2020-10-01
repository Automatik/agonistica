part of team_view;

class _TeamMobile extends StatefulWidget {

  final TeamViewModel viewModel;

  final _baseScaffoldService = locator<BaseScaffoldService>();

  _TeamMobile(this.viewModel);

  @override
  State<StatefulWidget> createState() => _TeamMobileState();

}

class _TeamMobileState extends State<_TeamMobile> {

  bool _isDetailPageOpen;

  @override
  void initState() {
    super.initState();
    _isDetailPageOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      title: "Juniores",
      onBottomItemChanged: () {
        setState(() {
          _isDetailPageOpen = false;
        });
      },
      childBuilder: (BuildContext context, MySizingInformation sizingInformation) {
        if(widget._baseScaffoldService.bottomBarSelectedIndex == TabScaffoldWidget.MATCHES_VIEW_INDEX) {
          if(_isDetailPageOpen) {
            Match match = Match();
            match.team1Name = "Merate";
            match.team2Name = "Robbiate";
            match.team1Goals = 2;
            match.team2Goals = 1;
            match.leagueMatch = 1;
            match.matchDate = DateTime.utc(2020, 09, 28);

            double width = 0.9 * sizingInformation.localWidgetSize.width;
            return _getMatchDetail(match, width);
          } else {
            return _getMatchesLayout();
          }
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
              itemCount: 5,
              itemBuilder: (BuildContext listContext, int index) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: itemsWidth,
                    child: MatchReview(
                      onTap: () {
                        setState(() {
                          _isDetailPageOpen = true;
                        });
                      },
                      width: itemsWidth,
                      team1: "Merate",
                      team2: "Robbiate",
                      result: "2-1",
                      leagueMatch: 1,
                      matchDate: DateTime.utc(2020, 09, 6),
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
              itemCount: 5,
              itemBuilder: (BuildContext listContext, int index) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: itemsWidth,
                    child: PlayerReview(
                      name: "Mario Rossi",
                      role: "Attaccante",
                      width: itemsWidth,
                      birthDay: DateTime.utc(1996, 09, 6, 21),
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }

  Widget _getMatchDetail(Match match, double width) {
    return MatchDetailLayout(
      isNewMatch: false,
      match: match,
      maxWidth: width,
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
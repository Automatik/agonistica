part of team_view;

// ignore: must_be_immutable
class _TeamMobile extends StatelessWidget {

  final TeamViewModel viewModel;

  final _baseScaffoldService = locator<BaseScaffoldService>();

  _TeamMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      title: "Juniores",
      childBuilder: (BuildContext context, MySizingInformation sizingInformation) {
        if(_baseScaffoldService.bottomBarSelectedIndex == TabScaffoldWidget.MATCHES_VIEW_INDEX)
          return _getMatchesLayout();
        else
          return _getRosterLayout();
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
                      width: itemsWidth,
                      team1: "Merate",
                      team2: "Robbiate",
                      result: "2-1",
                      leagueMatch: 1,
                      matchDate: DateTime.utc(2020, 09, 6, 21),
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
}
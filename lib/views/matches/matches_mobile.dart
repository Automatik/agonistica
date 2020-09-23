part of matches_view;

// ignore: must_be_immutable
class _MatchesMobile extends StatelessWidget {
  final MatchesViewModel viewModel;

  _MatchesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      showAppBar: true,
      title: viewModel.getAppBarTitle(),
      childBuilder: (BuildContext context, MySizingInformation sizingInformation) {

        double itemsWidth = 0.7 * sizingInformation.screenSize.width;

        return Container(
//            width: itemsWidth,
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
}
part of roster_view;

// ignore: must_be_immutable
class _RosterMobile extends StatelessWidget {
  final RosterViewModel viewModel;

  _RosterMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
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
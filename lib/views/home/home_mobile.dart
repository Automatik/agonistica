part of home_view;

// ignore: must_be_immutable
class _HomeMobile extends StatelessWidget {

  final HomeViewModel viewModel;
  final double merateButtonHeight = 110;

  _HomeMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      showAppBar: false,
      childBuilder: (context, sizingInformation) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: sizingInformation.screenSize.height,
            maxWidth: sizingInformation.screenSize.width,
          ),
          child: homeLayout(context, sizingInformation),
        );
      },
    );
  }

  Widget homeLayout(BuildContext context, MySizingInformation sizingInformation) {
    return sizingInformation.isPortrait()
        ? homePortraitLayout(context, sizingInformation)
        : homeLandscapeLayout(context, sizingInformation);
  }

  Widget homePortraitLayout(BuildContext context, MySizingInformation sizingInformation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        mainTitleWidget(100),
        mainButtonWidget(context, sizingInformation),
        otherPlayersText(50, 24),
        otherPlayersListWidget(sizingInformation),
      ],
    );
  }

  Widget homeLandscapeLayout(BuildContext context, MySizingInformation sizingInformation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        mainTitleWidget(50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mainButtonWidget(context, sizingInformation),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                otherPlayersText(20, 20),
                otherPlayersListWidget(sizingInformation),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget mainTitleWidget(double marginTop) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      alignment: Alignment.center,
      child: Text(
        defaultAppBarTitle.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget mainButtonWidget(BuildContext context, MySizingInformation sizingInformation) {

    double widthFactor = sizingInformation.isPortrait() ? 0.6 : 0.35;
    double width = widthFactor * sizingInformation.screenSize.width;

    double marginTop = sizingInformation.isPortrait() ? 50 : 0;

    return GestureDetector(
      onTap: () => viewModel.onMainButtonTap(context),
      child: Container(
        margin: EdgeInsets.only(top: marginTop),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        width: width,
        height: merateButtonHeight,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/prinetti.png',
              height: merateButtonHeight,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                mainButtonTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget otherPlayersText(double marginTop, double fontSize) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      alignment: Alignment.center,
      child: Text(
        'Altri giocatori seguiti',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget otherPlayersListWidget(MySizingInformation sizingInformation) {

    double widthFactor = sizingInformation.isPortrait() ? 0.6 : 0.3;
    double width = widthFactor * sizingInformation.screenSize.width;

    double marginTopFactor = sizingInformation.isPortrait() ? 20 : 10;

    return Container(
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: viewModel.otherPlayersList.length,
        itemBuilder: (BuildContext listContext, int index) {
          return GestureDetector(
            onTap: () => viewModel.onOtherPlayersTap(listContext, index),
            child: Container(
              margin: EdgeInsets.only(top: marginTopFactor),
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                viewModel.otherPlayersList[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
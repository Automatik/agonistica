part of home_view;

class _HomeMobile extends StatelessWidget {

  final HomeViewModel viewModel;
  final double mainButtonHeight = 150;

  _HomeMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ScrollScaffoldWidget(
      showAppBar: false,
      childBuilder: (context, sizingInformation, parentSizingInformation) {
        return Container(
          constraints: BoxConstraints(
            minHeight: parentSizingInformation.localWidgetSize.height,
            minWidth: sizingInformation.screenSize.width,
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
        mainTitleWidget(context, 100),
        mainButtonWidget(context, sizingInformation),
        otherPlayersText(context, 50, 24),
        otherPlayersListWidget(sizingInformation),
      ],
    );
  }

  Widget homeLandscapeLayout(BuildContext context, MySizingInformation sizingInformation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        mainTitleWidget(context, 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mainButtonWidget(context, sizingInformation),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                otherPlayersText(context, 20, 20),
                otherPlayersListWidget(sizingInformation),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget mainTitleWidget(BuildContext context, double marginTop) {
    var textStyle = Theme.of(context).textTheme.bodyText2;
    textStyle = textStyle.merge(TextStyle(color: Colors.white, fontSize: 48));
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      alignment: Alignment.center,
      child: Text(
        defaultAppBarTitle.toUpperCase(),
        textAlign: TextAlign.center,
        style: textStyle
      ),
    );
  }

  Widget mainButtonWidget(BuildContext context, MySizingInformation sizingInformation) {

    double widthFactor = sizingInformation.isPortrait() ? 0.95 : 0.35;
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
        height: mainButtonHeight,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.IMAGE_PRINETTI,
              height: mainButtonHeight,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                viewModel.getMainMenuName(),
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

  Widget otherPlayersText(BuildContext context, double marginTop, double fontSize) {
    var textStyle = Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.white, fontSize: 32));
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      alignment: Alignment.center,
      child: Text(
        'Altri giocatori seguiti',
        textAlign: TextAlign.center,
        style: textStyle
      ),
    );
  }

  Widget otherPlayersListWidget(MySizingInformation sizingInformation) {

    double widthFactor = sizingInformation.isPortrait() ? 0.95 : 0.3;
    double width = widthFactor * sizingInformation.screenSize.width;

    double marginTopFactor = sizingInformation.isPortrait() ? 20 : 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: viewModel.getOtherMenusCount(),
        itemBuilder: (BuildContext listContext, int index) {
          double itemTopMargin = index == 0 ? 0 : marginTopFactor;
          return GestureDetector(
            onTap: () => viewModel.onOtherPlayersTap(listContext, index),
            child: Container(
              margin: EdgeInsets.only(top: itemTopMargin),
              height: 65, //35
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                viewModel.getOtherMenuName(index),
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
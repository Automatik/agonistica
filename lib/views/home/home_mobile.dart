part of home_view;

class _HomeMobile extends StatelessWidget {

  final HomeViewModel viewModel;
  final double imageMenuCardHeight = 150;

  _HomeMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ScrollScaffoldWidget(
      showAppBar: true,
      platformAppBar: getPlatformAppBar(),
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

  PlatformAppBar getPlatformAppBar() {
    return AddActionPlatformAppBar(
      title: viewModel.getAppBarTitle(),
      onActionTap: null, // TODO OnActionTap
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
        followedTeamsMenusTitle(context),
        followedTeamsMenusWidget(sizingInformation),
        followedPlayersMenusTitle(context),
        followedPlayersMenusWidget(sizingInformation),
      ],
    );
  }

  Widget homeLandscapeLayout(BuildContext context, MySizingInformation sizingInformation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        followedTeamsMenusTitle(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            followedTeamsMenusWidget(sizingInformation),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                followedPlayersMenusTitle(context),
                followedPlayersMenusWidget(sizingInformation),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget followedTeamsMenusTitle(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyText2;
    textStyle = textStyle.merge(TextStyle(color: Colors.white, fontSize: 32));
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Text(
          "Squadre seguite",
          textAlign: TextAlign.center,
          style: textStyle
      ),
    );
  }

  Widget followedPlayersMenusTitle(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.white, fontSize: 32));
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Text(
          'Altri giocatori seguiti',
          textAlign: TextAlign.center,
          style: textStyle
      ),
    );
  }

  Widget followedTeamsMenusWidget(MySizingInformation sizingInformation) {
    double widthFactor = sizingInformation.isPortrait() ? 0.95 : 0.3;
    double width = widthFactor * sizingInformation.screenSize.width;

    double marginTopFactor = sizingInformation.isPortrait() ? 20 : 10;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: viewModel.getFollowedTeamsMenusSize(),
        itemBuilder: (BuildContext listContext, int index) {
          Menu menu = viewModel.getFollowedTeamMenu(index);
          double itemTopMargin = index == 0 ? 0 : marginTopFactor;
          return ImageMenuCard(
            onTap: () => viewModel.onFollowedTeamMenuTap(listContext, index),
            imageAsset: MenuAssets.getRandomImage(),
            title: menu.name,
            width: width,
            height: imageMenuCardHeight
          );
        },
      ),
    );
  }

  Widget followedPlayersMenusWidget(MySizingInformation sizingInformation) {
    double widthFactor = sizingInformation.isPortrait() ? 0.95 : 0.3;
    double width = widthFactor * sizingInformation.screenSize.width;

    double marginTopFactor = sizingInformation.isPortrait() ? 20 : 10;

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: viewModel.getFollowedPlayersMenusSize(),
        itemBuilder: (BuildContext listContext, int index) {
          Menu menu = viewModel.getFollowedPlayerMenu(index);
          double itemTopMargin = index == 0 ? 0 : marginTopFactor;
          return ImageMenuCard(
              onTap: () => viewModel.onFollowedPlayerMenuTap(listContext, index),
              imageAsset: MenuAssets.getRandomImage(),
              title: menu.name,
              width: width,
              height: imageMenuCardHeight
          );
        },
      ),
    );
  }
}
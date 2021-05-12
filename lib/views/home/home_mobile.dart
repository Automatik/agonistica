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
        followedTeamsMenusWidget(sizingInformation, Axis.vertical),
        followedPlayersMenusTitle(context),
        followedPlayersMenusWidget(sizingInformation, Axis.vertical),
      ],
    );
  }

  Widget homeLandscapeLayout(BuildContext context, MySizingInformation sizingInformation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        followedTeamsMenusTitle(context),
        followedTeamsMenusWidget(sizingInformation, Axis.horizontal),
        followedPlayersMenusTitle(context),
        followedPlayersMenusWidget(sizingInformation, Axis.horizontal),
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

  Widget followedTeamsMenusWidget(MySizingInformation sizingInformation, Axis axis) {
    return listMenusWidget(
      sizingInformation: sizingInformation,
      axis: axis,
      itemCount: viewModel.getFollowedTeamsMenusSize(),
      itemBuilder: (context, index, width) => followedTeamsMenusBuilder(context, index, width, axis),
    );
  }

  Widget followedPlayersMenusWidget(MySizingInformation sizingInformation, Axis axis) {
    return listMenusWidget(
      sizingInformation: sizingInformation,
      axis: axis,
      itemCount: viewModel.getFollowedPlayersMenusSize(),
      itemBuilder: (context, index, width) => followedPlayersMenusBuilder(context, index, width, axis),
    );
  }

  Widget followedTeamsMenusBuilder(BuildContext context, int index, double width, Axis axis) {
    Menu menu = viewModel.getFollowedTeamMenu(index);
    return menuBuilder(menu.name, width, () => viewModel.onFollowedTeamMenuTap(context, index), axis);
  }

  Widget followedPlayersMenusBuilder(BuildContext context, int index, double width, Axis axis) {
    Menu menu = viewModel.getFollowedPlayerMenu(index);
    return menuBuilder(menu.name, width, () => viewModel.onFollowedPlayerMenuTap(context, index), axis);
  }

  Widget menuBuilder(String title, double width, Function onTap, Axis axis) {
    bool isPortrait = axis == Axis.vertical;
    return ImageMenuCard(
      onTap: onTap,
      imageAsset: MenuAssets.getRandomImage(),
      title: title,
      width: width,
      height: imageMenuCardHeight,
      useWhiteBackground: true,
      useVerticalMargin: isPortrait,
    );
  }

  Widget listMenusWidget({MySizingInformation sizingInformation, Axis axis, int itemCount, Widget Function(BuildContext, int, double) itemBuilder}) {
    double widthFactor = sizingInformation.isPortrait() ? 0.95 : 0.95;
    double listWidth = widthFactor * sizingInformation.screenSize.width;
    bool isPortrait = sizingInformation.isPortrait();
    double imageWidth = isPortrait ? listWidth : 0.55 * sizingInformation.screenSize.width;
    return Container(
      margin: getListMargin(isPortrait),
      width: listWidth,
      height: isPortrait ? null : imageMenuCardHeight,
      alignment: Alignment.center,
      child: ListView.builder(
        shrinkWrap: true,
        physics: isPortrait ? NeverScrollableScrollPhysics() : null,
        scrollDirection: axis,
        itemCount: itemCount,
        itemBuilder: (BuildContext listContext, int index) => itemBuilder(listContext, index, imageWidth),
      ),
    );
  }

  EdgeInsets getListMargin(bool isPortrait) {
    if(isPortrait) {
      return const EdgeInsets.symmetric(vertical: 20);
    }
    return EdgeInsets.symmetric(vertical: 20);
  }

}
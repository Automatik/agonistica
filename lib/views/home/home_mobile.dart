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
    return homeWidgets(context, sizingInformation, Axis.vertical);
  }

  Widget homeLandscapeLayout(BuildContext context, MySizingInformation sizingInformation) {
    return homeWidgets(context, sizingInformation, Axis.horizontal);
  }

  Widget homeWidgets(BuildContext context, MySizingInformation sizingInformation, Axis axis) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        followedTeamsMenusTitle(context),
        followedTeamsMenusWidget(sizingInformation, axis),
        followedPlayersMenusTitle(context),
        followedPlayersMenusWidget(sizingInformation, axis),
      ],
    );
  }

  Widget followedTeamsMenusTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Text(
          MyStrings.HOME_VIEW_TITLE_FOLLOWED_TEAMS,
          textAlign: TextAlign.center,
          style: TitleTextStyle(context: context).compose()
      ),
    );
  }

  Widget followedPlayersMenusTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0),
      alignment: Alignment.center,
      child: Text(
          MyStrings.HOME_VIEW_TITLE_FOLLOWED_PLAYERS,
          textAlign: TextAlign.center,
          style: TitleTextStyle(context: context).compose()
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
      margin: const EdgeInsets.symmetric(vertical: 20),
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

}
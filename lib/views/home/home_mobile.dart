// @dart=2.9

part of home_view;

class _HomeMobile extends StatelessWidget {

  static const String EMPTY_TITLE_FOLLOWED_TEAM = "Aggiungi squadra";
  static const String EMPTY_TITLE_FOLLOWED_PLAYERS = "Aggiungi macro categoria";

  final HomeViewModel viewModel;
  final double imageMenuCardHeight = 150;

  _HomeMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ScrollScaffoldWidget(
      showAppBar: true,
      platformAppBar: getPlatformAppBar(context),
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

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    return AddActionPlatformAppBar(
      title: viewModel.getAppBarTitle(),
      onActionTapDown: (tapDownDetails) => onActionAdd(context, tapDownDetails.globalPosition),
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
        followedTeamsMenusWidget(context, sizingInformation, axis),
        followedPlayersMenusTitle(context),
        followedPlayersMenusWidget(context, sizingInformation, axis),
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

  Widget followedTeamsMenusWidget(BuildContext context, MySizingInformation sizingInformation, Axis axis) {
    return listMenusWidget(
      sizingInformation: sizingInformation,
      axis: axis,
      itemCount: viewModel.getFollowedTeamsMenusSize(),
      itemBuilder: (context, index, width) => followedTeamsMenusBuilder(context, index, width, axis),
      emptyTitle: EMPTY_TITLE_FOLLOWED_TEAM,
      onEmptyTap: () => showInsertFollowedTeamMenuDialog(context)
    );
  }

  Widget followedPlayersMenusWidget(BuildContext context, MySizingInformation sizingInformation, Axis axis) {
    return listMenusWidget(
      sizingInformation: sizingInformation,
      axis: axis,
      itemCount: viewModel.getFollowedPlayersMenusSize(),
      itemBuilder: (context, index, width) => followedPlayersMenusBuilder(context, index, width, axis),
      emptyTitle: EMPTY_TITLE_FOLLOWED_PLAYERS,
      onEmptyTap: () => showInsertFollowedPlayersMenuDialog(context)
    );
  }

  Widget followedTeamsMenusBuilder(BuildContext context, int index, double width, Axis axis) {
    Menu menu = viewModel.getFollowedTeamMenu(index);
    return menuBuilder(menu.name, menu.imageFilename, width, () => viewModel.onFollowedTeamMenuTap(context, index), axis);
  }

  Widget followedPlayersMenusBuilder(BuildContext context, int index, double width, Axis axis) {
    Menu menu = viewModel.getFollowedPlayerMenu(index);
    return menuBuilder(menu.name, menu.imageFilename, width, () => viewModel.onFollowedPlayerMenuTap(context, index), axis);
  }

  Widget menuBuilder(String title, String imageAsset, double width, Function onTap, Axis axis) {
    bool isPortrait = axis == Axis.vertical;
    return ImageMenuCard(
      onTap: onTap,
      imageAsset: imageAsset,
      title: title,
      width: width,
      height: imageMenuCardHeight,
      useWhiteBackground: true,
      useVerticalMargin: isPortrait,
    );
  }

  Widget listMenusWidget({MySizingInformation sizingInformation, Axis axis, int itemCount, Widget Function(BuildContext, int, double) itemBuilder, String emptyTitle, Function onEmptyTap}) {
    double widthFactor = sizingInformation.isPortrait() ? 0.95 : 0.95;
    double listWidth = widthFactor * sizingInformation.screenSize.width;
    bool isPortrait = sizingInformation.isPortrait();
    double imageWidth = isPortrait ? listWidth : 0.55 * sizingInformation.screenSize.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: listWidth,
      height: isPortrait ? null : imageMenuCardHeight,
      alignment: Alignment.center,
      child: listMenusContent(axis, isPortrait, imageWidth, itemCount, itemBuilder, emptyTitle, onEmptyTap)
    );
  }

  Widget listMenusContent(Axis axis, bool isPortrait, double imageWidth, int itemCount, Widget Function(BuildContext, int, double) itemBuilder, String emptyTitle, Function onEmptyTap) {
    if(itemCount == 0) {
      return emptyMenu(emptyTitle, imageWidth, onEmptyTap);
    }
    return listMenusBuilder(axis, isPortrait, imageWidth, itemCount, itemBuilder);
  }

  Widget listMenusBuilder(Axis axis, bool isPortrait, double imageWidth, int itemCount, Widget Function(BuildContext, int, double) itemBuilder) {
    return ListView.builder(
      shrinkWrap: true,
      physics: isPortrait ? NeverScrollableScrollPhysics() : null,
      scrollDirection: axis,
      itemCount: itemCount,
      itemBuilder: (BuildContext listContext, int index) => itemBuilder(listContext, index, imageWidth),
    );
  }

  Widget emptyMenu(String emptyTitle, double imageWidth, Function onEmptyTap) {
    return EmptyMenuCard(
      title: emptyTitle,
      width: imageWidth,
      height: imageMenuCardHeight,
      onTap: onEmptyTap,
    );
  }

  Future<void> onActionAdd(BuildContext context, Offset offset) async {
    final popupMenu = HomeViewPopupMenu(offset: offset);
    int menuType = await popupMenu.showPopupMenu(context);
    if(menuType == Menu.TYPE_FOLLOWED_TEAMS) {
      await showInsertFollowedTeamMenuDialog(context);
      return;
    }
    if(menuType == Menu.TYPE_FOLLOWED_PLAYERS) {
      await showInsertFollowedPlayersMenuDialog(context);
      return;
    }
  }

  Future<void> showInsertFollowedTeamMenuDialog(BuildContext context) async {
    final dialog = InsertFollowedTeamMenuDialog(
        validateInput: (menuName) {
          return viewModel.validateNewMenu(menuName);
        },
        onSubmit: (menuName) {
          viewModel.createNewMenu(menuName, Menu.TYPE_FOLLOWED_TEAMS);
          // close dialog
          Navigator.of(context).pop();
        }
    );
    await dialog.showInsertDialog(context);
  }

  Future<void> showInsertFollowedPlayersMenuDialog(BuildContext context) async {
    final dialog = InsertFollowedPlayersMenuDialog(
      validateInput: (menuName) {
        return viewModel.validateNewMenu(menuName);
      },
      onSubmit: (menuName) {
        viewModel.createNewMenu(menuName, Menu.TYPE_FOLLOWED_PLAYERS);
        // close dialog
        Navigator.of(context).pop();
      }
    );
    await dialog.showInsertDialog(context);
  }

}
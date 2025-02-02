part of players_view;

class _PlayersMobile extends StatelessWidget {

  final PlayersViewModel viewModel;

  _PlayersMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ScrollScaffoldWidget(
      platformAppBar: AddActionPlatformAppBar(title: viewModel.getWidgetTitle(), onActionTap: () {
        // on add action pressed
        viewModel.addNewPlayer(context);
      }),
      showAppBar: true,
      childBuilder: (BuildContext ctx, MySizingInformation sizingInformation, MySizingInformation? parentSizingInformation) {
        return _getPlayersLayout(ctx, sizingInformation);
      },
    );
  }

  Widget _getPlayersLayout(BuildContext context, MySizingInformation sizingInformation) {
    double itemsWidth = 0.95 * sizingInformation.screenSize.width;

    return Container(
      constraints: BoxConstraints(
        maxHeight: sizingInformation.screenSize.height,
        maxWidth: sizingInformation.screenSize.width,
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: viewModel.getSeasonPlayersSize(),
          itemBuilder: (BuildContext listContext, int index) {
            SeasonPlayer seasonPlayer = viewModel.getSeasonPlayers(index);
            return Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                width: itemsWidth,
                child: PlayerReview(
                  onTap: () => viewModel.openPlayerDetail(context, index),
                  onSettingsTap: (offset) => onItemLongPress(context, offset, index),
                  name: "${seasonPlayer.getPlayerName()} ${seasonPlayer.getPlayerSurname()}",
                  role: SeasonPlayer.positionToString(seasonPlayer.position),
                  width: itemsWidth,
                  birthDay: seasonPlayer.getPlayerBirthday()!,
                ),
              ),
            );
          }
      ),
    );
  }

  Future<void> onItemLongPress(BuildContext context, Offset offset, int index) async {
    final popupMenu = PlayersViewPopupMenu(
        offset: offset,
        itemValues: [
          PlayersViewPopupMenu.VIEW_PLAYER_CARD,
          PlayersViewPopupMenu.DELETE_PLAYER_CARD
        ]
    );

    int? value = await popupMenu.showPopupMenu(context);
    selectLongClickAction(context, value, index);
  }

  void selectLongClickAction(BuildContext context, int? choice, int index) {
    switch(choice) {
      case PlayersViewPopupMenu.VIEW_PLAYER_CARD: viewModel.openPlayerDetail(context, index); break;
      case PlayersViewPopupMenu.DELETE_PLAYER_CARD: viewModel.deletePlayer(index); break;
      default: return;
    }
  }

}
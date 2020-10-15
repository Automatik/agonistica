part of roster_view;

class _RosterMobile extends StatelessWidget {

  final RosterViewModel viewModel;

  final bool isNewPlayer;
  final Player player;
  final Function(Player) onPlayerDetailUpdate;

  _RosterMobile(this.viewModel, this.isNewPlayer, this.player, this.onPlayerDetailUpdate);

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      title: isNewPlayer ? "Nuovo Giocatore" : viewModel.getAppBarTitle(player),
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      onBottomItemChanged: (index) {
        viewModel.onBottomBarItemChanged(context, index);
      },
      childBuilder: (BuildContext childContext, MySizingInformation sizingInformation) {

        double width = 0.9 * sizingInformation.localWidgetSize.width;

        return PlayerDetailLayout(
          isNewPlayer: isNewPlayer,
          player: player,
          onSave: (p) => viewModel.onPlayerSave(context, p, onPlayerDetailUpdate),
          maxWidth: width,
        );
      },
    );
  }
}
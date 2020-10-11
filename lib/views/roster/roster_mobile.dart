part of roster_view;

class _RosterMobile extends StatelessWidget {

  final RosterViewModel viewModel;

  final bool isNewPlayer;
  final Player player;

  _RosterMobile(this.viewModel, this.isNewPlayer, this.player);

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      title: isNewPlayer ? "Nuovo Giocatore" : viewModel.getAppBarTitle(),
      onBottomItemChanged: (index) {
        viewModel.onBottomBarItemChanged(context, index);
      },
      childBuilder: (BuildContext childContext, MySizingInformation sizingInformation) {
        return PlayerDetailLayout();
      },
    );
  }
}
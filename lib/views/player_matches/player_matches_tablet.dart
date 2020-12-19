part of player_matches_view;

// ignore: must_be_immutable
class _PlayerMatchesTablet extends StatelessWidget {
  final PlayerMatchesViewModel viewModel;

  _PlayerMatchesTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('PlayerMatchesTablet')),
    );
  }
}
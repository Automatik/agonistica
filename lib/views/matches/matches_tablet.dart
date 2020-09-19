part of matches_view;

// ignore: must_be_immutable
class _MatchesTablet extends StatelessWidget {
  final MatchesViewModel viewModel;

  _MatchesTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('MatchesTablet')),
    );
  }
}
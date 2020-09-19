part of matches_view;

// ignore: must_be_immutable
class _MatchesMobile extends StatelessWidget {
  final MatchesViewModel viewModel;

  _MatchesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('MatchesMobile')),
    );
  }
}
part of matches_view;

// ignore: must_be_immutable
class _MatchesDesktop extends StatelessWidget {
  final MatchesViewModel viewModel;

  _MatchesDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('MatchesDesktop')),
    );
  }
}
part of roster_view;

// ignore: must_be_immutable
class _RosterTablet extends StatelessWidget {
  final RosterViewModel viewModel;

  _RosterTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('RosterTablet')),
    );
  }
}
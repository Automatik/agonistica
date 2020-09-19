part of roster_view;

// ignore: must_be_immutable
class _RosterDesktop extends StatelessWidget {
  final RosterViewModel viewModel;

  _RosterDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('RosterDesktop')),
    );
  }
}
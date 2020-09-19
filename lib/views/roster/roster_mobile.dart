part of roster_view;

// ignore: must_be_immutable
class _RosterMobile extends StatelessWidget {
  final RosterViewModel viewModel;

  _RosterMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('RosterMobile')),
    );
  }
}
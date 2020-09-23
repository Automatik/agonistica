part of team_view;

// ignore: must_be_immutable
class _TeamTablet extends StatelessWidget {
  final TeamViewModel viewModel;

  _TeamTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('TeamTablet')),
    );
  }
}
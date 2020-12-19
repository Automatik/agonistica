part of notes_view;

// ignore: must_be_immutable
class _NotesTablet extends StatelessWidget {
  final NotesViewModel viewModel;

  _NotesTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('NotesTablet')),
    );
  }
}
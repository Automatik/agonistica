part of categories_view;

// ignore: must_be_immutable
class _CategoriesDesktop extends StatelessWidget {
  final CategoriesViewModel viewModel;

  _CategoriesDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('CategoriesDesktop')),
    );
  }
}
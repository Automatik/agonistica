part of categories_view;

// ignore: must_be_immutable
class _CategoriesTablet extends StatelessWidget {
  final CategoriesViewModel viewModel;

  _CategoriesTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('CategoriesTablet')),
    );
  }
}
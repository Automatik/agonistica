part of categories_view;

// ignore: must_be_immutable
class _CategoriesMobile extends StatelessWidget {
  final CategoriesViewModel viewModel;

  _CategoriesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('CategoriesMobile')),
    );
  }
}
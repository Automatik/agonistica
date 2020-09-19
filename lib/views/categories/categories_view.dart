library categories_view;

import 'package:agonistica/core/shared/base_scaffold_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'categories_view_model.dart';

part 'categories_mobile.dart';
part 'categories_tablet.dart';

// ignore: must_be_immutable
class CategoriesView extends StatelessWidget {
  static const routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () => CategoriesViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _CategoriesMobile(viewModel),
          tablet: _CategoriesMobile(viewModel),
        );
      }
    );
  }
}
library home_view;

import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/widgets/scaffolds/scroll_scaffold_widget.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _HomeMobile(viewModel),
          tablet: _HomeMobile(viewModel),
        );
      }
    );
  }
}
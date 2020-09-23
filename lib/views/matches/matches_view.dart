library matches_view;

import 'package:agonistica/core/shared/base_scaffold_widget.dart';
import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/match_review.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'matches_view_model.dart';

part 'matches_mobile.dart';
part 'matches_tablet.dart';

// ignore: must_be_immutable
class MatchesView extends StatelessWidget {
  static const routeName = '/matches';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MatchesViewModel>.reactive(
      viewModelBuilder: () => MatchesViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _MatchesMobile(viewModel),
          tablet: _MatchesMobile(viewModel),
        );
      }
    );
  }
}
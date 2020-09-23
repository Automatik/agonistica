library roster_view;

import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/player_review.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'roster_view_model.dart';

part 'roster_mobile.dart';
part 'roster_tablet.dart';

// ignore: must_be_immutable
class RosterView extends StatelessWidget {
  static const routeName = '/roster';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RosterViewModel>.reactive(
      viewModelBuilder: () => RosterViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _RosterMobile(viewModel),
          tablet: _RosterMobile(viewModel),
        );
      }
    );
  }
}
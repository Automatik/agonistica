library team_view;

import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/match_review.dart';
import 'package:agonistica/core/shared/player_review.dart';
import 'package:agonistica/core/shared/tab_scaffold_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'team_view_model.dart';

part 'team_mobile.dart';
part 'team_tablet.dart';

// ignore: must_be_immutable
class TeamView extends StatelessWidget {
  static const routeName = '/team';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeamViewModel>.reactive(
      viewModelBuilder: () => TeamViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _TeamMobile(viewModel),
          tablet: _TeamMobile(viewModel),
        );
      }
    );
  }
}
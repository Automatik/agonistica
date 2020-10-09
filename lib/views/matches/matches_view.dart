library matches_view;

import 'package:agonistica/core/arguments/MatchesViewArguments.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/shared/base_scaffold_widget.dart';
import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/match_detail_layout.dart';
import 'package:agonistica/core/shared/match_review.dart';
import 'package:agonistica/core/shared/tab_scaffold_widget.dart';
import 'package:agonistica/core/utils.dart';
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

    final MatchesViewArguments args = ModalRoute.of(context).settings.arguments;

    return ViewModelBuilder<MatchesViewModel>.reactive(
      viewModelBuilder: () => MatchesViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _MatchesMobile(viewModel, args.isNewMatch, args.match),
          tablet: _MatchesMobile(viewModel, args.isNewMatch, args.match),
        );
      }
    );
  }
}
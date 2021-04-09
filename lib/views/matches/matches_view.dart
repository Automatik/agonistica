library matches_view;

import 'package:agonistica/core/arguments/MatchesViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/core/platform_appbars.dart';
import 'package:agonistica/views/matches/match_detail_layout.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'matches_view_model.dart';

part 'matches_mobile.dart';

// ignore: must_be_immutable
class MatchesView extends StatelessWidget {
  static const routeName = '/matches';

  @override
  Widget build(BuildContext context) {

    final MatchesViewArguments args = ModalRoute.of(context).settings.arguments;

    return ViewModelBuilder<MatchesViewModel>.reactive(
      viewModelBuilder: () => MatchesViewModel(args.isNewMatch, args.match, args.onMatchDetailUpdate),
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
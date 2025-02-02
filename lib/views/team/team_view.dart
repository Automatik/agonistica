library team_view;

import 'package:agonistica/core/arguments/team_view_arguments.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/widgets/app_bars/add_action_platform_app_bar.dart';
import 'package:agonistica/widgets/base/base_widget.dart';
import 'package:agonistica/widgets/reviews/match_review.dart';
import 'package:agonistica/widgets/reviews/player_review.dart';
import 'package:agonistica/widgets/popups/team_view_popup_menu.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'team_view_model.dart';

part 'team_mobile.dart';

class TeamView extends StatelessWidget {
  static const routeName = '/team';

  @override
  Widget build(BuildContext context) {

    final TeamViewArguments args = ModalRoute.of(context)!.settings.arguments as TeamViewArguments;

    return ViewModelBuilder<TeamViewModel>.reactive(
      viewModelBuilder: () => TeamViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _TeamMobile(viewModel, args.initialTabIndex),
          tablet: _TeamMobile(viewModel, args.initialTabIndex),
        );
      }
    );
  }
}
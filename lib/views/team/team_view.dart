library team_view;

import 'package:agonistica/core/arguments/TeamViewArguments.dart';
import 'package:agonistica/core/exceptions/argument_exception.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/widgets/app_bars/add_action_platform_app_bar.dart';
import 'package:agonistica/widgets/base/base_widget.dart';
import 'package:agonistica/views/teams/match_review.dart';
import 'package:agonistica/views/teams/player_review.dart';
import 'package:agonistica/widgets/popups/popup_menu_item_tile.dart';
import 'package:agonistica/widgets/popups/team_view_popup_menu.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'team_view_model.dart';

part 'team_mobile.dart';

class TeamView extends StatelessWidget {
  static const routeName = '/team';

  @override
  Widget build(BuildContext context) {

    final TeamViewArguments args = ModalRoute.of(context).settings.arguments;

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
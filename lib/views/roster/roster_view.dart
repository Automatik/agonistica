library roster_view;

import 'package:agonistica/core/arguments/roster_view_arguments.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/widgets/app_bars/edit_mode_roster_view_platform_app_bar.dart';
import 'package:agonistica/widgets/app_bars/view_mode_roster_view_platform_app_bar.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/views/roster/player_detail_layout.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'roster_view_model.dart';

part 'roster_mobile.dart';

class RosterView extends StatelessWidget {
  static const routeName = '/roster';

  @override
  Widget build(BuildContext context) {

    final RosterViewArguments args = ModalRoute.of(context)!.settings.arguments as RosterViewArguments;

    return ViewModelBuilder<RosterViewModel>.reactive(
      viewModelBuilder: () => RosterViewModel(args.isNewPlayer, args.seasonPlayer, args.onPlayerDetailUpdate),
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
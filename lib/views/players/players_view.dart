library players_view;

import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/views/players/players_view_model.dart';
import 'package:agonistica/views/teams/player_review.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:agonistica/widgets/popups/players_view_popup_menu.dart';
import 'package:agonistica/widgets/scaffolds/scroll_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

part 'players_mobile.dart';

class PlayersView extends StatelessWidget {

  static const routeName = '/players';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PlayersViewModel>.reactive(
      viewModelBuilder: () => PlayersViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _PlayersMobile(viewModel),
          tablet: _PlayersMobile(viewModel),
        );
      },
    );
  }

}
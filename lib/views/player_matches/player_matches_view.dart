library player_matches_view;

import 'package:agonistica/core/arguments/player_matches_view_arguments.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/widgets/app_bars/player_matches_view_actions_plaftorm_app_bar.dart';
import 'package:agonistica/widgets/app_bars/player_matches_view_platform_app_bar.dart';
import 'package:agonistica/widgets/popups/player_matches_view_popup_menu.dart';
import 'package:agonistica/widgets/reviews/match_review.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/views/player_matches/match_notes_object.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'player_matches_view_model.dart';

part 'player_matches_mobile.dart';

class PlayerMatchesView extends StatelessWidget {
  static const routeName = '/player_matches';

  @override
  Widget build(BuildContext context) {

    final PlayerMatchesViewArguments args = ModalRoute.of(context).settings.arguments;

    return ViewModelBuilder<PlayerMatchesViewModel>.reactive(
      viewModelBuilder: () => PlayerMatchesViewModel(args.playerId, args.playerName, args.playerSurname, args.addAction),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _PlayerMatchesMobile(viewModel),
          tablet: _PlayerMatchesMobile(viewModel),
        );
      }
    );
  }
}
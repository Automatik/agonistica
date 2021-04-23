library players_view;

import 'package:agonistica/views/players/players_view_model.dart';
import 'package:flutter/material.dart';
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
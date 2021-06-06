library home_view;

import 'package:agonistica/core/assets/image_assets.dart';
import 'package:agonistica/core/assets/menu_assets.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/core/utils/my_strings.dart';
import 'package:agonistica/widgets/app_bars/add_action_platform_app_bar.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:agonistica/widgets/cards/empty_menu_card.dart';
import 'package:agonistica/widgets/cards/image_menu_card.dart';
import 'package:agonistica/widgets/dialogs/insert_followed_players_menu_dialog.dart';
import 'package:agonistica/widgets/dialogs/insert_followed_team_menu_dialog.dart';
import 'package:agonistica/widgets/popups/home_view_popup_menu.dart';
import 'package:agonistica/widgets/scaffolds/scroll_scaffold_widget.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/text_styles/title_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _HomeMobile(viewModel),
          tablet: _HomeMobile(viewModel),
        );
      }
    );
  }
}
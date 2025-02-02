library categories_view;

import 'package:agonistica/core/arguments/categories_view_arguments.dart';
import 'package:agonistica/core/utils/my_strings.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:agonistica/widgets/app_bars/add_action_platform_app_bar.dart';
import 'package:agonistica/widgets/cards/empty_menu_card.dart';
import 'package:agonistica/widgets/cards/image_menu_card.dart';
import 'package:agonistica/widgets/cards/season_card.dart';
import 'package:agonistica/widgets/dialogs/confirm_dialog.dart';
import 'package:agonistica/widgets/dialogs/insert_category_dialog.dart';
import 'package:agonistica/widgets/lists/rotated_list_wheel.dart';
import 'package:agonistica/widgets/popups/category_view_popup_menu.dart';
import 'package:agonistica/widgets/scaffolds/scroll_scaffold_widget.dart';
import 'package:agonistica/widgets/text_styles/title_text_style.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'categories_view_model.dart';

part 'categories_mobile.dart';

class CategoriesView extends StatelessWidget {
  static const routeName = '/categories';

  @override
  Widget build(BuildContext context) {

    final CategoriesViewArguments args = ModalRoute.of(context)!.settings.arguments as CategoriesViewArguments;

    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () => CategoriesViewModel(args.categoriesIds),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized

      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _CategoriesMobile(viewModel),
          tablet: _CategoriesMobile(viewModel),
        );
      }
    );
  }
}
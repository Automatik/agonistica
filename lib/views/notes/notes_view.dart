library notes_view;

import 'package:agonistica/core/arguments/notes_view_arguments.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/app_bars/edit_mode_notes_view_platform_app_bar.dart';
import 'package:agonistica/widgets/app_bars/view_mode_notes_view_platform_app_bar.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/widgets/text/text_box.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'notes_view_model.dart';

part 'notes_mobile.dart';

class NotesView extends StatelessWidget {
  static const routeName = '/notes';

  @override
  Widget build(BuildContext context) {

    final NotesViewArguments args = ModalRoute.of(context).settings.arguments;

    return ViewModelBuilder<NotesViewModel>.reactive(
      viewModelBuilder: () => NotesViewModel(args.notes, args.match, args.playerName, args.playerSurname),
      onModelReady: (viewModel) {
        // Do something once your viewModel is initialized
      },
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _NotesMobile(viewModel),
          tablet: _NotesMobile(viewModel),
        );
      }
    );
  }
}
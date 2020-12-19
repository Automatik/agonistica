library notes_view;

import 'package:agonistica/core/arguments/NotesViewArguments.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/shared/tab_scaffold_widget.dart';
import 'package:agonistica/core/utils.dart';
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
      viewModelBuilder: () => NotesViewModel(args.notes, args.match, args.playerName),
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
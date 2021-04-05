import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TabLeavingDialog extends ConfirmDialog {

  static const String DIALOG_TITLE = "Attenzione";
  static const String DIALOG_MESSAGE = "Vuoi davvero perdere le modifiche?";
  static const String DIALOG_CONFIRM = "Confermo";
  static const String DIALOG_CANCEL = "Annulla";

  TabLeavingDialog({Function onConfirm, Function onCancel}) :
        super(onConfirm: onConfirm, onCancel: onCancel);

  Future<void> showTabLeavingDialog(BuildContext context) async {
    super.showDialog(context, DIALOG_TITLE, DIALOG_MESSAGE, DIALOG_CONFIRM, DIALOG_CANCEL);
  }

}
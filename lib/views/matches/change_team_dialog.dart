import 'package:agonistica/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';

class ChangeTeamDialog extends ConfirmDialog{

  static const String DIALOG_TITLE = "Attenzione";
  static const String DIALOG_MESSAGE = "Vuoi davvero cambiare squadra e tutti i relativi giocatori inseriti?";
  static const String DIALOG_CONFIRM = "Confermo";
  static const String DIALOG_CANCEL = "Annulla";

  ChangeTeamDialog({Function onConfirm, Function onCancel}) :
    super(onConfirm: onConfirm, onCancel: onCancel);

  Future<void> showChangeTeamDialog(BuildContext context) async {
    super.showDialog(context, DIALOG_TITLE, DIALOG_MESSAGE, DIALOG_CONFIRM, DIALOG_CANCEL);
  }

}
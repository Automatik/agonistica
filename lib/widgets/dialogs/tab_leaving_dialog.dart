import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TabLeavingDialog {

  static const String DIALOG_TITLE = "Attenzione";
  static const String DIALOG_MESSAGE = "Vuoi davvero perdere le modifiche?";
  static const String DIALOG_CONFIRM = "Confermo";
  static const String DIALOG_CANCEL = "Annulla";

  final Function onConfirm, onCancel;

  TabLeavingDialog({
    this.onConfirm,
    this.onCancel
  });

  Future<void> showTabLeavingDialog(BuildContext context) async {
    await showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: PlatformText(
          DIALOG_TITLE,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blueAgonisticaColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        material: (_, __) => MaterialAlertDialogData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )
        ),
        content: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            DIALOG_MESSAGE,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          actionButton(DIALOG_CONFIRM, onConfirm),
          actionButton(DIALOG_CANCEL, onCancel),
        ],
      )
    );
  }

  Widget actionButton(String text, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: PlatformText(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blueAgonisticaColor,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

}
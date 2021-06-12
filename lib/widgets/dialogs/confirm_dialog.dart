import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ConfirmDialog {

  final Function()? onConfirm, onCancel;

  ConfirmDialog({
    this.onConfirm,
    this.onCancel,
  });

  Future<void> showDialog(BuildContext context, String dialogTitle, String dialogMessage, String dialogConfirm, String dialogCancel) async {
    await showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
          title: PlatformText(
            dialogTitle,
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
              dialogMessage,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            actionButton(dialogConfirm, onConfirm),
            actionButton(dialogCancel, onCancel),
          ],
        )
    );
  }

  Widget actionButton(String text, Function()? onTap) {
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
// @dart=2.9

import 'package:agonistica/widgets/dialogs/base_insert_dialog.dart';

class InsertCategoryDialog extends BaseInsertDialog {

  InsertCategoryDialog({
    validateInput,
    onSubmit,
  }) : super(validateInput: validateInput, onSubmit: onSubmit);

  @override
  String getTitle() {
    return "Inserisci il nome di una nuova categoria";
  }

}
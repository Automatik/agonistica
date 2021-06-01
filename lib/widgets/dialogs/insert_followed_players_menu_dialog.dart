import 'package:agonistica/widgets/dialogs/base_insert_dialog.dart';

class InsertFollowedPlayersMenuDialog extends BaseInsertDialog {

  InsertFollowedPlayersMenuDialog({
    validateInput,
    onSubmit,
  }) : super(validateInput: validateInput, onSubmit: onSubmit);

  @override
  String getTitle() {
    return "Inserisci il nome di una macro-categoria di cui fanno parte giocatori seguiti";
  }

}
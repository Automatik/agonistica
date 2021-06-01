import 'package:agonistica/widgets/dialogs/base_insert_dialog.dart';

class InsertFollowedTeamMenuDialog extends BaseInsertDialog {

  InsertFollowedTeamMenuDialog({
    validateInput,
    onSubmit,
  }) : super(validateInput: validateInput, onSubmit: onSubmit);

  @override
  String getTitle() {
    return "Inserisci il nome di una nuova squadra seguita";
  }

}
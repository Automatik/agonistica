part of notes_view;

class _NotesMobile extends StatefulWidget {

  final NotesViewModel viewModel;

  _NotesMobile(this.viewModel);

  @override
  State<StatefulWidget> createState() => _NotesMobileState();

}

class _NotesMobileState extends State<_NotesMobile> {

  final double iconsSize = 24;
  final double topMargin = 10;
  final double bottomMargin = 10;

  Match tempMatch;
  PlayerMatchNotes tempNotes;
  bool isEditEnabled;

  TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    tempMatch = Match.clone(widget.viewModel.match);
    tempNotes = PlayerMatchNotes.clone(widget.viewModel.notes);
    print("player id: ${tempNotes.seasonPlayerId}");
    isEditEnabled = false;
    notesController = TextEditingController();
    initializeState();
  }

  void initializeState() {
    notesController.text = tempNotes.notes == null ? "" : "${tempNotes.notes}";
  }

  Future<void> onSave() async {
    tempNotes.notes = notesController.text;
    await widget.viewModel.onNotesSave(tempNotes.notes);
  }

  @override
  Widget build(BuildContext context) {

    return TabScaffoldWidget(
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) => widget.viewModel.onBottomBarItemChanged(context, index),
      childBuilder: (childContext, sizingInformation, parentSizingInformation) {
        double itemsWidth = 1 * sizingInformation.screenSize.width;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.white,
            constraints: BoxConstraints(
              minWidth: sizingInformation.screenSize.width,
              maxWidth: sizingInformation.screenSize.width,
              minHeight: sizingInformation.localWidgetSize.height,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MatchInfoWidget(
                    match: tempMatch,
                    isEditEnabled: false,
                    width: itemsWidth,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    child: Text(
                      "Note Partita",
                      textAlign: TextAlign.center,
                      style: DetailViewHeaderTextStyle(color: blueAgonisticaColor),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: TextBox(
                      isEnabled: isEditEnabled,
                      controller: notesController
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    String title = widget.viewModel.getAppBarTitle();
    if(isEditEnabled) {
      return EditModeNotesViewPlatformAppBar(title: title, onActionBack: () => onActionBack(context), onActionCancel: onActionCancel, onActionConfirm: onActionConfirm);
    } else {
      return ViewModeNotesViewPlatformAppBar(title: title, onActionBack: () => onActionBack(context), onActionEditPress: onActionEditPress);
    }
  }

  void onActionBack(BuildContext context) {
    if(isEditEnabled) {
      setState(() {
        isEditEnabled = false;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void onActionCancel() {
    if(isEditEnabled) {
      setState(() {
        isEditEnabled = false;
        initializeState();
      });
    }
  }

  void onActionConfirm() async {
    if(isEditEnabled) {
      onSave();
      setState(() {
        isEditEnabled = false;
      });
    }
  }

  void onActionEditPress() {
    setState(() {
      isEditEnabled = true;
      initializeState();
    });
  }

}
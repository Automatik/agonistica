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
      showAppBar: true,
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) => widget.viewModel.onBottomBarItemChanged(context, index),
      childBuilder: (childContext, sizingInformation, parentSizingInformation) {
        double itemsWidth = 0.9 * sizingInformation.screenSize.width;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            constraints: BoxConstraints(
              minWidth: sizingInformation.screenSize.width,
              maxWidth: sizingInformation.screenSize.width,
              minHeight: sizingInformation.localWidgetSize.height,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.only(top: 20, bottom: 20),
                width: itemsWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 5, top: topMargin),
                          width: iconsSize,
                          height: iconsSize,
                          child: SvgPicture.asset(
                            'assets/images/010-football.svg',
                            excludeFromSemantics: true,
                            color: blueAgonisticaColor,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: topMargin, right: 20),
                            alignment: Alignment.center,
                            child: Text(
                              "${tempMatch.team1Name} ${tempMatch.team1Goals} - ${tempMatch.team2Goals} ${tempMatch.team2Name}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 12, top: topMargin, bottom: bottomMargin),
                            child: Text(
                              "Giornata ${tempMatch.leagueMatch}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 15, top: topMargin, bottom: bottomMargin),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.calendar_today, color: blueAgonisticaColor, size: iconsSize,),
                                SizedBox(width: 5,),
                                Text(
                                  "${tempMatch.matchDate.day} " + DateUtils.monthToString(tempMatch.matchDate.month).substring(0, 3) + " ${tempMatch.matchDate.year}",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 5),
                      color: blueAgonisticaColor,
                      height: 1.5,
                    ),
                    TextBox(
                      isEnabled: isEditEnabled,
                      controller: notesController
                    ),
                  ],
                ),
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
      return PlatformAppBars.getPlatformAppBarForNotesViewInEditMode(title, () => onActionBack(context), onActionCancel, onActionConfirm);
    } else {
      return PlatformAppBars.getPlatformAppBarForNotesViewInViewMode(title, () => onActionBack(context), onActionEditPress);
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
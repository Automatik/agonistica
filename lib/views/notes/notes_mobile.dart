part of notes_view;

class _NotesMobile extends StatefulWidget {

  final NotesViewModel viewModel;

  _NotesMobile(this.viewModel);

  @override
  State<StatefulWidget> createState() => _NotesMobileState();

}

class _NotesMobileState extends State<_NotesMobile> {

  final double iconsSize = 20;
  final double topMargin = 10;
  final double bottomMargin = 10;

  bool isEditEnabled;

  TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    isEditEnabled = false;
    notesController = TextEditingController();
  }

  void initializeState() {
    notesController.text = widget.viewModel.notes.notes;
  }

  @override
  Widget build(BuildContext context) {

    final Match match = widget.viewModel.match;

    return TabScaffoldWidget(
      showAppBar: true,
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) => widget.viewModel.onBottomBarItemChanged(context, index),
      childBuilder: (childContext, sizingInformation, parentSizingInformation) {
        double itemsWidth = 0.7 * sizingInformation.screenSize.width;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
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
                        margin: EdgeInsets.only(top: topMargin),
                        alignment: Alignment.center,
                        child: Text(
                          "${match.team1Name} ${match.team1Goals} - ${match.team2Goals} ${match.team2Name}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 5, right: 12, top: topMargin),
                        child: Icon(Icons.more_vert, color: blueAgonisticaColor, size: iconsSize,)
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 12, top: topMargin, bottom: bottomMargin),
                        child: Text(
                          "Giornata ${match.leagueMatch}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
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
                              "${match.matchDate.day} " + Utils.monthToString(match.matchDate.month).substring(0, 3) + " ${match.matchDate.year}",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  constraints: BoxConstraints(
                    minHeight: 100,
                  ),
                  child: TextField(
                    enabled: isEditEnabled,
                    autofocus: true,
                    controller: notesController,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                        borderSide: BorderSide(
                          width: 1,
                          color: blueAgonisticaColor,
                          style: BorderStyle.solid
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    String title = widget.viewModel.getAppBarTitle();
    if(isEditEnabled) {
      return Utils.getPlatformAppBarForNotesViewInEditMode(title, () => onActionBack(context), onActionCancel, onActionConfirm);
    } else {
      return Utils.getPlatformAppBarForNotesViewInViewMode(title, () => onActionBack(context), onActionEditPress);
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
      await widget.viewModel.onNotesSave(notesController.text);
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
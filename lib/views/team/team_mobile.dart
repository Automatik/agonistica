part of team_view;

class _TeamMobile extends StatefulWidget {

  final TeamViewModel viewModel;

  final int initialTabIndex;

  _TeamMobile(this.viewModel, this.initialTabIndex);

  @override
  State<StatefulWidget> createState() => _TeamMobileState();

}

class _TeamMobileState extends State<_TeamMobile> {

  static const int VIEW_MATCH_CARD = 0;
  static const int VIEW_PLAYER_CARD = 1;
  static const int DELETE_ITEM = 2;

  int _tabIndex;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTabIndex ?? TabScaffoldWidget.MATCHES_VIEW_INDEX;
  }

  void onUpdateList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      initialIndex: _tabIndex,
      platformAppBar: PlatformAppBars.getPlatformAppBarWithAddAction(widget.viewModel.getWidgetTitle(), () {
        // on add action pressed
        if(_tabIndex == TabScaffoldWidget.MATCHES_VIEW_INDEX)
          widget.viewModel.addNewMatch(context);
        else
          widget.viewModel.addNewPlayer(context);
      }),
      onBottomItemChanged: (index) {
        setState(() {
          _tabIndex = index;
        });
      },
      childBuilder: (BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {
        if(_tabIndex == TabScaffoldWidget.MATCHES_VIEW_INDEX) {
          return _getMatchesLayout();
        }
        else {
          return _getRosterLayout();
        }
      },
    );
  }

  Widget _getMatchesLayout() {
    return BaseWidget(
      builder: (BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {

        double itemsWidth = 0.7 * sizingInformation.screenSize.width;

        return Container(
          constraints: BoxConstraints(
            maxHeight: sizingInformation.screenSize.height,
            maxWidth: sizingInformation.screenSize.width,
          ),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.viewModel.matches.length,
              itemBuilder: (BuildContext listContext, int index) {
                Match match = widget.viewModel.matches[index];
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: itemsWidth,
                    child: MatchReview(
                      onTap: () => widget.viewModel.openMatchDetail(context, index, onUpdateList),
                      onSettingsTap: (offset) => onMatchLongPress(context, offset, index),
                      width: itemsWidth,
                      team1: match.team1Name,
                      team2: match.team2Name,
                      result: "${match.team1Goals} - ${match.team2Goals}",
                      leagueMatch: match.leagueMatch,
                      matchDate: match.matchDate,
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }

  Widget _getRosterLayout() {
    return BaseWidget(
      builder: (BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {

        double itemsWidth = 0.7 * sizingInformation.screenSize.width;

        return Container(
          constraints: BoxConstraints(
            maxHeight: sizingInformation.screenSize.height,
            maxWidth: sizingInformation.screenSize.width,
          ),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.viewModel.players.length,
              itemBuilder: (BuildContext listContext, int index) {
                Player player = widget.viewModel.players[index];
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: itemsWidth,
                    child: PlayerReview(
                      onTap: () => widget.viewModel.openPlayerDetail(context, index, onUpdateList),
                      onSettingsTap: (offset) => onRosterLongPress(context, offset, index),
                      name: "${player.name} ${player.surname}",
                      role: Player.positionToString(player.position),
                      width: itemsWidth,
                      birthDay: player.birthDay,
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }

  Future<void> onMatchLongPress(BuildContext context, Offset offset, int index) async {
    await onItemLongPress(context, offset, index, VIEW_MATCH_CARD);
  }

  Future<void> onRosterLongPress(BuildContext context, Offset offset, int index) async {
    await onItemLongPress(context, offset, index, VIEW_PLAYER_CARD);
  }

  Future<void> onItemLongPress(BuildContext context, Offset offset, int index, int viewItemValue) async {
    double left = offset.dx;
    double top = offset.dy;
    _ItemTileObject viewTileObject = selectItemTileObject(viewItemValue);
    _ItemTileObject deleteTileObject = selectItemTileObject(DELETE_ITEM);
    int value = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(left, top, left+1, top+1),
        items: [
          PopupMenuItem(
              value: viewItemValue,
              child: PopupMenuItemTile(
                text: viewTileObject.text,
                iconData: viewTileObject.icon,
              )
          ),
          PopupMenuItem(
              value: DELETE_ITEM,
              child: PopupMenuItemTile(
                text: deleteTileObject.text,
                iconData: deleteTileObject.icon,
              )
          ),
        ]
    );
    selectLongClickAction(context, value, index);
  }

  void selectLongClickAction(BuildContext context, int choice, int index) {
    switch(choice) {
      case VIEW_MATCH_CARD: widget.viewModel.openMatchDetail(context, index, onUpdateList); break;
      case VIEW_PLAYER_CARD: widget.viewModel.openPlayerDetail(context, index, onUpdateList); break;
      case DELETE_ITEM: break; //TODO
      default: return;
    }
  }

  _ItemTileObject selectItemTileObject(int value) {
    switch(value) {
      case VIEW_MATCH_CARD: return _ItemTileObject("Scheda Partita", PlatformIcons(context).forward);
      case VIEW_PLAYER_CARD: return _ItemTileObject("Scheda Giocatore", PlatformIcons(context).person);
      case DELETE_ITEM: return _ItemTileObject("Elimina", PlatformIcons(context).delete);
      default: throw ArgumentException("Value not found");
    }
  }

}

class _ItemTileObject {

  final String text;
  final IconData icon;

  _ItemTileObject(this.text, this.icon);

}
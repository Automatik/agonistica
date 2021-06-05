part of player_matches_view;

class _PlayerMatchesMobile extends StatelessWidget {
  final PlayerMatchesViewModel viewModel;

  _PlayerMatchesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) => viewModel.onBottomBarItemChanged(context, index),
      childBuilder: (childContext, sizingInformation, parentSizingInformation) {
        double itemsWidth = 0.95 * sizingInformation.screenSize.width;

        return Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          constraints: BoxConstraints(
            maxHeight: sizingInformation.screenSize.height,
            maxWidth: sizingInformation.screenSize.width,
          ),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: viewModel.objects.length,
            itemBuilder: (itemContext, index) {
              MatchNotesObject object = viewModel.objects[index];
              return Align(
                alignment: Alignment.center,
                child: Container(
                  width: itemsWidth,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: _getMatchReview(context, index, itemsWidth),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _getMatchReview(BuildContext context, int index, double itemsWidth) {
    MatchNotesObject object = viewModel.objects[index];
    Match match = object.match;
    return MatchReview(
      onTap: () => viewModel.onPlayerMatchNotesClick(context, object),
      onSettingsTap: (tapDownDetails) => onPlayerMatchNotesSettingsClick(context, object, tapDownDetails),
      width: itemsWidth,
      team1: match.getHomeTeam(),
      team2: match.getAwayTeam(),
      result: "${match.team1Goals} - ${match.team2Goals}",
      leagueMatch: match.leagueMatch,
      matchDate: match.matchDate,
    );
  }

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    String title = viewModel.getAppBarTitle();
    if(viewModel.showAddAction()) {
      return PlayerMatchesViewActionsPlatformAppBar(
        title: title,
        onActionBack: () => onActionBack(context),
        onActionTap: () => onActionAdd(context),
      );
    }
    return PlayerMatchesViewPlatformAppBar(
        title: title,
        onActionBack: () => onActionBack(context)
    );
  }

  void onActionBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onActionAdd(BuildContext context) {
    viewModel.addNewMatch(context);
  }

  Future<void> onPlayerMatchNotesSettingsClick(BuildContext context, MatchNotesObject object, Offset offset) async {
    final popupMenu = PlayerMatchesViewPopupMenu(
      offset: offset,
      itemValues: viewModel.getPopupMenuItemValues()
    );
    int value = await popupMenu.showPopupMenu(context);
    await viewModel.onPopupMenuItemSelected(context, value, object);
  }

}
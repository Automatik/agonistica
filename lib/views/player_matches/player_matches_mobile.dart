part of player_matches_view;

class _PlayerMatchesMobile extends StatelessWidget {
  final PlayerMatchesViewModel viewModel;

  _PlayerMatchesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) => viewModel.onBottomBarItemChanged(context, index),
      childBuilder: (childContext, sizingInformation, parentSizingInformation) {
        double itemsWidth = 0.7 * sizingInformation.screenSize.width;

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
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: MatchNotesElement(
                    object: object,
                    onTap: () => viewModel.onPlayerMatchNotesClick(context, object),
                    width: itemsWidth,
                    minHeight: 50,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    String title = viewModel.getAppBarTitle();
    return PlatformAppBars.getPlatformAppBarForPlayerMatchesView(title, () => onActionBack(context));
  }

  void onActionBack(BuildContext context) {
    Navigator.of(context).pop();
  }

}
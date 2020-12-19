part of player_matches_view;

// ignore: must_be_immutable
class _PlayerMatchesMobile extends StatelessWidget {
  final PlayerMatchesViewModel viewModel;

  _PlayerMatchesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      initialIndex: TabScaffoldWidget.ROSTER_VIEW_INDEX,
      title: viewModel.getAppBarTitle(),
      onBottomItemChanged: (index) => viewModel.onBottomBarItemChanged(context, index),
      childBuilder: (childContext, sizingInformation) {
        double itemsWidth = 0.7 * sizingInformation.screenSize.width;

        return Container(
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
}
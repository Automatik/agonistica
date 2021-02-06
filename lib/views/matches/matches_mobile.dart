part of matches_view;

class _MatchesMobile extends StatefulWidget {
  
  final MatchesViewModel viewModel;

  _MatchesMobile(this.viewModel);
  
  @override
  State<StatefulWidget> createState() => _MatchesMobileState();

}

class _MatchesMobileState extends State<_MatchesMobile> {

  bool isEditEnabled;

  Match tempMatch;

  final MatchDetailController matchDetailController = MatchDetailController();

  void initializeState() {
    tempMatch = Match.clone(widget.viewModel.match);
  }

  @override
  void initState() {
    super.initState();
    isEditEnabled = widget.viewModel.isNewMatch;
    initializeState();
  }

  @override
  Widget build(BuildContext context) {
    print("building MatchesMobile view");
    return TabScaffoldWidget(
      showAppBar: true,
      initialIndex: TabScaffoldWidget.MATCHES_VIEW_INDEX,
      platformAppBar: getPlatformAppBar(context),
      onBottomItemChanged: (index) {
        widget.viewModel.onBottomBarItemChanged(context, index);
      },
      childBuilder: (BuildContext childContext, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) {
        double width = 0.9 * sizingInformation.localWidgetSize.width;
        return _matchDetail(childContext, isEditEnabled, tempMatch, width, matchDetailController);
      },
    );
  }

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    String title = widget.viewModel.getAppBarTitle();
    print("isEditEnabled: $isEditEnabled");
    if(isEditEnabled) {
      return PlatformAppBars.getPlatformAppBarForMatchesViewInEditMode(title, () => onActionBack(context), onActionCancel, () => onActionConfirm(context));
    } else {
      return PlatformAppBars.getPlatformAppBarForMatchesViewInViewMode(title, () => onActionBack(context), onActionEditPress, () => onActionConfirm(context));
    }
  }
  
  Widget _matchDetail(BuildContext context, bool isEditEnabled, Match match, double maxWidth, MatchDetailController matchDetailController) {
    return MatchDetailLayout(
      isEditEnabled: isEditEnabled,
      match: match,
      controller: matchDetailController,
      onSuggestionTeamCallback: (pattern) => widget.viewModel.suggestTeamsByPattern(pattern),
      maxWidth: maxWidth,
    );
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

  Future<void> onActionConfirm(BuildContext context) async {
    print("onActionConfirm");
    if(isEditEnabled) {
      print("saveMatchStatus");
      matchDetailController.saveMatchStatus();
      print("onMatchSave");
      await widget.viewModel.onMatchSave(context, tempMatch);
      print("setting isEditENabled to false");
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

  void onActionAddPress(BuildContext context) {
    //todo navigate to match notes
  }
  
}
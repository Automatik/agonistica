part of matches_view;

class _MatchesMobile extends StatefulWidget {
  
  final MatchesViewModel viewModel;
  final bool isNewMatch;
  final Match match;

  _MatchesMobile(this.viewModel, this.isNewMatch, this.match);
  
  @override
  State<StatefulWidget> createState() => _MatchesMobileState();

}

class _MatchesMobileState extends State<_MatchesMobile> {

  @override
  Widget build(BuildContext context) {
    return TabScaffoldWidget(
      showAppBar: true,
      title: widget.isNewMatch ? "Nuova Partita" : widget.viewModel.getAppBarTitle(),
      onBottomItemChanged: (index) {
        // TODO routes
      },
      childBuilder: (BuildContext childContext, MySizingInformation sizingInformation) {
        double width = 0.9 * sizingInformation.localWidgetSize.width;
        return _matchDetail(childContext, widget.isNewMatch, widget.match, width);
      },
    );
  }
  
  Widget _matchDetail(BuildContext context, bool isNewMatch, Match match, double maxWidth) {
    return MatchDetailLayout(
      isNewMatch: isNewMatch,
      match: match,
      onSuggestionTeamCallback: (pattern) => widget.viewModel.suggestTeamsByPattern(pattern),
      onSave: (matchData) => widget.viewModel.onMatchSave(context, matchData),
      maxWidth: maxWidth,
    );
  }
  
}
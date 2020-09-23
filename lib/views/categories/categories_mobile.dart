part of categories_view;

// ignore: must_be_immutable
class _CategoriesMobile extends StatelessWidget {
  final CategoriesViewModel viewModel;

  _CategoriesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      showAppBar: true,
      title: viewModel.getAppBarTitle(),
      childBuilder: (context, sizingInformation) {

        double titleFontSize = sizingInformation.isPortrait() ? 24 : 20;

        double widthFactor = sizingInformation.isPortrait() ? 0.65 : 0.35;
        double width = widthFactor * sizingInformation.screenSize.width;

        double marginTop = sizingInformation.isPortrait() ? 50 : 0;

        return Container(
            constraints: BoxConstraints(
            maxHeight: sizingInformation.screenSize.height,
            maxWidth: sizingInformation.screenSize.width,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Categorie seguite',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: titleFontSize,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: marginTop),
                width: width,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: viewModel.getFollowedCategoriesCount(),
                  itemBuilder: (BuildContext listContext, int index) {
                    return GestureDetector(
                      onTap: () => viewModel.onFollowedCategoryTap(context, index),
                      child: Container(
                        margin: EdgeInsets.only(top: 30),
//                          height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minHeight: 35,
                        ),
                        child: Text(
                          viewModel.getFollowedCategory(index),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
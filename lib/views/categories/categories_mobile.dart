part of categories_view;

class _CategoriesMobile extends StatelessWidget {

  static const String EMPTY_TITLE_CATEGORY = "Aggiungi categoria";

  static const double IMAGE_MENU_CARD_HEIGHT = 150;

  final CategoriesViewModel viewModel;

  _CategoriesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ScrollScaffoldWidget(
      showAppBar: true,
      platformAppBar: getPlatformAppBar(context),
      childBuilder: (context, sizingInformation, parentSizingInformation) {

        double widthFactor = sizingInformation.isPortrait() ? 0.95 : 0.95;
        double width = widthFactor * sizingInformation.screenSize.width;

        return Container(
            constraints: BoxConstraints(
            minHeight: parentSizingInformation.localWidgetSize.height,
            minWidth: sizingInformation.screenSize.width,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              titleWidget(context),
              seasonsListWidget(context, width),
              categoriesListWidget(context, width),
            ],
          ),
        );
      },
    );
  }

  Widget titleWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Text(
          MyStrings.CATEGORY_VIEW_TITLE,
          textAlign: TextAlign.center,
          style: TitleTextStyle(context: context).compose()
      ),
    );
  }

  Widget seasonsListWidget(BuildContext context, double listWidth) {
    List<Widget> seasonsList = seasonsListChildren();
    // check if empty because ListWheelScrollView currently has bug of not
    // re-rendering when child count changes
    // https://github.com/flutter/flutter/issues/58144
    if(seasonsList.isEmpty) {
      return SizedBox();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: listWidth,
      height: 100,
      alignment: Alignment.center,
      child: RotatedListWheel(
        children: seasonsList,
        itemExtent: 250,
        onSelectedItemChanged: (index) => viewModel.onSeasonItemChanged(index),
      )
    );
  }

  List<Widget> seasonsListChildren() {
    // List<String> seasonPeriods = ["2017/18","2018/19", "2019/20", "2020/21"];
    List<String> seasonPeriods = viewModel.getSeasonPeriods();
    List<Widget> children = [];
    seasonPeriods.forEach((element) {
      Widget widget = SeasonCard(title: element, height: 100);
      children.add(widget);
    });
    return children;
  }

  Widget categoriesListWidget(BuildContext context, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: width,
      child: categoriesListContent(context, width)
    );
  }

  Widget categoriesListContent(BuildContext context, double width) {
    if(viewModel.getCategoriesCount() == 0) {
      return emptyMenu(width, () => onActionAdd(context));
    }
    return categoriesListBuilder(context, width);
  }

  Widget categoriesListBuilder(BuildContext context, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: viewModel.getCategoriesCount(),
      itemBuilder: (BuildContext listContext, int index) => categoryBuilder(context, index, width),
    );
  }

  Widget emptyMenu(double imageWidth, Function() onEmptyTap) {
    return EmptyMenuCard(
      title: EMPTY_TITLE_CATEGORY,
      width: imageWidth,
      height: IMAGE_MENU_CARD_HEIGHT,
      onTap: onEmptyTap,
    );
  }

  Widget categoryBuilder(BuildContext context, int index, double width) {
    return ImageMenuCard(
      onTap: () => viewModel.onCategoryTap(context, index),
      onLongTap: (longPressDetails) => onItemLongPress(context, longPressDetails.globalPosition, index),
      imageAsset: viewModel.getCategoryImage(index),
      title: viewModel.getCategory(index),
      width: width,
      height: IMAGE_MENU_CARD_HEIGHT,
      useWhiteBackground: true,
      useVerticalMargin: true,
    );
  }

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    return AddActionPlatformAppBar(
      title: viewModel.getAppBarTitle(),
      onActionTap: () => onActionAdd(context),
    );
  }

  Future<void> onActionAdd(BuildContext context) async {
    final dialog = InsertCategoryDialog(
      validateInput: (String categoryName) {
        return viewModel.validateNewCategory(categoryName);
        },
      onSubmit: (String categoryName)  {
        viewModel.createNewCategory(categoryName);
        // close dialog
        Navigator.of(context).pop();
      }
    );
    await dialog.showInsertDialog(context);
  }

  Future<void> onItemLongPress(BuildContext context, Offset offset, int index) async {
    final popupMenu = CategoryViewPopupMenu(offset: offset);
    int? value = await popupMenu.showPopupMenu(context);
    selectLongClickAction(context, value, index);
  }

  void selectLongClickAction(BuildContext context, int? value, int index) {
    switch(value) {
      case CategoryViewPopupMenu.DELETE_CATEGORY: askConfirmDialog(context, index); break;
      default: return;
    }
  }

  void askConfirmDialog(BuildContext context, int index) {
    final dialog = ConfirmDialog(
      onConfirm: () {
        viewModel.onCategoryLongTap(index);
        NavUtils.closeView(context);
        },
      onCancel: () => NavUtils.closeView(context),
    );
    dialog.showDialog(context,
        MyStrings.CATEGORY_VIEW_DIALOG_TITLE,
        MyStrings.CATEGORY_VIEW_DIALOG_MESSAGE,
        MyStrings.CATEGORY_VIEW_DIALOG_CONFIRM,
        MyStrings.CATEGORY_VIEW_DIALOG_CANCEL
    );
  }

}
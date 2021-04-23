part of categories_view;

class _CategoriesMobile extends StatelessWidget {

  static const String DIALOG_TITLE = "Elimina Categoria";
  static const String DIALOG_MESSAGE = "Sei sicuro di volere eliminare la categoria e tutti i giocatori e le partite che appartengono a questa?";
  static const String DIALOG_CONFIRM = "Conferma";
  static const String DIALOG_CANCEL = "Annulla";

  final CategoriesViewModel viewModel;

  _CategoriesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ScrollScaffoldWidget(
      showAppBar: true,
      platformAppBar: getPlatformAppBar(context),
      childBuilder: (context, sizingInformation, parentSizingInformation) {

        double titleFontSize = sizingInformation.isPortrait() ? 24 : 20;

        double widthFactor = sizingInformation.isPortrait() ? 0.65 : 0.35;
        double width = widthFactor * sizingInformation.screenSize.width;

        double marginTop = sizingInformation.isPortrait() ? 50 : 0;

        return Container(
            constraints: BoxConstraints(
            minHeight: parentSizingInformation.localWidgetSize.height,
            minWidth: sizingInformation.screenSize.width,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: marginTop),
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
                      onLongPressStart: (longPressDetails) => onItemLongPress(context, longPressDetails.globalPosition, index),
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

  PlatformAppBar getPlatformAppBar(BuildContext context) {
    return AddActionPlatformAppBar(
      title: viewModel.getAppBarTitle(),
      onActionTap: () => onActionAdd(context),
    );
  }

  void onActionAdd(BuildContext context) {
    final dialog = InsertCategoryDialog(
      validateCategoryName: (categoryName) async {
        return await viewModel.validateNewCategory(categoryName);
        },
      onSubmit: (categoryName)  {
        viewModel.createNewCategory(categoryName);
        // close dialog
        Navigator.of(context).pop();
      }
    );
    dialog.showInsertCategoryDialog(context);
  }

  Future<void> onItemLongPress(BuildContext context, Offset offset, int index) async {
    final popupMenu = CategoryViewPopupMenu(offset: offset);
    int value = await popupMenu.showPopupMenu(context);
    selectLongClickAction(context, value, index);
  }

  void selectLongClickAction(BuildContext context, int value, int index) {
    switch(value) {
      case CategoryViewPopupMenu.DELETE_CATEGORY: askConfirmDialog(context, index); break;
      default: return;
    }
  }

  void askConfirmDialog(BuildContext context, int index) {
    final dialog = ConfirmDialog(
      onConfirm: () {
        viewModel.onFollowedCategoryLongTap(index);
        NavUtils.closeView(context);
        },
      onCancel: () => NavUtils.closeView(context),
    );
    dialog.showDialog(context, DIALOG_TITLE, DIALOG_MESSAGE, DIALOG_CONFIRM, DIALOG_CANCEL);
  }

}
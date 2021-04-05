import 'package:agonistica/core/models/Category.dart';
import 'package:agonistica/widgets/text/custom_rich_text.dart';
import 'package:agonistica/widgets/dialogs/select_category_dialog.dart';
import 'package:flutter/material.dart';

class CategoryLabel extends StatefulWidget {

  final String categoryName;
  final bool isEditEnabled;
  final Future<List<Category>> Function() teamCategoriesCallback;
  final Function(Category) onCategoryChange;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;

  CategoryLabel({
    this.categoryName,
    this.isEditEnabled,
    this.teamCategoriesCallback,
    this.onCategoryChange,
    this.fontColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  State<StatefulWidget> createState() => _CategoryLabelState();

}

class _CategoryLabelState extends State<CategoryLabel> {

  String categoryText;

  @override
  void initState() {
    super.initState();
    categoryText = widget.categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return CustomRichText(
      onTap: () async {
        // se cambia categoria serve solo aggiornare il player (NON E' VERO: ma può servire aggiungere una nuova categoria alla squadra nel caso
        // il player ora faccia parte di una categoria di cui ancora il team non era presente)
        if(widget.isEditEnabled) {
          List<Category> categories = await widget.teamCategoriesCallback();
          final dialog = SelectCategoryDialog(
              categories: categories,
              onSelect: (newCategory) {
                if(newCategory != null) {
                  setState(() {
                    categoryText = newCategory.name;
                  });
                  widget.onCategoryChange(newCategory);
                }
              }
          );
          dialog.showSelectCategoryDialog(context);
        }
      },
      enabled: widget.isEditEnabled,
      text: categoryText,
      textAlign: TextAlign.start,
      fontColor: widget.fontColor,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    );
  }

}
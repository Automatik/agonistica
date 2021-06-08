// @dart=2.9

import 'package:agonistica/core/models/category.dart';
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
    @required this.categoryName,
    @required this.isEditEnabled,
    @required this.teamCategoriesCallback,
    @required this.onCategoryChange,
    @required this.fontColor,
    @required this.fontSize,
    @required this.fontWeight,
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
                // close dialog
                Navigator.of(context).pop();
              }
          );
          await dialog.showSelectCategoryDialog(context);
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
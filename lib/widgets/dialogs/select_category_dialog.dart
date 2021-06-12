import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SelectCategoryDialog {

  final List<Category> categories;
  final Function(Category) onSelect;

  SelectCategoryDialog({
    required this.categories,
    required this.onSelect,
  });

  Future<void> showSelectCategoryDialog(BuildContext context) async {
    await showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
          title: Text(
            "Seleziona la categoria a cui appartiene il giocatore",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: blueAgonisticaColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          material: (_, __) => MaterialAlertDialogData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )
          ),
          content: Container(
            constraints: BoxConstraints(
              minWidth: 0.9 * MediaQuery.of(context).size.width,
              maxWidth: 0.9 * MediaQuery.of(context).size.width,
              minHeight: 0.2 * MediaQuery.of(context).size.height,
              maxHeight: 0.4 * MediaQuery.of(context).size.height,
            ),
            child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (itemContext, index) {
                  final cat = categories[index];
                  return ListTile(
                    onTap: () async => await onSelect(cat),
                    dense: true,
                    title: Text(
                      cat.name!,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                }
            ),
          ),
        ),
    );
  }

}
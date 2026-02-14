import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../categories/data/category_model.dart';
import '../../categories/logic/category_provider.dart';
import 'create_or_edit_category_screen.dart';

class CategoryPickerSheet extends StatelessWidget {
  final String? selectedCategoryId;

  const CategoryPickerSheet({
    super.key,
    required this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Select Category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // LIST OF CATEGORIES
          ...categories.map((cat) {
            return ListTile(
              leading: CircleAvatar(
                radius: 10,
                backgroundColor: Color(cat.colourValue),
              ),
              title: Text(cat.name),
              subtitle: (cat.notes != null && cat.notes!.isNotEmpty)
                  ? Text(cat.notes!)
                  : null,
              trailing: selectedCategoryId == cat.id
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                Navigator.pop(context, cat.id);
              },
            );
          }),

          const Divider(),

          // CREATE NEW CATEGORY
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Create New Category"),
            onTap: () {
              Navigator.pop(context); // close sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateOrEditCategoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
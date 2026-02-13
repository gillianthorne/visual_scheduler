

import 'package:flutter/material.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';

import '../data/category_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class CreateOrEditCategoryScreen extends StatefulWidget {
  final Category? category;

  const CreateOrEditCategoryScreen({super.key, this.category});

  @override
  State<CreateOrEditCategoryScreen> createState() =>
      _CreateOrEditCategoryScreenState();
}

class _CreateOrEditCategoryScreenState
    extends State<CreateOrEditCategoryScreen> {
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  final uuid = Uuid();


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? "");
    _notesController = TextEditingController(text: widget.category?.notes ?? "");
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? "New Category" : "Edit Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Category Name"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: "Notes (optional)"),
              maxLines: 3,
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                final updatedCategory = (widget.category ?? Category(
                  id: uuid.v4(),
                  name: _nameController.text,
                  colourValue: 0xFFFC107,
                  iconName: null,
                  sortOrder: 0,
                  notes: null,
                )).copyWith(
                  name: _nameController.text,
                  notes: _notesController.text.isEmpty ? null : _notesController.text,
                );

                // 3. Update via provider
                context.read<CategoryProvider>().updateCategory(updatedCategory);

                // 4. Pop back
                Navigator.pop(context);
              },
              child: Text(widget.category == null ? "Create" : "Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
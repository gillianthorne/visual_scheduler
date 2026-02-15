

import 'package:flutter/material.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import 'package:visual_scheduler/features/tasks/data/task_model.dart';
import 'package:visual_scheduler/features/tasks/logic/task_provider.dart';

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

class _CreateOrEditCategoryScreenState extends State<CreateOrEditCategoryScreen> {
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  late Color selectedColour;
  late Category? editableCategory;

  final uuid = Uuid();

  final List<Color> presetColours = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink.shade300,
    Colors.teal
  ];

  @override
  void initState() {
    super.initState();
    editableCategory = widget.category;

    _nameController = TextEditingController(text: editableCategory?.name ?? "");
    _notesController = TextEditingController(text: editableCategory?.notes ?? "");

    if (editableCategory != null) {
      selectedColour = Color(editableCategory!.colourValue);
      print("Colour value set to preexisting colour");
    } else {
      selectedColour = Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editableCategory == null ? "New Category" : "Edit Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // NAME
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Category Name"),
            ),

            const SizedBox(height: 16),

            // NOTES
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: "Notes (optional)"),
              maxLines: 3,
            ),

            const SizedBox(height: 16,),

            // COLOUR PICKER
            Wrap(
              spacing: 8,
              children: presetColours.map((c) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColour = c),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColour.toARGB32() == c.toARGB32() ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),


            const Spacer(),

            // SUBMIT
            Row (
              children: [
              ElevatedButton(
                onPressed: () {
                  Category updatedCategory;
                  if (editableCategory != null) {
                    updatedCategory = editableCategory!.copyWith(
                      name: _nameController.text,
                      colourValue: selectedColour.toARGB32(),
                      notes: _notesController.text,
                    );
                  } else {
                    updatedCategory = Category(
                      id: uuid.v4(),
                      name: _nameController.text,
                      colourValue: selectedColour.toARGB32(),
                      iconName: null,
                      sortOrder: 0,
                      notes: _notesController.text,
                    );
                  }
                  

                  // 3. Update via provider
                  context.read<CategoryProvider>().updateCategory(updatedCategory);

                  // 4. Pop back
                  Navigator.pop(context);
                },
                child: Text(editableCategory == null ? "Create" : "Save Changes"),
              ),
              // DELETE
              ElevatedButton(
                onPressed: () async {
                  List<Task> tasks = context.read<CategoryProvider>().getTasksWithId(context.read<TaskProvider>().tasks, editableCategory!.id);
                  print(tasks);
                  final confirmed = await showDialog<bool>(
                    context: context, 
                    builder: (context) => AlertDialog(
                        title: const Text("Delete Task"),
                        content: Text("Are you sure you want to delete this category? There are ${tasks.length} tasks in this category."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false), 
                            child: Text("Cancel")
                          ),
                          TextButton(
                            onPressed: () {
                              if (tasks.isEmpty) {
                                Navigator.pop(context, true);
                              } else {
                                for (Task task in tasks) {
                                  context.read<TaskProvider>().clearCategory(task.categoryId!);
                                }
                                Navigator.pop(context, true);
                              }
                            },
                            child: const Text("Delete"),
                          )
                        ],
                      ));
                      if (confirmed == true) {
                        context.read<CategoryProvider>().deleteCategory(editableCategory!.id);
                        Navigator.pop(context);
                      }
                }
              , child: Text("Delete category"))
              ]
            )
          ],
        ),
      ),
    );
  }
}
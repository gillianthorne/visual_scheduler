import 'package:flutter/material.dart';
import 'package:visual_scheduler/features/categories/data/category_model.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import 'package:visual_scheduler/features/categories/presentation/category_picker_sheet.dart';
import 'package:visual_scheduler/features/tasks/logic/task_provider.dart';
import '../../tasks/data/task_model.dart';
import 'package:provider/provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedStart;
  late Duration _selectedDuration;
  String? selectedCategoryId;
  Category? selectedCategory;
  late Task editableTask;

  final List<Duration> _durationOptions = List.generate(
    16,
    (i) => Duration(minutes: 15 * (i + 1)),
  );

  @override
  void initState() {
    super.initState();

    editableTask = widget.task;

    _titleController = TextEditingController(text: editableTask.title);
    _notesController = TextEditingController(text: editableTask.notes ?? "");

    _selectedDate = editableTask.date;

    _selectedStart = TimeOfDay(
      hour: editableTask.startOffset.inHours,
      minute: editableTask.startOffset.inMinutes % 60,
    );

    _selectedDuration = editableTask.duration;

    selectedCategoryId = editableTask.categoryId; // default: no category
    selectedCategory = selectedCategoryId != null ? context.read<CategoryProvider>().getCategoryById(selectedCategoryId!) : null;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // TITLE
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            const SizedBox(height: 16),

            // DATE PICKER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: ${_selectedDate.toLocal().toString().split(' ')[0]}"),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // START TIME PICKER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Start: ${_selectedStart.format(context)}"),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedStart,
                    );
                    if (picked != null) {
                      setState(() => _selectedStart = picked);
                    }
                  },
                  child: const Text("Pick Time"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // DURATION PICKER
            DropdownButton<Duration>(
              value: _selectedDuration,
              items: _durationOptions.map((d) {
                return DropdownMenuItem(
                  value: d,
                  child: Text("${d.inMinutes} minutes"),
                );
              }).toList(),
              onChanged: (d) {
                if (d != null) setState(() => _selectedDuration = d);
              },
            ),

            const SizedBox(height: 16),

            // NOTES
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: "Notes (optional)",
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // CATEGORY PICKER
            ListTile(
              title: const Text("Category"),
              subtitle: Text(selectedCategory == null ? "None" : selectedCategory!.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await showModalBottomSheet<String>(
                  context: context, 
                  builder: (context) => CategoryPickerSheet(selectedCategoryId: selectedCategoryId));
                  if (result != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        selectedCategoryId = result;
                        selectedCategory = context.read<CategoryProvider>().getCategoryById(result);
                        editableTask = editableTask.copyWith(categoryId: result);
                      });
                    });
                  }
              }
            ),

            const Spacer(),

            // SAVE BUTTON
            ElevatedButton(
              onPressed: () {
                // You handle the logic
                // 1. Convert TimeOfDay → Duration
                final updatedStartOffset = Duration(
                  hours: _selectedStart.hour,
                  minutes: _selectedStart.minute,
                );

                // 2. Build updated task
                final updatedTask = editableTask.copyWith(
                  title: _titleController.text,
                  notes: _notesController.text,
                  date: _selectedDate,
                  startOffset: updatedStartOffset,
                  duration: _selectedDuration,
                  categoryId: selectedCategoryId
                  // categoryId: ... (if you add category editing)
                );

                // 3. Update via provider
                context.read<TaskProvider>().updateTask(updatedTask);

                // 4. Pop back
                Navigator.pop(context);

              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
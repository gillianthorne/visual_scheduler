import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import 'package:visual_scheduler/features/templates/data/template_model.dart';
import 'package:visual_scheduler/features/templates/logic/template_provider.dart';
import 'package:visual_scheduler/features/templates/presentation/template_picker_sheet.dart';
import '../../tasks/logic/task_provider.dart';
import '../../tasks/data/task_model.dart';
import 'package:uuid/uuid.dart';
import '../../categories/data/category_model.dart';
import '../../categories/presentation/category_picker_sheet.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}


class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String? selectedCategoryId;
  Category? selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStart = const TimeOfDay(hour: 9, minute: 0);
  Duration _selectedDuration = const Duration(hours: 1);
  bool _reminder = true;

  String? selectedTemplateId;
  Template? selectedTemplate;

  String? taskTemplateId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = null; // default: no category
    selectedCategory = null;

    selectedTemplateId = null;
    selectedTemplate = null;
  }

  final List<Duration> _durationOptions = List.generate(
    16, 
    (i) => Duration(minutes: ( 15 * (i + 1)))
  );

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final selectedCategory = selectedCategoryId == null ? null : categoryProvider.getCategoryById(selectedCategoryId!);
    return Scaffold(
      appBar: AppBar(title: const Text("Create Task")),
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

            // DURATION PICKER (simple dropdown for MVP)
            DropdownButton<Duration>(
              value: _selectedDuration,
              items: _durationOptions.map((d) {
                return DropdownMenuItem(
                  value: d,
                  child: Text("${d.inMinutes} minutes")
                );
              }).toList(),
              onChanged: (d) {
                if (d != null) setState(() => _selectedDuration = d);
              },
            ),

            const SizedBox(height: 16),

            // CATEGORY PICKER
            ListTile(
              title: const Text("Category"),
              subtitle: Text(
                selectedCategory?.name ?? "None",
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await showModalBottomSheet<String>(
                  context: context,
                  builder: (_) => CategoryPickerSheet(
                    selectedCategoryId: selectedCategoryId,
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedCategoryId = result;
                  });
                }
              }
            ),

            const SizedBox(height: 16),

            SwitchListTile(
              title: Text("Do you want a reminder for this task?"),
              value: _reminder, 
              onChanged: (bool newValue) {
                setState(() {
                  _reminder = newValue;
                  print("Reminder set to $_reminder");
                });
              } 
            ),

            const SizedBox(height: 16,),

            // NOTES (optional!)
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: "Notes (optional)"
              ),
              maxLines: 3,
            ),

            const Spacer(),

            // SAVE BUTTON

            Row(
              children: [
                Expanded(
                  child:
                    ElevatedButton(
                      onPressed: () {
                        print("\n\nSaving task for $_selectedDate");
                        _saveTask(context);
                      },
                      child: const Text("Save Task"),
                    ),
                ),
                const SizedBox(width: 16,),
                Expanded (
                  child: 
                    ElevatedButton(
                      onPressed: () {
                        _saveTemplate(context);
                        Fluttertoast.showToast(
                          msg: "Category saved!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }, 
                      child: const Text("Save as template"))
                )    
              ]        
            ),
                
              
            ListTile(
              title: const Text("Load from Template"),
              subtitle: Text(selectedTemplate?.name ?? "None"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await showModalBottomSheet<String>(
                  context: context, 
                  builder: (_) => TemplatePickerSheet(
                    selectedTemplateId: selectedTemplateId,
                    ),
                );
                  if (result != null) {
                      setState(() {
                        selectedTemplateId = result;
                        selectedTemplate = context.read<TemplateProvider>().getTemplateById(selectedTemplateId!);
                        _updateTask(selectedTemplate!);
                      });
                      
                    }
                  }
                ),
              ]
              ),
            )
        );

  }

  void _saveTask(BuildContext context) {
    final provider = context.read<TaskProvider>();

    final startOffset = Duration(
      hours: _selectedStart.hour,
      minutes: _selectedStart.minute,
    );

    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text,
      startOffset: startOffset,
      duration: _selectedDuration,
      date: _selectedDate,
      categoryId: selectedCategoryId,
      templateId: null,
      allowOverlap: true,
      isReminder: _reminder,
      notes: _notesController.text
    );
    
    provider.addTask(task);

    Navigator.pop(context);
  }

  void _saveTemplate(BuildContext context) {
    final provider = context.read<TemplateProvider>();

    final template = Template(
      id: const Uuid().v4(), 
      name: _titleController.text, 
      duration: _selectedDuration,
      categoryId: selectedCategoryId,
      notes: _notesController.text
    );

    provider.addTemplate(template);
  }

  void _updateTask(Template template) {
    _titleController.text = template.name;
    _selectedDuration = template.duration;
    selectedCategoryId = template.categoryId;
    taskTemplateId = template.id;
    if (template.notes != null) {
      _notesController.text = template.notes!;
    }
  }
}
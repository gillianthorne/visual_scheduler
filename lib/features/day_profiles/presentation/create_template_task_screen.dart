import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:visual_scheduler/features/categories/data/category_model.dart';
import 'package:visual_scheduler/features/categories/presentation/category_picker_sheet.dart';
import 'package:visual_scheduler/features/templates/data/template_model.dart';
import 'package:visual_scheduler/features/templates/logic/template_provider.dart';

class CreateTemplateTaskScreen extends StatefulWidget {

  const CreateTemplateTaskScreen({super.key});

  @override
  State<CreateTemplateTaskScreen> createState() => _CreateTemplateTaskScreenState();
}

class _CreateTemplateTaskScreenState extends State<CreateTemplateTaskScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  TimeOfDay _selectedStart = const TimeOfDay(hour: 9, minute: 0);
  Duration _selectedDuration = const Duration(hours: 1);
  String? selectedCategoryId;
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = null;
    selectedCategoryId = null;
  }

  final List<Duration> _durationOptions = List.generate(
    16, 
    (i) => Duration(minutes: ( 15 * (i + 1)))
  );


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Create Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            const SizedBox(height: 16,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Start: ${_selectedStart.format(context)}"),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context, 
                      initialTime: _selectedStart
                    );
                    if (picked != null ) {
                      setState(() => _selectedStart = picked);
                    }
                  }, child: const Text("Pick Time"))
              ],
            ),

            const SizedBox(height: 16,),

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

            const SizedBox(height: 16,),

            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: "Notes (optional)"
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => _saveTemplate(context),
              child: const Text("Save template"),
            )

          ],
        ),
      ),
    );
  }
  void _saveTemplate(BuildContext context) {
    final provider = context.read<TemplateProvider>();

    final template = Template(
      id: const Uuid().v4(), 
      name: _titleController.text, 
      duration: _selectedDuration,
      categoryId: selectedCategoryId,
      notes: _notesController.text,
      startOffset: Duration(hours: _selectedStart.hour, minutes: _selectedStart.minute)
    );

    provider.addTemplate(template);
  }
}
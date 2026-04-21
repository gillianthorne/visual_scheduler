import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:visual_scheduler/features/categories/data/category_model.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import 'package:visual_scheduler/features/categories/presentation/category_picker_sheet.dart';
import 'package:visual_scheduler/features/templates/data/template_model.dart';
import 'package:visual_scheduler/features/templates/logic/template_provider.dart';

class CreateTemplateScreen extends StatefulWidget {
  final List<Template> templateList;
  final String profileName;

  const CreateTemplateScreen({
    super.key, 
    required this.templateList,
    required this.profileName
  });

  @override
  State<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends State<CreateTemplateScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  Duration _selectedDuration = const Duration(hours: 1);
  String? selectedCategoryId;
  Category? selectedCategory;
  TimeOfDay _selectedStart = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    selectedCategoryId = null;
    selectedCategory = null;
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
      appBar: AppBar(title: const Text("Create Template Task")),
      body: Padding(padding: const EdgeInsetsGeometry.all(16),
        child: Column(children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Name"),
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

            ElevatedButton(
              onPressed: () => _saveTemplate(context),
              child: const Text("Save template"),
            )
        ],),
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

    widget.templateList.add(template);

    // Navigator.pop(context, widget.templateList);
    Navigator.pop(context);
    // Navigator.push(context,
    // MaterialPageRoute(builder: (_) => CreateDayProfileScreen(templateList: widget.templateList,)));
  }
}
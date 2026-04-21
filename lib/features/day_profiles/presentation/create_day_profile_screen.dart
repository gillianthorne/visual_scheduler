import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import 'package:visual_scheduler/features/day_profiles/data/day_profile_model.dart';
import 'package:visual_scheduler/features/day_profiles/logic/day_profile_provider.dart';
import 'package:visual_scheduler/features/tasks/presentation/daily_timeline_screen.dart';
import 'package:visual_scheduler/features/templates/data/template_model.dart';
import 'package:visual_scheduler/features/templates/logic/template_provider.dart';
import 'package:visual_scheduler/features/templates/presentation/create_template_screen.dart';
import 'package:visual_scheduler/features/templates/presentation/template_picker_sheet.dart';

class CreateDayProfileScreen extends StatefulWidget {
  final List<Template> templateList;
  final String profileName;

  const CreateDayProfileScreen({
    super.key, 
    required this.templateList,
    required this.profileName
  });

  @override
  State<CreateDayProfileScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateDayProfileScreen> {
  late TextEditingController _nameController;
  late Template editableTemplate;
  String? selectedTemplateId;
  Template? selectedTemplate;


  @override
  void initState() {
    super.initState();

    selectedTemplateId = null;
    selectedTemplate = null;

    _nameController = TextEditingController(text: widget.profileName);
  }

  @override
  Widget build(BuildContext context) {
    final templateProvider = context.watch<TemplateProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final selectedTemplate = selectedTemplateId == null ? null : templateProvider.getTemplateById(selectedTemplateId!);
    return Scaffold (
      appBar: AppBar(
        title: const Text("Create Template"),
      ),
      body: Padding (
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),

              SizedBox(height: 16,),
              
              Expanded(
                child: 
                  ListView.builder(
                  itemCount: widget.templateList.length,
                  itemBuilder: (context, index) {
                    int startHours = widget.templateList[index].startOffset!.inHours;
                    int startMnutes = widget.templateList[index].startOffset!.inMinutes - startHours * 60;

                    int durationHours = widget.templateList[index].duration.inHours;
                    int durationMinutes = widget.templateList[index].duration.inMinutes - durationHours * 60;

                    Color colour = Colors.white;

                    print(widget.templateList[index].categoryId);
                    
                    if (widget.templateList[index].categoryId == null) {
                      colour = Colors.white;
                    } else if (categoryProvider.getCategoryById(widget.templateList[index].categoryId!)?.colourValue == null) {
                      colour = Colors.black;
                    } else {
                      colour = Color(categoryProvider.getCategoryById(widget.templateList[index].categoryId!)!.colourValue);
                    }
                    return ListTile(
                      title: Text(widget.templateList[index].name),
                      subtitle: Text("Starts at $startHours:$startMnutes for $durationHours:$durationMinutes"),
                      shape: Border(
                        left: BorderSide(
                          color: colour,
                          width: 5,
                        )
                      ),
                      onLongPress: () {
                        showDialog(
                          context: context, 
                          builder: (context) => AlertDialog(
                            title: const Text("Are you sure you want to delete this task?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget.templateList.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete"),
                              )
                            ],
                          ));
                      },
                    );
                  }),
              ),

              SizedBox(height: 16,),

              ListTile(
                title: const Text("Load pre-existing task template"),
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
                      widget.templateList.add(templateProvider.getTemplateById(result)!);
                    });
                  }
                }
              ),
              
              const SizedBox(height: 16,),

              Row(
                children: [
                  Expanded(child: 
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreateTemplateScreen(
                          templateList: widget.templateList, 
                          profileName: _nameController.text)
                          )
                      );
                    },
                    child: const Text("Create Task"),
                    ),),
                  const SizedBox(width: 16,),
                  Expanded(child: 
                  ElevatedButton(
                    onPressed: () {
                      _saveProfile(context);
                      Fluttertoast.showToast(
                        msg: "Day profile saved!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DailyTimelineScreen())
                      );
                    },
                    child: const Text("Save day profile"),)),
                ],
              )
              
          ]
        ),
        ),
      );
  }

  void _saveProfile(BuildContext context) {
    final provider = context.read<DayProfileProvider>();

    final profile = DayProfile(
      id: const Uuid().v4(),
      name: _nameController.text,
      tasks: widget.templateList);

    provider.addProfile(profile);
  }
}
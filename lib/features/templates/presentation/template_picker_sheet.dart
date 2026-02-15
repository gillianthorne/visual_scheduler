import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_scheduler/features/templates/logic/template_provider.dart';

class TemplatePickerSheet extends StatefulWidget {
  final String? selectedTemplateId;

  const TemplatePickerSheet({
    super.key,
    required this.selectedTemplateId,
  });
  @override
  State<TemplatePickerSheet> createState() => _TemplatePickerSheet();
}

class _TemplatePickerSheet extends State<TemplatePickerSheet> {
  @override
  Widget build(BuildContext context) {
    final templates = context.watch<TemplateProvider>().templates;

    return SafeArea(
      child: Column (
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Select Template",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),),
          ),

          ...templates.map((template) {
            return ListTile(
              title: Text(template.name),
              subtitle: (template.notes != null && template.notes!.isNotEmpty)
              ? Text(template.notes!) : null,
              onTap: () {
                print(template.name);
                Navigator.pop(context, template.id);
              },
              // TO DO: ADD EDITING TEMPLATES
              /*
              onLongPress: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditTemplateScreen(template))
                );
              }
              */
            );
            
          })
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_scheduler/features/day_profiles/data/day_profile_model.dart';
import 'package:visual_scheduler/features/day_profiles/logic/day_profile_provider.dart';
import 'package:visual_scheduler/features/day_profiles/presentation/create_day_profile_screen.dart';
import '../../categories/logic/category_provider.dart';

class DayProfilePickerSheet extends StatelessWidget {
  final String? selectedDayProfileId;

  const DayProfilePickerSheet({
    super.key,
    required this.selectedDayProfileId,
  });

  @override
  Widget build(BuildContext context) {
    final dayProfiles = context.watch<DayProfileProvider>().profile;

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
          ...dayProfiles.map((cat) {
            return ListTile(
              title: Text(cat.name),
              subtitle: (Text(cat.tasks.length.toString() + " tasks")),
              trailing: selectedDayProfileId == cat.id
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
            title: const Text("Create New Day Profile"),
            onTap: () {
              Navigator.pop(context); // close sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateDayProfileScreen(templateList: [], profileName: '',),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import '../data/task_model.dart';
import "edit_task_screen.dart";
import 'package:provider/provider.dart';
import '../logic/task_provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task; // initial version
    
  }

  void _refreshTask() {
    final provider = context.read<TaskProvider>();
    final updated = provider.getTaskById(task.id);

    if (updated != null) {
      setState(() {
        task = updated;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    print("categoryId type: ${task.categoryId.runtimeType}");
    print("categoryId value: ${task.categoryId}");
    final start = task.startOffset;
    final end = task.startOffset + task.duration;

    String formatTime(Duration d) {
      final h = d.inHours.toString().padLeft(2, "0");
      final m = (d.inMinutes % 60).toString().padLeft(2, "0");
      return "$h:$m";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text (
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "${formatTime(start)} - ${formatTime(end)}",
              style: const TextStyle(color: Colors.grey)
            ),

            const SizedBox(height: 8),

            // DURATION
            Text(
              "Duration: ${task.duration.inMinutes} minutes",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // NOTES
            if (task.notes != null && task.notes!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(task.notes!),
                  const SizedBox(height: 24),
                ],
              ),

            // CATEGORY
            if (task.categoryId != null)
              _buildCategorySection(context, task.categoryId!),

            const Spacer(),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTaskScreen(task: task),
                        ),
                      );
                      _refreshTask();
                    },
                    child: const Text("Edit"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: implement save as template
                    },
                    child: const Text("Save as Template"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCategorySection(BuildContext context, String categoryId) {
    final category = context.read<CategoryProvider>().getCategoryById(categoryId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Placeholder"
          // {category!.name}
        ),
        const SizedBox(height: 4),
        Text("Category notes here"),
        const SizedBox(height: 24),
      ],
    );
  }
}

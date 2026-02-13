import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import 'package:visual_scheduler/features/tasks/logic/task_provider.dart';
import '../data/task_model.dart';
import 'edit_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task; // initial snapshot

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  String _formatTime(Duration d) {
    final h = d.inHours.toString().padLeft(2, "0");
    final m = (d.inMinutes % 60).toString().padLeft(2, "0");
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context) {
    // Always prefer the latest version from provider, fall back to the passed-in one
    final providerTask =
        context.watch<TaskProvider>().getTaskById(task.id);
    final effectiveTask = providerTask ?? task;

    final start = effectiveTask.startOffset;
    final end = effectiveTask.startOffset + effectiveTask.duration;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Text(
              effectiveTask.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // TIME RANGE
            Text(
              "${_formatTime(start)} - ${_formatTime(end)}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 8),

            // DURATION
            Text(
              "Duration: ${effectiveTask.duration.inMinutes} minutes",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // NOTES
            if (effectiveTask.notes != null &&
                effectiveTask.notes!.isNotEmpty)
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
                  Text(effectiveTask.notes!),
                  const SizedBox(height: 24),
                ],
              ),

            // CATEGORY
            if (effectiveTask.categoryId != null)
              _buildCategorySection(
                context,
                effectiveTask.categoryId!,
              ),

            const Spacer(),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditTaskScreen(task: effectiveTask),
                        ),
                      );
                      // No manual refresh needed: provider + watch() rebuild this screen
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
    final category =
        context.watch<CategoryProvider>().getCategoryById(categoryId);

    if (category == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category: ${category.name}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text("Placeholder"),
        const SizedBox(height: 4),
        const Text("Category notes here"),
        const SizedBox(height: 24),
      ],
    );
  }
}
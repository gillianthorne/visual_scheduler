import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import '../../data/task_model.dart';

class TimelineTaskBlock extends StatelessWidget {
  final Task task;

  const TimelineTaskBlock({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final height = task.duration.inMinutes.toDouble();
    
    final category = context.watch<CategoryProvider>().getCategoryById(task.categoryId ?? "");
    final int colour = category?.colourValue ?? Colors.deepPurple.shade300.toARGB32();

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(
        // vertical: 8,
        horizontal: 16
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      decoration: BoxDecoration(
        color: Color(colour),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            task.title, 
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            )),
          const SizedBox(width: 14),
          Text(_formatTimeRange(task),
          style: const TextStyle(fontSize: 14))
        ],
      ),
    );
  }

  String _formatTimeRange(Task task) {
    final start = _formatTime(task.startOffset);
    final end = _formatTime(task.startOffset + task.duration);
    return "$start - $end";
  }

  String _formatTime(Duration offset) {
    final hours = offset.inHours;
    final minutes = offset.inMinutes % 60;
    final h = hours.toString().padLeft(2, "0");
    final m = minutes.toString().padLeft(2, "0");
    return "$h:$m";
  }
}
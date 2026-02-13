import 'package:flutter/material.dart';
import '../../data/task_model.dart';

class TimelineTaskBlock extends StatelessWidget {
  final Task task;

  const TimelineTaskBlock({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final height = task.duration.inMinutes.toDouble();

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title, 
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            )),
          const SizedBox(height: 4),
          Text(_formatTimeRange(task),
          style: const TextStyle(fontSize: 12))
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
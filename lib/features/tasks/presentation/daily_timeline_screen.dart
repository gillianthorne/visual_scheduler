import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import 'package:visual_scheduler/features/tasks/presentation/create_task_screen.dart';
import 'package:visual_scheduler/features/tasks/presentation/widgets/timeline_task_block.dart';
import '../../tasks/logic/task_provider.dart';
import '../data/task_model.dart';
import 'task_details_screen.dart';

class DailyTimelineScreen extends StatefulWidget {
  const DailyTimelineScreen({super.key});

  @override
  State<DailyTimelineScreen> createState() => _DailyTimelineScreenState();
}

class _DailyTimelineScreenState extends State<DailyTimelineScreen> {
  DateTime _selectedDate = DateTime.now(); 

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasksForDate(_selectedDate); // You'll filter these by date
    // TODO: sort tasks by start time
    tasks.sort((a, b) => a.startOffset.compareTo(b.startOffset));
    print("\n\nTimeline showing date: $_selectedDate");
    return Scaffold(
    body: Column(
      children: [
        _buildDateHeader(),

        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 48 * 60,
              child: Stack(
                children: [
                  _buildTimelineGrid(),      // 30-min intervals
                  _buildTaskBlocks(tasks),   // positioned tasks
                ],
              ),
            ),
            
          ),
        ),
      ],
    ),

    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreateTaskScreen()),
        );
      },
      child: const Icon(Icons.add),
    ),
  );

  }

  Widget _buildTimelineLabels() {
    return Column(
      children: List.generate(24, (i) {
        return SizedBox(
          height: 60,
          child: Text(
            "${i.toString().padLeft(2, '0')}:00",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      }),
    );
  }

  Widget _buildDateSelector() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () {
          setState(() {
            _selectedDate = _selectedDate.subtract(const Duration(days: 1));
          });
        },
      ),

      Text(
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      IconButton(
        icon: const Icon(Icons.chevron_right),
        onPressed: () {
          setState(() {
            _selectedDate = _selectedDate.add(const Duration(days: 1));
          });
        },
      ),
    ],
  );
}
  
  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            }, 
            icon: const Icon(Icons.chevron_left)),
  
          Text (
            "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
            style: const TextStyle (
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),

          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            }, 
            icon: const Icon(Icons.chevron_right)),
  
        ],
    ));
  }

  Widget _buildTimelineGrid() {
    return Column(
      children: List.generate(48, (i) {
        final hour = i ~/ 2;
        final minute = (i % 2) * 30;

        return Container(
          height: 60,
          padding: const EdgeInsets.only(left: 16),
          alignment: Alignment.topLeft,
          child: Text(
            "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      }),
    );
  }

Widget _buildTaskBlocks(List<Task> tasks) {
    return Stack(
      children: tasks.map((task) {
        final startMinutes = task.startOffset.inMinutes;
        final durationMinutes = task.duration.inMinutes;
        return Positioned(
          top: startMinutes * 2,
          left: 80,
          right: 16, 
          height: durationMinutes * 2,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailsScreen(task: task),
                ),
              );
            },
            child: TimelineTaskBlock(task: task),
          ),
        );
      }).toList(),
    );
  }
}
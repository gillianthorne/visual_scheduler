import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  int startTime = 6;
  double pixelHeight = 4;

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasksForDate(_selectedDate); // You'll filter these by date
    tasks.sort((a, b) => a.startOffset.compareTo(b.startOffset));
    return Scaffold(
    body: Column(
  children: [
    _buildDateHeader(),

    Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          // height is working in half hours, so 48 - start time as half hours, multiplied
          // by each half hour in pixel height, plus a bit of padding at the bottom of the screen
          height: (48 - startTime * 2) * 30 * pixelHeight + 16,
          child: Row(
            children: [
              // LEFT TIME COLUMN
              Container(
                width: 75,
                color: Colors.deepPurple.shade50,
                child: _buildTimelineGrid(),
              ),

              // TASK AREA
              Expanded(
                child: Stack(
                  children: [
                    _buildGridLines(),
                    _buildTaskBlocks(tasks) // positioned tasks
                  ],
                ),
              ),
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
    return Container (
      child: Column(
        children: List.generate(24, (i) {
          return SizedBox(
            height: 60,
            child: Text(
              "${i.toString().padLeft(2, '0')}:00",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        }),
      )
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
    final date = _selectedDate;
    final dayName = DateFormat("EEEE").format(date);
    final monthDay = DateFormat("MMMM d").format(date);
    final year = DateFormat('y').format(date);

    return Container (
      color: Colors.deepPurple.shade50,
      child: Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(16, 32, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            }, 
            icon: Icon(Icons.chevron_left, size: 32)),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(dayName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(monthDay, style: TextStyle(fontSize: 16)),
                Text(year, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            }, 
            icon: const Icon(Icons.chevron_right, size: 32,)),
        ],
    ))    
    );
  }

  Widget _buildTimelineGrid() {
    return Column(
      children: List.generate(48 - (startTime*2), (i) {
        final hour = (i ~/ 2) + startTime;
        final minute = (i % 2) * 30;

        return Container(
            height: 30 * pixelHeight,
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.deepPurple.shade100)
              )
            ),
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
            top: startMinutes * pixelHeight,
            left: 8,
            right: 8, 
            height: durationMinutes * pixelHeight,
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

  Widget _buildGridLines() {
  final totalMinutes = (24 - 6) * 60;

  return Stack(
    children: List.generate(totalMinutes ~/ 60, (index) {
      final minutesSinceStart = index * 60;
      double top = minutesSinceStart * 4;

      return Positioned(
        top: top,
        left: 0,
        right: 0,
        child: Container(
          height: 1,
          color: Colors.deepPurple.shade100
        ),
      );
    })
  );
}
}
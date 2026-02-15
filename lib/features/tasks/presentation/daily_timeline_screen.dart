import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visual_scheduler/features/tasks/presentation/create_task_screen.dart';
import 'package:visual_scheduler/features/tasks/presentation/widgets/timeline_task_block.dart';
import '../../tasks/logic/task_provider.dart';
import '../data/task_model.dart';
import 'task_details_screen.dart';
import 'dart:async';

class DailyTimelineScreen extends StatefulWidget {
  const DailyTimelineScreen({super.key});

  @override
  State<DailyTimelineScreen> createState() => _DailyTimelineScreenState();
}

class _DailyTimelineScreenState extends State<DailyTimelineScreen> {
  DateTime _selectedDate = DateTime.now(); 
  int startTime = 6;
  double pixelHeight = 4;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 5), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


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
                // width: 100,
                // color: Colors.deepPurple.shade50,
                child: _buildTimelineGrid(),
              ),

              // TASK AREA
              Expanded(
                child: Stack(
                  children: [
                    _buildGridLines(),
                    _buildTaskBlocks(tasks), // positioned tasks
                    _buildTimeLine()
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

  Widget _buildDateHeader() {
    final date = _selectedDate;
    final dayName = DateFormat("EEEE").format(date);
    final monthDay = DateFormat("MMMM d").format(date);
    final year = DateFormat('y').format(date);

    return Container (
      color: Colors.deepPurple.shade100,
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
        int hour = (i ~/ 2) + startTime;
        final amPm = (hour >= 12) ? "PM" : "AM";
        hour = (amPm == "PM" ? hour = hour - 12 : hour);
        final minute = (i % 2) * 30;

        return Container(
            width: 100,
            height: 30 * pixelHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.deepPurple.shade100, width: 2)
              ),
              color: (minute == 0 ? Colors.deepPurple.shade50 : Colors.deepPurple.shade100),
            ),
            child: Text(
              "${hour.toString()}:${minute.toString().padLeft(2, "0")} $amPm",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        );
      }),
    );
  }

  Widget _buildTaskBlocks(List<Task> tasks) {
  final layout = _computeTaskLayout(tasks);

  return LayoutBuilder(
    builder: (context, constraints) {
      final timelineWidth = constraints.maxWidth;

      return Stack(
        children: tasks.map((task) {
          final info = layout[task]!;
          final startMinutes = task.startOffset.inMinutes;
          final durationMinutes = task.duration.inMinutes;

          final columnWidth = timelineWidth / info.columnCount;
          final left = info.columnIndex * columnWidth;

          return Positioned(
            top: startMinutes * pixelHeight - (startTime * 60 * pixelHeight),
            left: left,
            width: columnWidth,
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
    },
  );
}

  Widget _buildGridLines() {
  final totalMinutes = (24 - 6) * 60 * 2;

  return Stack(
    children: List.generate(totalMinutes ~/ 15, (index) {
      // print(index);
      final minutesSinceStart = index * 15;
      // print(minutesSinceStart);
      double top = minutesSinceStart * 4 + 1;
      BorderSide border = BorderSide();

      if (minutesSinceStart % 60 == 0) {
        border = BorderSide(color: Colors.deepPurple.shade100, width: 2);
      }
      else if (minutesSinceStart % 60 == 30) {
        border = BorderSide(color: Colors.deepPurple.shade100, width: 1);
      } 

      if (minutesSinceStart % 30 != 15 ) {
        return Positioned(
          top: top,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                bottom: border
              )
            ),
          ),
        );
      } else {
        // print(minutesSinceStart);
        return Positioned(
          top: top,
          left: 0,
          right: 0,
          child: DottedBorder(
            options: RectDottedBorderOptions(
              strokeWidth: 1,
              padding: EdgeInsets.all(0),
              dashPattern: [10, 5],
              color: Colors.deepPurple.shade50,
            ),
            child: Container(
              height: 0,
            )
          )
        );
      }
      
    })
  );
}

  Widget _buildTimeLine() {
    Duration offset = Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute);
    
    double lineOffset = offset.inMinutes.toDouble() * pixelHeight - (startTime * 60 * pixelHeight);

    final today = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    final comparedDay = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";


    if (today == comparedDay) {
      return Positioned(
        top: lineOffset,
        left: 0,
        right: 0,
        child: Container(
          height: 3,
          color: Colors.red,
        ),
    );
    } else {
      return Positioned (
        top: -5,
        left: 0,
        right: 0,
        child: Container(
          height: 3,
          color: Colors.red,
        )
      );
    }    
  }

  
Map<Task, TaskLayoutInfo> _computeTaskLayout(List<Task> tasks) {
  // Convert tasks to intervals
  final intervals = tasks.map((task) {
    final start = task.startOffset.inMinutes;
    final end = start + task.duration.inMinutes;
    return _TaskInterval(task: task, start: start, end: end);
  }).toList();

  // Sort by start time
  intervals.sort((a, b) => a.start.compareTo(b.start));

  final layout = <Task, TaskLayoutInfo>{};
  List<_TaskInterval> currentGroup = [];

  bool overlaps(a, b) =>
      a.start < b.end && a.end > b.start;

  void processGroup(List<_TaskInterval> group) {
    if (group.isEmpty) return;

    // Column assignment
    final columns = <List<_TaskInterval>>[];

    for (final item in group) {
      bool placed = false;

      for (final column in columns) {
        final last = column.last;
        if (!overlaps(item, last)) {
          column.add(item);
          placed = true;
          break;
        }
      }

      if (!placed) {
        columns.add([item]);
      }
    }

    final columnCount = columns.length;

    for (int col = 0; col < columns.length; col++) {
      for (final item in columns[col]) {
        layout[item.task] = TaskLayoutInfo(
          columnIndex: col,
          columnCount: columnCount,
        );
      }
    }
  }

  // Build overlap groups
  for (final item in intervals) {
    if (currentGroup.isEmpty) {
      currentGroup.add(item);
      continue;
    }

    final overlapsAny = currentGroup.any((g) => overlaps(g, item));

    if (overlapsAny) {
      currentGroup.add(item);
    } else {
      processGroup(currentGroup);
      currentGroup = [item];
    }
  }

  // Process last group
  processGroup(currentGroup);

  return layout;
}
}

class TaskLayoutInfo {
  final int columnIndex;
  final int columnCount;

  TaskLayoutInfo({
    required this.columnIndex,
    required this.columnCount,
  });
}

class _TaskInterval {
  final Task task;
  final int start;
  final int end;

  _TaskInterval({
    required this.task,
    required this.start,
    required this.end,
  });
}

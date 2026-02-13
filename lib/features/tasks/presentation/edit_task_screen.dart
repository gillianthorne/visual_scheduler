import 'package:flutter/material.dart';
import 'package:visual_scheduler/features/tasks/logic/task_provider.dart';
import '../../tasks/data/task_model.dart';
import 'package:provider/provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedStart;
  late Duration _selectedDuration;

  final List<Duration> _durationOptions = List.generate(
    16,
    (i) => Duration(minutes: 15 * (i + 1)),
  );

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.title);
    _notesController = TextEditingController(text: widget.task.notes ?? "");

    _selectedDate = widget.task.date;

    _selectedStart = TimeOfDay(
      hour: widget.task.startOffset.inHours,
      minute: widget.task.startOffset.inMinutes % 60,
    );

    _selectedDuration = widget.task.duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // TITLE
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            const SizedBox(height: 16),

            // DATE PICKER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: ${_selectedDate.toLocal().toString().split(' ')[0]}"),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // START TIME PICKER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Start: ${_selectedStart.format(context)}"),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedStart,
                    );
                    if (picked != null) {
                      setState(() => _selectedStart = picked);
                    }
                  },
                  child: const Text("Pick Time"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // DURATION PICKER
            DropdownButton<Duration>(
              value: _selectedDuration,
              items: _durationOptions.map((d) {
                return DropdownMenuItem(
                  value: d,
                  child: Text("${d.inMinutes} minutes"),
                );
              }).toList(),
              onChanged: (d) {
                if (d != null) setState(() => _selectedDuration = d);
              },
            ),

            const SizedBox(height: 16),

            // NOTES
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: "Notes (optional)",
              ),
              maxLines: 3,
            ),

            const Spacer(),

            // SAVE BUTTON
            ElevatedButton(
              onPressed: () {
                // You handle the logic
                // 1. Convert TimeOfDay → Duration
                final updatedStartOffset = Duration(
                  hours: _selectedStart.hour,
                  minutes: _selectedStart.minute,
                );

                // 2. Build updated task
                final updatedTask = widget.task.copyWith(
                  title: _titleController.text,
                  notes: _notesController.text,
                  date: _selectedDate,
                  startOffset: updatedStartOffset,
                  duration: _selectedDuration,
                  // categoryId: ... (if you add category editing)
                );

                // 3. Update via provider
                context.read<TaskProvider>().updateTask(updatedTask);

                // 4. Pop back
                Navigator.pop(context);

              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
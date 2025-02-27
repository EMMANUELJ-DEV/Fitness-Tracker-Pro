import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import 'package:intl/intl.dart';

class WorkoutCalendarScreen extends StatefulWidget {
  const WorkoutCalendarScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutCalendarScreen> createState() => _WorkoutCalendarScreenState();
}

class _WorkoutCalendarScreenState extends State<WorkoutCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Calendar'),
        backgroundColor: primaryColor,
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, _) {
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) => workoutProvider.getWorkoutsForDate(day),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                  markerDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  leftChevronIcon: Icon(Icons.chevron_left, color: primaryColor),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: primaryColor),
                ),
              ),
              const Divider(),
              Expanded(
                child: _selectedDay == null
                    ? const Center(child: Text('Select a day to view workouts'))
                    : _buildWorkoutList(
                        workoutProvider.getWorkoutsForDate(_selectedDay!)),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _showScheduleWorkoutDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkoutList(List<Workout> workouts) {
    if (workouts.isEmpty) {
      return const Center(child: Text('No workouts scheduled for this day'));
    }
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          child: ListTile(
            title: Text(workout.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                Text('${workout.duration}, ${workout.exercises} exercises'),
            trailing: Text(DateFormat('HH:mm').format(workout.date)),
          ),
        );
      },
    );
  }

  void _showScheduleWorkoutDialog(BuildContext context) {
    final nameController = TextEditingController();
    final durationController = TextEditingController();
    final exercisesController = TextEditingController();
    DateTime selectedDate = _selectedDay ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Schedule Workout'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Workout Name'),
                  ),
                  TextField(
                    controller: durationController,
                    decoration: const InputDecoration(
                        labelText: 'Duration (minutes)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: exercisesController,
                    decoration: const InputDecoration(
                        labelText: 'Number of Exercises'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                        'Date: ${DateFormat('MMM d, y').format(selectedDate)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Time: ${selectedTime.format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) {
                        setState(() => selectedTime = time);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final DateTime workoutDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  final workout = Workout(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    duration: '${durationController.text} min',
                    exercises: int.parse(exercisesController.text),
                    date: workoutDateTime,
                  );
                  Provider.of<WorkoutProvider>(context, listen: false)
                      .addWorkout(workout);
                  Navigator.of(ctx).pop();
                },
                child: const Text('Schedule'),
              ),
            ],
          );
        },
      ),
    );
  }
}

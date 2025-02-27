import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/workout_list.dart';
import '../widgets/workout_categories.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../widgets/workout_history.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _exercisesController = TextEditingController();

  void _addWorkout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Workout Name'),
            ),
            TextField(
              controller: _durationController,
              decoration:
                  const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _exercisesController,
              decoration:
                  const InputDecoration(labelText: 'Number of Exercises'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final workout = Workout(
                id: DateTime.now().toString(),
                name: _nameController.text,
                duration: '${_durationController.text} min',
                exercises: int.parse(_exercisesController.text),
                date: DateTime.now(),
              );
              Provider.of<WorkoutProvider>(context, listen: false)
                  .addWorkout(workout);
              _nameController.clear();
              _durationController.clear();
              _exercisesController.clear();
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workouts'),
          backgroundColor: primaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Workouts'),
              Tab(text: 'Programs'),
              Tab(text: 'History'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () => Navigator.pushNamed(context, '/workout-calendar'),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor.withOpacity(0.1), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            children: [
              Consumer<WorkoutProvider>(
                builder: (ctx, workoutProvider, _) =>
                    WorkoutList(workouts: workoutProvider.workouts),
              ),
              const WorkoutCategories(),
              const WorkoutHistory(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: _addWorkout,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _exercisesController.dispose();
    super.dispose();
  }
}

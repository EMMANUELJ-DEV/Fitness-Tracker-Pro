import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;

  const WorkoutList({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const Center(
        child: Text('No workouts yet. Add your first workout!'),
      );
    }

    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return Dismissible(
          key: Key(workout.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            Provider.of<WorkoutProvider>(context, listen: false)
                .deleteWorkout(workout.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Workout deleted')),
            );
          },
          child: ListTile(
            title: Text(workout.name),
            subtitle: Text(workout.duration),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${workout.exercises} exercises'),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, workout),
                ),
              ],
            ),
            leading: const Icon(Icons.fitness_center),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Workout workout) {
    final nameController = TextEditingController(text: workout.name);
    final durationController = TextEditingController(
        text: workout.duration.replaceAll(' min', ''));
    final exercisesController =
        TextEditingController(text: workout.exercises.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Workout Name'),
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: exercisesController,
              decoration: const InputDecoration(labelText: 'Number of Exercises'),
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
              final updatedWorkout = Workout(
                id: workout.id,
                name: nameController.text,
                duration: '${durationController.text} min',
                exercises: int.parse(exercisesController.text),
                date: workout.date,
              );

              Provider.of<WorkoutProvider>(context, listen: false)
                  .updateWorkout(updatedWorkout);

              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workout updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 
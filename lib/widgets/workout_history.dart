import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import 'package:intl/intl.dart';

class WorkoutHistory extends StatelessWidget {
  const WorkoutHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (ctx, workoutProvider, _) {
        final workouts = workoutProvider.workouts;
        if (workouts.isEmpty) {
          return const Center(child: Text('No workout history yet'));
        }

        return ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return ListTile(
              title: Text(workout.name),
              subtitle: Text(DateFormat('MMM d, y').format(workout.date)),
              trailing: Text('${workout.duration}, ${workout.exercises} exercises'),
            );
          },
        );
      },
    );
  }
} 
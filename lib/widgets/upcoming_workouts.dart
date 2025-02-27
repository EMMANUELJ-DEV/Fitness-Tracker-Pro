import 'package:flutter/material.dart';
import '../models/workout.dart';
import 'package:intl/intl.dart';

class UpcomingWorkouts extends StatelessWidget {
  final List<Workout> workouts;

  const UpcomingWorkouts({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcomingWorkouts = workouts
        .where((workout) => workout.date.isAfter(now))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Workouts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (upcomingWorkouts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No upcoming workouts scheduled'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcomingWorkouts.take(3).length,
                itemBuilder: (context, index) {
                  final workout = upcomingWorkouts[index];
                  return ListTile(
                    title: Text(workout.name),
                    subtitle: Text(DateFormat('MMM d, y - HH:mm').format(workout.date)),
                    leading: const Icon(Icons.fitness_center),
                    trailing: Text(workout.duration),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
} 
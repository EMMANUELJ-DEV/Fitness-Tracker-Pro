import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import 'package:provider/provider.dart';

class WorkoutCategories extends StatelessWidget {
  const WorkoutCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildCategoryCard(
          context,
          'Strength',
          Icons.fitness_center,
          Colors.blue,
          strengthWorkouts,
        ),
        _buildCategoryCard(
          context,
          'Cardio',
          Icons.directions_run,
          Colors.red,
          cardioWorkouts,
        ),
        _buildCategoryCard(
          context,
          'Flexibility',
          Icons.self_improvement,
          Colors.green,
          flexibilityWorkouts,
        ),
        _buildCategoryCard(
          context,
          'HIIT',
          Icons.timer,
          Colors.orange,
          hiitWorkouts,
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Workout> workouts,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showWorkoutList(context, title, workouts),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkoutList(BuildContext context, String category, List<Workout> workouts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$category Workouts',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return ListTile(
                      title: Text(workout.name),
                      subtitle: Text(workout.duration),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // Add workout to user's workouts
                          final newWorkout = Workout(
                            id: DateTime.now().toString(),
                            name: workout.name,
                            duration: workout.duration,
                            exercises: workout.exercises,
                            date: DateTime.now(),
                          );
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .addWorkout(newWorkout);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Workout added to your list')),
                          );
                        },
                      ),
                      leading: const Icon(Icons.fitness_center),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Predefined workouts for each category
  List<Workout> get strengthWorkouts => [
        Workout(
          id: 'str1',
          name: 'Upper Body Power',
          duration: '45 min',
          exercises: 8,
          date: DateTime.now(),
        ),
        Workout(
          id: 'str2',
          name: 'Lower Body Strength',
          duration: '50 min',
          exercises: 7,
          date: DateTime.now(),
        ),
        Workout(
          id: 'str3',
          name: 'Full Body Workout',
          duration: '60 min',
          exercises: 12,
          date: DateTime.now(),
        ),
      ];

  List<Workout> get cardioWorkouts => [
        Workout(
          id: 'car1',
          name: 'HIIT Cardio',
          duration: '30 min',
          exercises: 6,
          date: DateTime.now(),
        ),
        Workout(
          id: 'car2',
          name: 'Endurance Run',
          duration: '45 min',
          exercises: 1,
          date: DateTime.now(),
        ),
        Workout(
          id: 'car3',
          name: 'Jump Rope Challenge',
          duration: '20 min',
          exercises: 4,
          date: DateTime.now(),
        ),
      ];

  List<Workout> get flexibilityWorkouts => [
        Workout(
          id: 'flex1',
          name: 'Morning Yoga',
          duration: '30 min',
          exercises: 10,
          date: DateTime.now(),
        ),
        Workout(
          id: 'flex2',
          name: 'Dynamic Stretching',
          duration: '25 min',
          exercises: 8,
          date: DateTime.now(),
        ),
        Workout(
          id: 'flex3',
          name: 'Mobility Flow',
          duration: '35 min',
          exercises: 12,
          date: DateTime.now(),
        ),
      ];

  List<Workout> get hiitWorkouts => [
        Workout(
          id: 'hiit1',
          name: 'Tabata Intervals',
          duration: '25 min',
          exercises: 8,
          date: DateTime.now(),
        ),
        Workout(
          id: 'hiit2',
          name: 'CrossFit WOD',
          duration: '40 min',
          exercises: 5,
          date: DateTime.now(),
        ),
        Workout(
          id: 'hiit3',
          name: 'Circuit Training',
          duration: '35 min',
          exercises: 10,
          date: DateTime.now(),
        ),
      ];
} 
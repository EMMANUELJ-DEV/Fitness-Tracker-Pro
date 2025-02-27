import 'package:flutter/material.dart';

class DailySummaryCard extends StatelessWidget {
  final int steps;
  final int calories;
  final int workouts;

  const DailySummaryCard({
    super.key,
    required this.steps,
    required this.calories,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  icon: Icons.directions_run,
                  value: steps.toString(),
                  label: 'Steps',
                ),
                _buildSummaryItem(
                  icon: Icons.local_fire_department,
                  value: calories.toString(),
                  label: 'Calories',
                ),
                _buildSummaryItem(
                  icon: Icons.fitness_center,
                  value: workouts.toString(),
                  label: 'Workouts',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
} 
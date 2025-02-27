import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onStartWorkout;
  final VoidCallback onLogMeal;
  final VoidCallback onLogWeight;

  const QuickActions({
    super.key,
    required this.onStartWorkout,
    required this.onLogMeal,
    required this.onLogWeight,
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
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.fitness_center, 'Start\nWorkout', onStartWorkout),
                _buildActionButton(Icons.restaurant, 'Log\nMeal', onLogMeal),
                _buildActionButton(Icons.monitor_weight, 'Log\nWeight', onLogWeight),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onTap,
          iconSize: 32,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
} 
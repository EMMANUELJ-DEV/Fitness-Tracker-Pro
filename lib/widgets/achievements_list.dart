import 'package:flutter/material.dart';

class AchievementsList extends StatelessWidget {
  const AchievementsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _buildAchievementItem('First Workout', 'Completed your first workout!'),
          _buildAchievementItem('Weight Goal', 'Lost first 5 pounds'),
          _buildAchievementItem('Consistent', '7 day streak'),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, String description) {
    return ListTile(
      leading: const Icon(Icons.star, color: Colors.amber),
      title: Text(title),
      subtitle: Text(description),
    );
  }
} 
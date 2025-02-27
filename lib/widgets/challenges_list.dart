import 'package:flutter/material.dart';

class ChallengesList extends StatelessWidget {
  const ChallengesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildChallengeItem(
          'Summer Fitness Challenge',
          '30 days left',
          '250/500 participants',
        ),
        _buildChallengeItem(
          '10K Steps Daily',
          '15 days left',
          '120/200 participants',
        ),
        _buildChallengeItem(
          'Weight Loss Challenge',
          '45 days left',
          '180/300 participants',
        ),
      ],
    );
  }

  Widget _buildChallengeItem(String title, String timeLeft, String participants) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(timeLeft),
        trailing: Text(participants),
        leading: const Icon(Icons.emoji_events),
      ),
    );
  }
} 
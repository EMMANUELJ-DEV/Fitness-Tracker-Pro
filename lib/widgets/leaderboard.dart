import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildLeaderboardItem('John Doe', '1st', '2,500 pts'),
        _buildLeaderboardItem('Jane Smith', '2nd', '2,300 pts'),
        _buildLeaderboardItem('Mike Johnson', '3rd', '2,100 pts'),
        _buildLeaderboardItem('Sarah Wilson', '4th', '1,900 pts'),
      ],
    );
  }

  Widget _buildLeaderboardItem(String name, String rank, String points) {
    return ListTile(
      leading: CircleAvatar(child: Text(rank)),
      title: Text(name),
      trailing: Text(points),
    );
  }
} 
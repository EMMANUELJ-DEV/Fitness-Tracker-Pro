import 'package:flutter/material.dart';

class ProgressCharts extends StatelessWidget {
  const ProgressCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              alignment: Alignment.center,
              child: const Text('Progress Charts Coming Soon'),
            ),
          ],
        ),
      ),
    );
  }
} 
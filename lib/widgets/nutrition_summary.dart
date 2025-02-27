import 'package:flutter/material.dart';
import '../models/meal.dart';

class NutritionSummary extends StatelessWidget {
  final List<Meal> meals;
  
  const NutritionSummary({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    int totalCalories = meals.fold(0, (sum, meal) => sum + meal.calories);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Nutrition',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientInfo('Calories', '$totalCalories/2,000'),
                _buildNutrientInfo('Protein', '60g/120g'),
                _buildNutrientInfo('Carbs', '150g/250g'),
                _buildNutrientInfo('Fat', '40g/65g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
} 
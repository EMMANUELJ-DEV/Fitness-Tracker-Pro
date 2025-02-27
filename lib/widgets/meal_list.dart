import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealList extends StatelessWidget {
  final List<Meal> meals;
  
  const MealList({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const Center(child: Text('No meals added yet'));
    }

    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return ListTile(
          title: Text(meal.name),
          subtitle: Text(meal.type),
          trailing: Text('${meal.calories} kcal'),
          leading: const Icon(Icons.restaurant),
        );
      },
    );
  }
} 
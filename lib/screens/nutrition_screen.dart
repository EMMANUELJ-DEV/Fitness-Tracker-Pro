import 'package:flutter/material.dart';
import '../widgets/nutrition_summary.dart';
import '../widgets/meal_list.dart';
import '../models/meal.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final List<Meal> _meals = [];
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  String _selectedMealType = 'breakfast';

  void _addMeal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Add Meal',
          style: TextStyle(color: Colors.deepPurple),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Meal Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedMealType,
              items: ['breakfast', 'lunch', 'dinner', 'snack']
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMealType = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _meals.add(
                  Meal(
                    id: DateTime.now().toString(),
                    name: _nameController.text,
                    calories: int.parse(_caloriesController.text),
                    time: DateTime.now(),
                    type: _selectedMealType,
                  ),
                );
              });
              _nameController.clear();
              _caloriesController.clear();
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracking'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            NutritionSummary(meals: _meals),
            Expanded(child: MealList(meals: _meals)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeal,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }
}

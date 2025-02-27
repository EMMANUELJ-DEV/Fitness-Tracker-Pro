import 'package:flutter/foundation.dart';
import '../models/meal.dart';

class NutritionProvider with ChangeNotifier {
  List<Meal> _meals = [];
  List<Meal> get meals => [..._meals];

  double _targetCalories = 2000;
  double get targetCalories => _targetCalories;

  void addMeal(Meal meal) {
    _meals.add(meal);
    notifyListeners();
  }

  void deleteMeal(String id) {
    _meals.removeWhere((meal) => meal.id == id);
    notifyListeners();
  }

  void setTargetCalories(double calories) {
    _targetCalories = calories;
    notifyListeners();
  }

  int getTotalCaloriesForDate(DateTime date) {
    return _meals
        .where((meal) => 
          meal.time.year == date.year && 
          meal.time.month == date.month &&
          meal.time.day == date.day)
        .fold(0, (sum, meal) => sum + meal.calories);
  }

  List<Meal> getMealsForDate(DateTime date) {
    return _meals.where((meal) => 
      meal.time.year == date.year && 
      meal.time.month == date.month &&
      meal.time.day == date.day
    ).toList();
  }
} 
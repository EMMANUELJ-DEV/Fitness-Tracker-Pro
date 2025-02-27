import 'package:flutter/foundation.dart';
import '../models/workout.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Workout> get workouts => [..._workouts];

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }

  void deleteWorkout(String id) {
    _workouts.removeWhere((workout) => workout.id == id);
    notifyListeners();
  }

  void updateWorkout(Workout workout) {
    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index >= 0) {
      _workouts[index] = workout;
      notifyListeners();
    }
  }

  List<Workout> getWorkoutsForDate(DateTime date) {
    return _workouts.where((workout) => 
      workout.date.year == date.year && 
      workout.date.month == date.month &&
      workout.date.day == date.day
    ).toList();
  }
} 
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  double _weight = 70;
  double _height = 170;
  int _age = 25;
  String _goal = 'maintenance';
  List<double> _weightHistory = [70];
  double _targetWeight = 65;
  int _weeklyWorkoutGoal = 5;
  int _weeklyWorkouts = 0;

  String get name => _name;
  double get weight => _weight;
  double get height => _height;
  int get age => _age;
  String get goal => _goal;
  List<double> get weightHistory => [..._weightHistory];
  double get targetWeight => _targetWeight;
  int get weeklyWorkoutGoal => _weeklyWorkoutGoal;
  int get weeklyWorkouts => _weeklyWorkouts;

  void updateProfile({
    String? name,
    double? weight,
    double? height,
    int? age,
    String? goal,
  }) {
    if (name != null) _name = name;
    if (weight != null) {
      _weight = weight;
      _weightHistory.add(weight);
    }
    if (height != null) _height = height;
    if (age != null) _age = age;
    if (goal != null) _goal = goal;
    notifyListeners();
  }

  double getBMI() {
    if (_height <= 0) return 0;
    return _weight / ((_height / 100) * (_height / 100));
  }

  void setTargetWeight(double weight) {
    _targetWeight = weight;
    notifyListeners();
  }

  void setWeeklyWorkoutGoal(int goal) {
    _weeklyWorkoutGoal = goal;
    notifyListeners();
  }

  void incrementWeeklyWorkouts() {
    _weeklyWorkouts++;
    notifyListeners();
  }
} 
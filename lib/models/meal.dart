class Meal {
  final String id;
  final String name;
  final int calories;
  final DateTime time;
  final String type; // breakfast, lunch, dinner, snack

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.time,
    required this.type,
  });
} 
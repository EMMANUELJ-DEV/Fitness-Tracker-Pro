import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/achievement_card.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress & Goals'),
        backgroundColor: primaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Stats'),
            Tab(text: 'Goals'),
            Tab(text: 'Achievements'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.05), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: const [
            StatsTab(),
            GoalsTab(),
            AchievementsTab(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class StatsTab extends StatelessWidget {
  const StatsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final weightHistory = userProvider.weightHistory;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Weight Progress',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      icon:
                          const Icon(Icons.add, color: Colors.deepOrange),
                      label: const Text('Log Weight',
                          style: TextStyle(color: Colors.deepOrange)),
                      onPressed: () => _showWeightDialog(context, userProvider),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: weightHistory.isEmpty
                      ? const Center(
                          child: Text('Add weight measurements to see progress'),
                        )
                      : LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 5,
                              verticalInterval: 1,
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 10,
                                  reservedSize: 40,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < weightHistory.length) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(value.toInt().toString()),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles:
                                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles:
                                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: true),
                            minX: 0,
                            maxX: (weightHistory.length - 1).toDouble(),
                            minY: (weightHistory.reduce((a, b) => a < b ? a : b) - 5),
                            maxY: (weightHistory.reduce((a, b) => a > b ? a : b) + 5),
                            lineBarsData: [
                              LineChartBarData(
                                spots: weightHistory
                                    .asMap()
                                    .entries
                                    .map((e) => FlSpot(
                                        e.key.toDouble(), e.value))
                                    .toList(),
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          'Current BMI',
          userProvider.getBMI().toStringAsFixed(1),
          _getBMICategory(userProvider.getBMI()),
          context,
        ),
        const SizedBox(height: 16),
        _buildWorkoutStats(context),
      ],
    );
  }

  void _showWeightDialog(BuildContext context, UserProvider userProvider) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Weight'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Weight (kg)',
            hintText: 'Enter your current weight',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final weight = double.tryParse(controller.text);
              if (weight != null) {
                userProvider.updateProfile(weight: weight);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String subtitle, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Widget _buildWorkoutStats(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workouts = workoutProvider.workouts;
    final totalWorkouts = workouts.length;
    final thisWeekWorkouts = workouts
        .where((w) =>
            w.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .length;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Workout Statistics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWorkoutStat('Total\nWorkouts', totalWorkouts.toString()),
                _buildWorkoutStat('This Week', thisWeekWorkouts.toString()),
                _buildWorkoutStat('Streak',
                    _calculateStreak(workouts).toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  int _calculateStreak(List<dynamic> workouts) {
    if (workouts.isEmpty) return 0;
    int streak = 0;
    DateTime currentDate = DateTime.now();
    Set<String> workoutDates = workouts
        .map((w) => DateFormat('yyyy-MM-dd').format(w.date))
        .toSet();
    while (workoutDates
        .contains(DateFormat('yyyy-MM-dd').format(currentDate))) {
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

class GoalsTab extends StatelessWidget {
  const GoalsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGoalCard(
          'Weight Goal',
          userProvider.weight.toString(),
          userProvider.targetWeight.toString(),
          (userProvider.weight / userProvider.targetWeight * 100).clamp(0, 100),
          onEdit: () => _showWeightGoalDialog(context, userProvider),
        ),
        const SizedBox(height: 16),
        _buildGoalCard(
          'Weekly Workouts',
          '${userProvider.weeklyWorkouts}',
          '${userProvider.weeklyWorkoutGoal}',
          (userProvider.weeklyWorkouts / userProvider.weeklyWorkoutGoal * 100)
              .clamp(0, 100),
          onEdit: () => _showWorkoutGoalDialog(context, userProvider),
        ),
      ],
    );
  }

  Widget _buildGoalCard(String title, String current, String target,
      double progress,
      {required VoidCallback onEdit}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.deepOrange),
                  onPressed: onEdit,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress / 100,
              color: Colors.green,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current: $current'),
                Text('Target: $target'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWeightGoalDialog(BuildContext context, UserProvider userProvider) {
    final controller =
        TextEditingController(text: userProvider.targetWeight.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Weight Goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: 'Target Weight (kg)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                final target = double.tryParse(controller.text);
                if (target != null) {
                  userProvider.setTargetWeight(target);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

  void _showWorkoutGoalDialog(
      BuildContext context, UserProvider userProvider) {
    final controller =
        TextEditingController(text: userProvider.weeklyWorkoutGoal.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Weekly Workout Goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: 'Workouts per Week'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                final target = int.tryParse(controller.text);
                if (target != null) {
                  userProvider.setWeeklyWorkoutGoal(target);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save')),
        ],
      ),
    );
  }
}

class AchievementsTab extends StatelessWidget {
  const AchievementsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        AchievementCard(
          title: 'Early Bird',
          description: 'Complete 5 morning workouts',
          icon: Icons.wb_sunny,
          progress: 3,
          total: 5,
          color: Colors.orange,
        ),
        AchievementCard(
          title: 'Strength Master',
          description: 'Complete 10 strength workouts',
          icon: Icons.fitness_center,
          progress: 7,
          total: 10,
          color: Colors.blue,
        ),
        AchievementCard(
          title: 'Consistency King',
          description: 'Workout 7 days in a row',
          icon: Icons.calendar_today,
          progress: 5,
          total: 7,
          color: Colors.green,
        ),
        AchievementCard(
          title: 'Weight Goal',
          description: 'Reach your target weight',
          icon: Icons.track_changes,
          progress: 80,
          total: 100,
          color: Colors.purple,
        ),
      ],
    );
  }
}

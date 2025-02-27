import 'package:flutter/material.dart';
import '../widgets/social_feed_item.dart';
import '../widgets/challenge_card.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _showFindFriendsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Find Friends'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Search by name or email',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(child: Text('JD')),
              title: const Text('John Doe'),
              subtitle: const Text('3 mutual friends'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Add'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'What\'s on your mind?',
                hintText: 'Share your fitness journey...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo, color: Colors.pink),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions, color: Colors.amber),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post shared successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text('Share'),
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
        title: const Text('Social & Challenges'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showFindFriendsDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Feed'),
            Tab(text: 'Leaderboard'),
            Tab(text: 'Challenges'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: const [
            FeedTab(),
            LeaderboardTab(),
            ChallengesTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _showCreatePostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class FeedTab extends StatelessWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SocialFeedItem(
          username: 'Sarah',
          content: 'Just completed a 5K run! 🏃‍♀️ Personal best time!',
          likes: 24,
          comments: 5,
          timeAgo: '2h ago',
          hasImage: true,
        ),
        SocialFeedItem(
          username: 'Mike',
          content: 'Hit a new PR on bench press today! 💪',
          likes: 15,
          comments: 3,
          timeAgo: '4h ago',
          hasImage: false,
        ),
        SocialFeedItem(
          username: 'Emma',
          content: 'Morning yoga session completed ✨ Starting the day right!',
          likes: 32,
          comments: 7,
          timeAgo: '6h ago',
          hasImage: true,
        ),
      ],
    );
  }
}

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'This Week\'s Leaders',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: 'Workouts',
                items: ['Workouts', 'Steps', 'Weight Loss']
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      index < 3 ? Colors.amber : Colors.grey[300],
                  child: Text('${index + 1}'),
                ),
                title: Text('User ${index + 1}'),
                subtitle: Text('${20 - index} workouts this week'),
                trailing: Text('+${(10 - index) * 100} points'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChallengesTab extends StatelessWidget {
  const ChallengesTab({Key? key}) : super(key: key);

  void _joinChallenge(BuildContext context, String challengeName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Join $challengeName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you ready to take on this challenge?'),
            const SizedBox(height: 16),
            const Text(
              '⚠️ Make sure to track your progress daily!',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You\'ve joined $challengeName!'),
                  action: SnackBarAction(
                    label: 'View Details',
                    onPressed: () {},
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text('Join Challenge'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ChallengeCard(
          title: '30 Days of Fitness',
          description: 'Complete a workout every day for 30 days',
          progress: 0.6,
          daysLeft: 12,
          participants: 156,
          reward: '500 points',
          onJoin: () => _joinChallenge(context, '30 Days of Fitness'),
        ),
        ChallengeCard(
          title: '10K Steps Daily',
          description: 'Walk 10,000 steps every day for a week',
          progress: 0.3,
          daysLeft: 5,
          participants: 89,
          reward: '200 points',
          onJoin: () => _joinChallenge(context, '10K Steps Daily'),
        ),
        ChallengeCard(
          title: 'Weight Loss Challenge',
          description: 'Lose 5kg in 2 months safely',
          progress: 0.2,
          daysLeft: 45,
          participants: 234,
          reward: '1000 points',
          onJoin: () => _joinChallenge(context, 'Weight Loss Challenge'),
        ),
      ],
    );
  }
}

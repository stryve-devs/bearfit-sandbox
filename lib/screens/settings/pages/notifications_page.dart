import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // GENERAL
  bool restTimer = true;
  bool follows = false;
  bool monthlyReport = true;
  bool subscribeEmails = false;

  // LIKES
  bool likesWorkouts = true;
  bool likesComments = false;

  // COMMENTS
  bool commentsWorkouts = true;
  bool commentReplies = true;
  bool commentMentions = false;
  bool workoutDiscussions = true;

  static const Color accent = Color(0xFFFF7A00);
  static const Color card = Color(0xFF2A2A2A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Push Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          _sectionHeader('General'),
          _tile('Rest Timer', value: restTimer, onChanged: (v) => setState(() => restTimer = v)),
          _tile('Follows', value: follows, onChanged: (v) => setState(() => follows = v)),
          _tile(
            'Monthly Report',
            subtitle: 'Get a notification when your monthly report is ready',
            value: monthlyReport,
            onChanged: (v) => setState(() => monthlyReport = v),
          ),
          _tile(
            'Subscribe to Stryve emails',
            subtitle: 'Tips, new feature announcements, offers and more',
            value: subscribeEmails,
            onChanged: (v) => setState(() => subscribeEmails = v),
          ),

          _sectionHeader('Likes'),
          _tile('Likes on your workouts', value: likesWorkouts, onChanged: (v) => setState(() => likesWorkouts = v)),
          _tile('Likes on your comments', value: likesComments, onChanged: (v) => setState(() => likesComments = v)),

          _sectionHeader('Comments'),
          _tile(
            'Comments on your workouts',
            subtitle: 'Get a notification when someone replies to your comments',
            value: commentsWorkouts,
            onChanged: (v) => setState(() => commentsWorkouts = v),
          ),
          _tile(
            'Comment Replies',
            subtitle: 'Get a notification when someone replies to your comments',
            value: commentReplies,
            onChanged: (v) => setState(() => commentReplies = v),
          ),
          _tile(
            'Comment Mentions',
            subtitle: 'Get notifications when someone @ mentions you in comment',
            value: commentMentions,
            onChanged: (v) => setState(() => commentMentions = v),
          ),
          _tile(
            'Workout Discussions',
            subtitle:
                'Get notifications when someone comments on a workout that you\'ve also commented on',
            value: workoutDiscussions,
            onChanged: (v) => setState(() => workoutDiscussions = v),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // SECTION HEADER
  Widget _sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: accent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // TILE WITH CIRCULAR SWITCH
  Widget _tile(
    String title, {
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: _circleSwitch(value),
          ),
        ],
      ),
    );
  }

  // CUSTOM CIRCLE SWITCH
  Widget _circleSwitch(bool active) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: active ? accent : Colors.white54,
          width: 2,
        ),
      ),
      child: active
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

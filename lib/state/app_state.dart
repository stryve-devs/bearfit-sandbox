import 'package:flutter/material.dart';
import '../data/models.dart';

class AppState extends ChangeNotifier {
  final List<Athlete> athletes;
  final List<Post> posts;
  final List<NotifItem> notifications;
  final List<ContactItem> contacts;

  AppState({
    required this.athletes,
    required this.posts,
    required this.notifications,
    required this.contacts,
  });

  final Set<String> followedAthletes = {};
  final Set<String> likedPosts = {};

  // ✅ ADD THIS METHOD
  bool isFollowing(String athleteId) {
    return followedAthletes.contains(athleteId);
  }

  void toggleFollow(String athleteId) {
    if (followedAthletes.contains(athleteId)) {
      followedAthletes.remove(athleteId);
    } else {
      followedAthletes.add(athleteId);
    }
    notifyListeners();
  }

  void toggleLike(String postId) {
    if (likedPosts.contains(postId)) {
      likedPosts.remove(postId);
    } else {
      likedPosts.add(postId);
    }
    notifyListeners();
  }
}

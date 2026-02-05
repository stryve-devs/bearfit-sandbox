import 'package:flutter/material.dart';
import 'package:flutter_frontend/state/app_state.dart';
import '../../data/models/post.dart';
import 'home4_post_detail.dart';

class Home19WorkoutDetail extends StatelessWidget {
  final AppState appState;
  final Post post;

  const Home19WorkoutDetail({
    super.key,
    required this.appState,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Home4PostDetail(appState: appState, post: post);
  }
}

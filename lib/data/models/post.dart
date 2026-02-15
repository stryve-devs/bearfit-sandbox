import 'athlete.dart';

class Post {
  final String id;
  final Athlete athlete;
  final String caption;
  final String imageUrl;
  final List<String> comments;

  const Post({
    required this.id,
    required this.athlete,
    required this.caption,
    required this.imageUrl,
    required this.comments, required List<String> exercises,
  });
}

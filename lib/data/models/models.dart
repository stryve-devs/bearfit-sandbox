/*class Athlete {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;

  const Athlete({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
  });
}

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
    required this.comments,
  });
}

class NotifItem {
  final String title;
  final String subtitle;

  const NotifItem(this.title, this.subtitle);
}

class ContactItem {
  final String name;
  final String phone;

 const ContactItem(this.name, this.phone);
}
*/
// lib/data/models.dart
export 'athlete.dart';
export 'post.dart';
export 'notif_item.dart';
export 'contact_item.dart';
export 'user.dart';

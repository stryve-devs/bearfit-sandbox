class Athlete {
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

  String get handle => '@$username';
}

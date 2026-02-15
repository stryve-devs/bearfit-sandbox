import 'package:flutter_frontend/data/models/athlete.dart';

import '../models/post.dart';

// Example mock data. Replace with your own mock posts.
final List<Post> posts = [
  Post(
    id: '1',
    caption: 'Great workout today!',
    imageUrl: 'https://example.com/image1.jpg',
    athlete: Athlete(
      name: 'John Doe',
      username: 'johndoe',
      avatarUrl: 'https://example.com/avatar1.jpg', id: '',
    ),
    comments: ['Nice!', 'Keep it up!'], exercises: [],
  ),
  // Add more Post objects as needed
];
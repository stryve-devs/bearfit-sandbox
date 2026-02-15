import 'models.dart';

final mockAthletes = <Athlete>[
  Athlete(
    id: 'a1',
    name: 'Alex Rivera',
    username: 'alexr',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  ),
  Athlete(
    id: 'a2',
    name: 'Morgan Lee',
    username: 'morganl',
    avatarUrl: 'https://i.pravatar.cc/150?img=32',
  ),
];

final mockPosts = <Post>[
  Post(
    id: 'p1',
    athlete: mockAthletes[0],
    caption: 'Morning run with intervals. Felt great!',
    imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211',
    comments: ['Nice!', 'Great pace!'], exercises: [],
  ),
  Post(
    id: 'p2',
    athlete: mockAthletes[1],
    caption: 'Strength day done. New PR on squats.',
    imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438',
    comments: ['🔥', 'Congrats!'], exercises: [],
  ),
];

final mockNotifications = <NotifItem>[
  NotifItem('New follower', 'Morgan Lee started following you.'),
  NotifItem('Workout liked', 'Alex Rivera liked your post.'),
];

final mockContacts = <ContactItem>[
  ContactItem('Alex Rivera', '+1 555 0100'),
  ContactItem('Morgan Lee', '+1 555 0120'),
];

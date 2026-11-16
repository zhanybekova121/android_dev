import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';

final List<PostModel> mockPosts = [
  PostModel(
    imageUrl: 'https://picsum.photos/id/10/600/600',
    description: 'Morning walk in the forest 🌲',
    likeCount: 12,
    comments: [
      CommentModel(username: 'aida', text: 'So beautiful!'),
      CommentModel(username: 'timur', text: 'Where is this?'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/20/600/600',
    description: 'My new workspace setup',
    likeCount: 34,
    comments: [
      CommentModel(username: 'dana', text: 'Clean desk 🔥'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/30/600/600',
    description: 'Coffee before lab work ☕',
    likeCount: 7,
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/40/600/600',
    description: 'Meet my cat, he runs this house',
    likeCount: 58,
    comments: [
      CommentModel(username: 'aruzhan', text: 'Such a cutie 😍'),
      CommentModel(username: 'bek', text: 'He looks like a boss'),
      CommentModel(username: 'mira', text: 'What is his name?'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/50/600/600',
    description: 'Sunset by the lake',
    likeCount: 21,
    comments: [
      CommentModel(username: 'nurlan', text: 'Amazing colors'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/60/600/600',
    description: 'Finally finished my Flutter project 🎉',
    likeCount: 45,
    comments: [
      CommentModel(username: 'alimhan', text: 'Great job!'),
      CommentModel(username: 'kamila', text: 'Share the repo pls'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/70/600/600',
    description: 'Road trip through the mountains',
    likeCount: 30,
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/80/600/600',
    description: 'Homemade pizza night 🍕',
    likeCount: 19,
    comments: [
      CommentModel(username: 'erlan', text: 'Invite me next time'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/90/600/600',
    description: 'Exploring the old town',
    likeCount: 11,
    comments: [
      CommentModel(username: 'zarina', text: 'Love these streets'),
      CommentModel(username: 'askar', text: 'Been there last summer!'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/100/600/600',
    description: 'Beach day with friends 🏖️',
    likeCount: 67,
    comments: [
      CommentModel(username: 'sultan', text: 'Miss summer already'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/110/600/600',
    description: 'New book, new mood 📚',
    likeCount: 9,
    comments: [
      CommentModel(username: 'aidana', text: 'Which book is it?'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/120/600/600',
    description: 'Rainy day in the city',
    likeCount: 15,
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/130/600/600',
    description: 'Gym progress, day 100 💪',
    likeCount: 88,
    comments: [
      CommentModel(username: 'daniyar', text: 'Beast mode'),
      CommentModel(username: 'asel', text: 'Motivation!'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/140/600/600',
    description: 'Late night coding session',
    likeCount: 26,
    comments: [
      CommentModel(username: 'ilyas', text: 'Bugs never sleep 😅'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/150/600/600',
    description: 'Fresh flowers from the market 🌷',
    likeCount: 40,
    comments: [
      CommentModel(username: 'madina', text: 'So pretty'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/160/600/600',
    description: 'First snow of the year ❄️',
    likeCount: 52,
    comments: [
      CommentModel(username: 'ruslan', text: 'Winter is here'),
      CommentModel(username: 'saule', text: 'Time for hot chocolate'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/170/600/600',
    description: 'Concert last night was unreal 🎶',
    likeCount: 73,
    comments: [
      CommentModel(username: 'arman', text: 'I was there too!'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/180/600/600',
    description: 'Trying film photography',
    likeCount: 18,
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/190/600/600',
    description: 'Weekend hike done ✅',
    likeCount: 33,
    comments: [
      CommentModel(username: 'gulnaz', text: 'How long was the trail?'),
    ],
  ),
  PostModel(
    imageUrl: 'https://picsum.photos/id/200/600/600',
    description: 'Graduation day! 🎓',
    likeCount: 120,
    comments: [
      CommentModel(username: 'mom', text: 'So proud of you ❤️'),
      CommentModel(username: 'yerlan', text: 'Congrats!!'),
      CommentModel(username: 'tomiris', text: 'Well deserved'),
    ],
  ),
];

final List<StoryModel> mockStories = List.generate(
  10,
  (i) => StoryModel(
    username: 'user_$i',
    avatarUrl: 'https://i.pravatar.cc/150?img=${i + 1}',
  ),
);

import 'package:android_dev/screens/home_screen/data/mock_posts.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';

class PostServices {
  const PostServices();

  List<PostModel> fetchPosts() => List.of(mockPosts);

  List<StoryModel> fetchStories() => List.of(mockStories);
}

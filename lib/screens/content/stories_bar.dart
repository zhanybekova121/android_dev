import 'package:android_dev/screens/content/story_widget.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:material_ui/material_ui.dart';

class StoriesBar extends StatelessWidget {
  final List<StoryModel> stories;
  const StoriesBar({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) => StoryWidget(story: stories[index]),
      ),
    );
  }
}

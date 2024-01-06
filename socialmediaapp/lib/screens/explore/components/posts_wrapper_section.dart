import 'package:flutter/material.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/screens/post/components/post_card_wrapper.dart';


class PostsWrapperSection extends StatelessWidget {
  final List<PostFilter> posts;
  final String? title;
  final Function(int postId) onTap;

  const PostsWrapperSection({
    Key? key,
    required this.posts,
    this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        SizedBox(
          child: Wrap (
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(
              posts.length, 
              (index) {
                final post = posts[index];
                return PostCardWrapper(
                  post: post,
                  onTap: () => onTap(post.postId),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
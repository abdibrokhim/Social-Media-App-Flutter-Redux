import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/shared/build_cached_image.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';


class PostCardWrapper extends StatelessWidget {
  final PostFilter post;
  final Function()? onTap;

const PostCardWrapper({
    Key? key,
    required this.post,
    required this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      margin: const EdgeInsets.all(4), // Add some margin for spacing
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildCachedImagePlaceHolder(
              post.image,
              context,
            ),
            Expanded(
              flex: 2,
              child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
            ),
            ),
            Expanded(
              child:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                post.categories!.map((c) => c.name).join(', '),
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

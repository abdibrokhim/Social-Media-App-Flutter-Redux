import 'package:flutter/material.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/utils/constants.dart';


class UserBubbleCard extends StatelessWidget {
  final PostLikedUser user;
  final VoidCallback onTap;

  const UserBubbleCard({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage(user.profileImage ?? defaultProfileImage)),
      title: Text(user.username),
      onTap: onTap
    );
  }
}

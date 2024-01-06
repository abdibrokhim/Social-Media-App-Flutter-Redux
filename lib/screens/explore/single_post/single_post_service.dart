import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/shared/get_access_token.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';


class SinglePostService {

  static Future<Post> getPostById(int pId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final Post post = Post.fromJson(data);
        return post;
      } else {
        return Future.error('Failed to get post. Post id: $pId');
      }
    } catch (e) {
      AppLog.log().e("error while fetching post. Post id: $pId. Exception: $e");
      return Future.error('Failed to get post. Post id: $pId');
    }
  }

  static Future<List<PostLikedUser>> getPostLikedUserList(int pId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId/liked-users'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> usersJson = data['users'] as List<dynamic>;
        final List<PostLikedUser> users = usersJson
          .map((e) => PostLikedUser.fromJson(e as Map<String, dynamic>))
          .toList();
        return users;
      } else {
        return Future.error('Failed to get post liked users.');
      }
    } catch (e) {
      AppLog.log().e("error while fetching post liked users: $e");
      return Future.error('Failed to get post liked users.');
    }
  }

  static Future<int> getPostLikes(int pId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId/likes'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final int likes = data['likes'] as int;
        return likes;
      } else {
        return Future.error('Failed to get post likes.');
      }
    } catch (e) {
      AppLog.log().e("error while fetching post likes count: $e");
      return Future.error('Failed to get post likes.');
    }
  }

  static Future<PostLikedUser> getPostOwner(int pId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId/owner'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final dynamic userJson = data['owner'] as dynamic;
        final PostLikedUser user = PostLikedUser.fromJson(userJson as Map<String, dynamic>);
        return user;
      } else {
        return Future.error('Failed to get post owner.');
      }
    } catch (e) {
      AppLog.log().e("error while fetching post owner: $e");
      return Future.error('Failed to get post owner.');
    }
  }

  static Future<Map<String, dynamic>> likePost(int pId) async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId/like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final int likes = data['likes'] as int;
        final List<PostLikedUser> users = (data['likedUsers'] as List<dynamic>)
          .map((e) => PostLikedUser.fromJson(e as Map<String, dynamic>))
          .toList();
        AppLog.log().i("postId: $pId is likes: $likes users: $users");
        // showToast(message: 'You liked this post.', bgColor: Colors.green);
        return {
          'likes': likes,
          'likedUsers': users,
        };
      } else {
        return Future.error('Failed to like post.');
      }
    } catch (e) {
      AppLog.log().e("error while liking post: $e");
      return Future.error('Failed to like post.');
    }
  }

  static Future<Map<String, dynamic>> unlikePost(int pId) async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId/unlike'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final int likes = data['likes'] as int;
        final List<PostLikedUser> users = (data['likedUsers'] as List<dynamic>)
          .map((e) => PostLikedUser.fromJson(e as Map<String, dynamic>))
          .toList();
        AppLog.log().i("postId: $pId is likes: $likes users: $users");
        return {
          'likes': likes,
          'likedUsers': users,
        };
      } else {
        return Future.error('Failed to unlike post.');
      }
    } catch (e) {
      AppLog.log().e("error while unliking post: $e");
      return Future.error('Failed to unlike post.');
    }
  }

  static Future<bool> isPostLiked(int pId) async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId/is-liked'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final bool isLiked = data['isLiked'] as bool;
        print("postId: $pId is liked: $isLiked");
        AppLog.log().i("postId: $pId is liked: $isLiked");
        return isLiked;
      } else {
        return Future.error('Failed to fetch is-liked.');
      }
    } catch (e) {
      AppLog.log().e("error while fetching is-liked response: $e");
      return Future.error('Failed to fetch is-liked.');
    }
  }
}
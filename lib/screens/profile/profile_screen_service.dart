import 'package:socialmediaapp/components/shared/get_access_token.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';


class ProfileScreenService {

  static Future<List<PostLikedUser>> getFollowersList(int uId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/followers'),
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
        return Future.error('Failed to get followers.');
      }
    } catch (e) {
      AppLog.log().e("error while fetching followers: $e");
      return Future.error('Failed to get followers.');
    }
  }

  static Future<List<PostLikedUser>> getFollowingsList(int uId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/followings'),
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
        return Future.error('Failed to get followings.');
      }
    } catch (e) {
      AppLog.log().e("error while fetching followings: $e");
      return Future.error('Failed to get followings.');
    }
  }

  static Future<Map<String, dynamic>> followUser(int uId) async {
    try {
      String accessToken = await getAccessToken();
      print('sending request to follow user with id: $uId with accessToken: $accessToken');
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/follow'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final int followersCount = data['followers_count'] as int;
        final List<PostLikedUser> followersList = (data['followers_list'] as List<dynamic>)
          .map((e) => PostLikedUser.fromJson(e as Map<String, dynamic>))
          .toList();
        AppLog.log().i("useId: $uId is followers_count: $followersCount followers_list: $followersList");
        return {
          'followers_count': followersCount,
          'followers_list': followersList,
        };
      } else {
        return Future.error('Failed to follow user.');
      }
    } catch (e) {
      AppLog.log().e("error while following user: $e");
      return Future.error('Failed to follow user.');
    }
  }

  static Future<Map<String, dynamic>> unfollowUser(int uId) async {
    try {
      String accessToken = await getAccessToken();
      print('sending request to unfollow user with id: $uId with accessToken: $accessToken');
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/unfollow'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final int followersCount = data['followers_count'] as int;
        final List<PostLikedUser> followersList = (data['followers_list'] as List<dynamic>)
          .map((e) => PostLikedUser.fromJson(e as Map<String, dynamic>))
          .toList();
        AppLog.log().i("useId: $uId is followers_count: $followersCount followers_list: $followersList");
        return {
          'followers_count': followersCount,
          'followers_list': followersList,
        };
      } else {
        return Future.error('Failed to unfollow user.');
      }
    } catch (e) {
      AppLog.log().e("error while unfollowing user: $e");
      return Future.error('Failed to unfollow user.');
    }
  }

  
}
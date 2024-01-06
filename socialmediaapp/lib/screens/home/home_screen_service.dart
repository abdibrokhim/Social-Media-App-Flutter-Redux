import 'package:socialmediaapp/components/shared/get_access_token.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';

class HomeScreenService {

  static Future<List<PostFilter>> getMadeForYouPostList(int limit, int offset) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/made-for-you?limit=$limit&offset=$offset'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<PostFilter> posts = data.map((e) => PostFilter.fromJson(e)).toList();
        return posts;
      } else {
        return Future.error('Failed to get made-for-you posts');
      }
    } catch (e) {
      AppLog.log().e("error while fetching made-for-you posts: $e");
      return Future.error('Failed to get made-for-you posts');
    }
  }

  static Future<List<PostFilter>> getViralList(int limit, int offset) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/viral?limit=$limit&offset=$offset'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<PostFilter> posts = data.map((e) => PostFilter.fromJson(e)).toList();
        print('viral posts: $posts');
        return posts;
      } else {
        return Future.error('Failed to get viral posts');
      }
    } catch (e) {
      AppLog.log().e("error while fetching viral posts: $e");
      return Future.error('Failed to get viral posts');
    }
  }
}
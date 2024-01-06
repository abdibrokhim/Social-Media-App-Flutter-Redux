import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';


class ExploreScreenService {

  static Future<List<PostFilter>> getExplorePostList(int trendingLimit, int newLimit, int diverseLimit) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/explore?trending=$trendingLimit&new=$newLimit&diverse=$diverseLimit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<PostFilter> posts = data.map((e) => PostFilter.fromJson(e)).toList();
        return posts;
      } else {
        return Future.error('Failed to get explore posts');
      }
    } catch (e) {
      AppLog.log().e("error while fetching explore posts: $e");
      return Future.error('Failed to get explore posts');
    }
  }

  static Future<List<PostFilter>> getMadeForYouPostList(int limit, int offset) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/made-for-you?limit=$limit&offset=$offset'),
        headers: {
          'Content-Type': 'application/json',
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

  static Future<List<PostFilter>> getTrendingPostList(int limit) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/explore/trending?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<PostFilter> posts = data.map((e) => PostFilter.fromJson(e)).toList();
        return posts;
      } else {
        return Future.error('Failed to get trending posts');
      }
    } catch (e) {
      AppLog.log().e("error while fetching trending posts: $e");
      return Future.error('Failed to get trending posts');
    }
  }

  static Future<List<PostFilter>> getNewPostList(int limit) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/explore/new?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<PostFilter> posts = data.map((e) => PostFilter.fromJson(e)).toList();
        return posts;
      } else {
        return Future.error('Failed to get new posts');
      }
    } catch (e) {
      AppLog.log().e("error while fetching new posts: $e");
      return Future.error('Failed to get new posts');
    }
  }

  static Future<List<PostFilter>> getDiversePostList(int limit) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/explore/diverse?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<PostFilter> posts = data.map((e) => PostFilter.fromJson(e)).toList();
        return posts;
      } else {
        return Future.error('Failed to get diverse posts');
      }
    } catch (e) {
      AppLog.log().e("error while fetching diverse posts: $e");
      return Future.error('Failed to get diverse posts');
    }
  }
}
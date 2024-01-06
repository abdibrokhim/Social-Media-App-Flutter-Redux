import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';


class PostFiltersService {

  static Future<List<PostFilter>> filterPosts(String filterText) async {
    try {
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/filter/posts'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'query': filterText,
        }),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> postsJson = data['posts'] as List<dynamic>;
        final List<PostFilter> posts = postsJson
          .map((e) => PostFilter.fromJson(e as Map<String, dynamic>))
          .toList();
        return posts;
      } else {
        return Future.error('Failed to get filtered posts.');
      }
    } catch (e) {
      AppLog.log().e("error while creating post: $e");
      return Future.error('Failed to create post.');
    }
  }

  static Future<List<PostAutocomplete>> autoCompletePosts(String filterText) async {
    try {
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/autocomplete/posts'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'query': filterText,
        }),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> postsJson = data['posts'] as List<dynamic>;
        final List<PostAutocomplete> posts = postsJson
          .map((e) => PostAutocomplete.fromJson(e as Map<String, dynamic>))
          .toList();
        return posts;
      } else {
        return Future.error('Failed to get filtered posts.');
      }
    } catch (e) {
      AppLog.log().e("error while creating post: $e");
      return Future.error('Failed to create post.');
    }
  }
}
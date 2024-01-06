import 'package:socialmediaapp/components/shared/get_access_token.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';


class PostService {
  static Future<int> createPost(CreatePost post) async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(post.toJson()),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final int postId = data['new_post_id'] as int;
        AppLog.log().i('new post created with id: $postId');
        return postId;
      } else {
        return Future.error('Failed to create post.');
      }
    } catch (e) {
      AppLog.log().e("error while creating post: $e");
      return Future.error('Failed to create post.');
    }
  }

  static Future<Post> updatePost(int pId, UpdatePost updatedPost) async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.patch(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(updatedPost.toJson()),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final Post post = Post.fromJson(data);
        return post;
      } else {
        return Future.error('Failed to update post.');
      }
    } catch (e) {
      AppLog.log().e("error while updating post: $e");
      return Future.error('Failed to update post.');
    }
  }

  static Future<void> deletePost(int pId) async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.delete(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/posts/$pId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print(data);
      } else {
        return Future.error('Failed to delete post.');
      }
    } catch (e) {
      AppLog.log().e("error while deleting post: $e");
      return Future.error('Failed to delete post.');
    }
  }

  static Future<PostAIGeneration> gptVisionPost(String imageUrl) async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/detection/gpt4'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'image_url': imageUrl}),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final PostAIGeneration postInfo = PostAIGeneration.fromJson(data);
        return postInfo;
      } else {
        return Future.error('Failed to generate post title and description.');
      }
    } catch (e) {
      AppLog.log().e("error while generating post title and description: $e");
      return Future.error('Failed to generate post title and description.');
    }
  }

  static Future<PostAIGeneration> geminiVisionPost(String imageUrl) async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/detection/gemini'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'image_url': imageUrl}),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print('Generated title and description: $data');
        final PostAIGeneration postInfo = PostAIGeneration.fromJson(data);
        return postInfo;
      } else {
        return Future.error('Failed to generate post title and description.');
      }
    } catch (e) {
      AppLog.log().e("error while generating post title and description: $e");
      return Future.error('Failed to generate post title and description.');
    }
  }

  static Future<PostAIGeneration> gptVisionSimulatePost() async {
    try {
      var data = {
        'title': 'A beautiful sunset',
        'description': 'A beautiful sunset over the ocean.',
      };
      final PostAIGeneration postInfo = PostAIGeneration.fromJson(data);
      await Future.delayed(const Duration(seconds: 4));
      return postInfo;
    } catch (e) {
      AppLog.log().e("error while generating post title and description: $e");
      return Future.error('Failed to generate post title and description.');
    }
  }
}
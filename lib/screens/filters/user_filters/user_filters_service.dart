import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';

class UserFiltersService {

  static Future<List<PostLikedUser>> filterUsers(String filterText) async {
    try {
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/filter/users'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'query': filterText,
        }),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> usersJson = data['users'] as List<dynamic>;
        final List<PostLikedUser> users = usersJson
          .map((e) => PostLikedUser.fromJson(e as Map<String, dynamic>))
          .toList();
        return users;
      } else {
        return Future.error('Failed to get filtered users.');
      }
    } catch (e) {
      AppLog.log().e("error while filtering users: $e");
      return Future.error('Failed to get filtered users.');
    }
  }

  static Future<List<UserAutoComplete>> autoCompleteUsers(String filterText) async {
    try {
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/autocomplete/users'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'query': filterText,
        }),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> usersJson = data['users'] as List<dynamic>;
        final List<UserAutoComplete> users = usersJson
          .map((e) => UserAutoComplete.fromJson(e as Map<String, dynamic>))
          .toList();
        return users;
      } else {
        return Future.error('Failed to get autocomplete users.');
      }
    } catch (e) {
      AppLog.log().e("error while autocomplete users: $e");
      return Future.error('Failed to get autocomplete users.');
    }
  }
}
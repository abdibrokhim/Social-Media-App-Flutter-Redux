import 'package:socialmediaapp/components/shared/get_access_token.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';
import 'package:socialmediaapp/screens/auth/components/secure_storage.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService {

  static Future<bool> usernameExists(String username) async {
    try {
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/usernameExists'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        bool usernameExists = data['exists'];
        return usernameExists;
      } else {
        return Future.error('Error while checking if username exists.');
      }
    } catch (e) {
      AppLog.log().e("Error while checking if username exists.: $e");
      return Future.error('Error while checking if username exists.');
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/login'), 
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseApi = json.decode(response.body);
        String message = responseApi['message'];
        int statusCode = responseApi['statusCode'];

        if (statusCode == 200) {
          final Map<String, dynamic> data = responseApi['data'];

          showToast(message: message, bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");

          int userId = User.fromJson(data['user']).id;
          AppLog.log().i("AuthService user id: $userId");
          StorageService.storeAccess(data['access_token'], data['refresh_token'], userId);
          User user = User.fromJson(data['user']);
          String accessToken = data['access_token'];
          String refreshToken = data['refresh_token'];
          return {
            'user': user,
            'accessToken': accessToken,
            'refreshToken': refreshToken,
          };
        } else {
          showToast(message: message, bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
          return Future.error('Error while logging in.');
        }
      } else {
        showToast(message: 'Error while logging in.', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
        return Future.error('Error while logging in');
      }
    } catch (e) {
      AppLog.log().e("error while logging in: $e");
      return Future.error('Error while logging in');
    }
  }

  static Future<bool> register(String email, String password, String username) async {
    try {
      AppLog.log().e("registering user: $username");

      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/register'),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode({
          'email': email,
          'password': password,
          'username': username,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String message = data['message'];
        int statusCode = data['statusCode'];
        if (statusCode == 200) {
          showToast(message: message, bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
          return true;
        } else {
          showToast(message: message, bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
          return false;
        }
      } else {
        return Future.error('Error while registering');
      }
    } catch (e) {
      AppLog.log().e("error while registering: $e");
      return Future.error('Error while registering');
    }
  }

  static Future<void> refreshAccessToken() async {
    try {
      String accessToken = await getAccessToken();
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/new_access_token'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        int userId = User.fromJson(data['user']).id;
        StorageService.storeAccess(data['access_token'], data['refresh_token'], userId);
      } else {
        return Future.error('Error while refreshing access token');
      }
    } catch (e) {
      AppLog.log().e("error while refreshing access token: $e");
      return Future.error('Error while refreshing access token');
    }
  }

  static Future<void> logout() async {
    try {
      String accessToken = await getAccessToken();
      print('logging out user');
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/logout'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        StorageService.clearAccessStorage();
        String message = data['message'];
        showToast(message: message, bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
      } else {
        return Future.error('Error while logging out');
      }
    } catch (e) {
      AppLog.log().e("error while logging out: $e");
      return Future.error('Error while logging out');
    }
  }

  static Future<void> removeAccessToken() async {
    return;
  }
}
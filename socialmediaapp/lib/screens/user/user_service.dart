// import 'package:flutter/foundation.dart';
import 'package:socialmediaapp/components/shared/get_access_token.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/auth/components/secure_storage.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';


class UserService {

  static Future<Map<String, String?>> getUserAccessToken() async {
    try {
      var tokens = await StorageService.readItemsFromToKeyChain();
        String accessToken = tokens['accessToken'] ?? '';
        String refreshToken = tokens['refreshToken'] ?? '';
        String userId = tokens['userId'] ?? '';
        if (accessToken == '' || refreshToken == '') {
          return {'accessToken': null, 'refreshToken': null, 'userId': null};
        }
        AppLog.log().i({'accessToken': accessToken, 'refreshToken': refreshToken, 'userId': userId});
        return {'accessToken': accessToken, 'refreshToken': refreshToken, 'userId': userId};
    } catch (e) {
      AppLog.log().e("error while fetching access token: $e");
      return Future.error('Failed to get user access token');
    }
  }

  static Future<User> getUserByIdSmall(int uId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/small'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        int statusCode = data['statusCode'];
        if (statusCode == 404) {
          String message = data['message'];
          showToast(message: message, bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
          return Future.error('An error occurred while fetching user');
        } else {
          final User user = User.fromJson(data["user"]);
          print('data: $data');
          return user;
        }
      } else {
        return Future.error('Failed to get user by id Small');
      }
    } catch (e) {
      AppLog.log().e("error while fetching user by id small: $e");
      return Future.error('Failed to get user by id Small');
    }
  }

  static Future<UpdateUser> getUpdatedUserByIdSmall() async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/updated'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        int statusCode = data['statusCode'];
        if (statusCode == 404) {
          String message = data['message'];
          showToast(message: message, bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
          return Future.error('An error occurred while fetching updated user');
        } else {
          final UpdateUser user = UpdateUser.fromJson(data["user"]);
          print('data: $data');
          return user;
        }
      } else {
        return Future.error('Failed to get user by id Small');
      }
    } catch (e) {
      AppLog.log().e("error while fetching updated user by is small: $e");
      return Future.error('Failed to get user by id Small');
    }
  }

  static Future<User> getUserByUsername(String username) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$username'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final User user = User.fromJson(data);
        return user;
      } else {
        return Future.error('Failed to get user by username');
      }
    } catch (e) {
      AppLog.log().e("error while fetching user by username: $e");
      return Future.error('Failed to get user by username');
    }
  }

  static Future<UpdateUser> updateUser(UpdateUser updatedUser) async {

    try {
      String accessToken = await getAccessToken();

      final response = await http.patch(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final UpdateUser user = UpdateUser.fromJson(data);
        return user;
      } else {
        return Future.error('Failed to update user');
      }
    } catch (e) {
      AppLog.log().e("Error while updating user: $e");
      return Future.error('Error while updating user');
    }
  }

  static Future<void> deleteUser() async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.delete(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print(data);
        return;
      } else {
        return Future.error('Failed to delete user');
      }
    } catch (e) {
      AppLog.log().e("Error while deleting user: $e");
      return Future.error('Error while deleting user');
    }
  }

  static Future<MetaInfo> getUserMetaInfo(int uId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/user-meta-info'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final MetaInfo userMetaInfo = MetaInfo.fromJson(data);
        print('userMetaInfo: $data');
        return userMetaInfo;
      } else {
        return Future.error('Failed to get user meta info');
      }
    } catch (e) {
      AppLog.log().e("error while fetching user: $e");
      return Future.error('Failed to get user meta info');
    }
  }

  static Future<List<SocialMediaLink>> getUserSocialMediaLinks(int uId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/social-media-links'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<SocialMediaLink> userSocialMediaLinks = (data as List).map((e) => SocialMediaLink.fromJson(e)).toList();
        print('userSocialMediaLinks: $data');
        return userSocialMediaLinks;
      } else {
        return Future.error('Failed to get user social media links');
      }
    } catch (e) {
      AppLog.log().e("error while fetching user social media links: $e");
      return Future.error('Failed to get user social media links');
    }
  }

  static Future<List<Category>> getUserInterests(int uId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/interests'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<Category> userInterests = (data as List).map((e) => Category.fromJson(e)).toList();
        print('userInterests: $data');
        return userInterests;
      } else {
        return Future.error('Failed to get user interests');
      }
    } catch (e) {
      AppLog.log().e("error while fetching user interests: $e");
      return Future.error('Failed to get user interests');
    }
  }
  
  static Future<List<SocialMediaLink>> updateUserSocialMediaLink(int smlId, SocialMediaLink updatedLink) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.patch(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/social-media-links/$smlId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(updatedLink.toJson()),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> socialMediaLinksJson = data['social_media_links'] as List<dynamic>;
        final List<SocialMediaLink> userSocialMediaLinks = socialMediaLinksJson
          .map((e) => SocialMediaLink.fromJson(e as Map<String, dynamic>))
          .toList();
        return userSocialMediaLinks;
      } else {
        return Future.error('Failed to update user social media link');
      }
    } catch (e) {
      AppLog.log().e("Error while updating user social media link: $e");
      return Future.error('Error while updating user social media link');
    }
  }
  
  static Future<List<SocialMediaLink>> addUserSocialMediaLink(AddSocialMediaLink links) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/social-media-links'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(links.toJson()),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> socialMediaLinksJson = data['social_media_links'] as List<dynamic>;
        final List<SocialMediaLink> userSocialMediaLinks = socialMediaLinksJson
          .map((e) => SocialMediaLink.fromJson(e as Map<String, dynamic>))
          .toList();
        return userSocialMediaLinks;
      } else {
        return Future.error('Failed to update user social media link');
      }
    } catch (e) {
      AppLog.log().e("Error while updating user social media link: $e");
      return Future.error('Failed to update user social media link');
    }
  }

  static Future<List<SocialMediaLink>> deleteUserSocialMediaLink(int smlId) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.delete(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/social-media-links/$smlId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> socialMediaLinksJson = data['social_media_links'] as List<dynamic>;
        final List<SocialMediaLink> userSocialMediaLinks = socialMediaLinksJson
          .map((e) => SocialMediaLink.fromJson(e as Map<String, dynamic>))
          .toList();
        return userSocialMediaLinks;
      } else {
        return Future.error('Failed to delete user');
      }
    } catch (e) {
      AppLog.log().e("Error while updating user: $e");
      return Future.error('Error while updating user');
    }
  }
  
  static Future<List<Category>> addUserInterests(UserInterest cId) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/interests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(cId.toJson()),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> interestsJson = data['interests'] as List<dynamic>;
        final List<Category> userInterests = interestsJson
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
        return userInterests;
      } else {
        return Future.error('Failed to add user interests');
      }
    } catch (e) {
      AppLog.log().e("Error while adding user interests: $e");
      return Future.error('Failed to add user interests');
    }
  }

  static Future<List<Category>> deleteUserInterests(int cId) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.delete(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/interests/$cId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> interestsJson = data['interests'] as List<dynamic>;
        final List<Category> userInterests = interestsJson
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
        return userInterests;
      } else {
        return Future.error('Failed to delete user interest');
      }
    } catch (e) {
      AppLog.log().e("Error while deleting user interests: $e");
      return Future.error('Failed to delete user interest');
    }
  }

  static Future<void> toggleFollowUser(int uId) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/toggle-follow'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print(data);
      } else {
        return Future.error('Failed to toggle follow user');
      }
    } catch (e) {
      AppLog.log().e("Error while to toggle follow user: $e");
      return Future.error('Failed to toggle follow user');
    }
  }

  static Future<void> followUser(int uId) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/follow'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print(data);
      } else {
        return Future.error('Failed to follow user');
      }
    } catch (e) {
      AppLog.log().e("Error while updating user social media link: $e");
      return Future.error('Failed to follow user');
    }
  }

  static Future<void> unfollowUser(int uId) async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/unfollow'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print(data);
      } else {
        return Future.error('Failed to unfollow user');
      }
    } catch (e) {
      AppLog.log().e("Error while updating user social media link: $e");
      return Future.error('Failed to unfollow user');
    }
  }

  static Future<List<PostFilter>> getUserPosts(int uId) async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/users/$uId/posts'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<PostFilter> userPosts = (data as List).map((e) => PostFilter.fromJson(e)).toList();
        print('userPosts: $data');
        return userPosts;
      } else {
        return Future.error('Failed to get user posts');
      }
    } catch (e) {
      AppLog.log().e("error while fetching user interests: $e");
      return Future.error('Failed to get user posts');
    }
  }

  static Future<List<UserSubscription>> getUserSubscription() async {
    try {
      String accessToken = await getAccessToken();
      print('accessToken: $accessToken');

      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/subscription'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print("i am here");
      print('response b: ${response.body}');
      print('response s: ${response.statusCode}');
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        int statusCode = data['statusCode'];
        print("statusCode: $statusCode");
        if (statusCode == 200) {
                  final List<dynamic> subscription = data['subscription'] as List<dynamic>;
          final List<UserSubscription> users = subscription
            .map((e) => UserSubscription.fromJson(e as Map<String, dynamic>))
            .toList();
          return users;
        }
        return [];
      } else {
        return Future.error('Failed to get user subscription');
      }
    } catch (e) {
      AppLog.log().e("error while fetching user subscription: $e");
      return Future.error('Failed to get user subscription');
    }
  }

  static Future<List<UserSubscription>> subscribeUser() async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/subscription'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
                          final List<dynamic> subscription = data['subscription'] as List<dynamic>;
          final List<UserSubscription> users = subscription
            .map((e) => UserSubscription.fromJson(e as Map<String, dynamic>))
            .toList();
          return users;
      }
      return Future.error('Failed to subscribe user');
    } catch (e) {
      AppLog.log().e("Error while subscribe user: $e");
      return Future.error('Failed to subscribe user');
    }
  }

  static Future<void> unsubscribeUser() async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.delete(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/subscription'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print('userSubscription: $data');
      } else {
        return Future.error('Failed to unsubscribe user');
      }
    } catch (e) {
      AppLog.log().e("Error while unsubscribe user: $e");
      return Future.error('Failed to unsubscribe user');
    }
  }

  static Future<List<UserSubscription>> updateSubscription() async {
    try {
      String accessToken = await getAccessToken();

      final response = await http.patch(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/subscription'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        int statusCode = data['statusCode'];
        print("statusCode: $statusCode");
        if (statusCode == 200) {
                                    final List<dynamic> subscription = data['subscription'] as List<dynamic>;
          final List<UserSubscription> users = subscription
            .map((e) => UserSubscription.fromJson(e as Map<String, dynamic>))
            .toList();
          return users;
        }
        return Future.error('Failed to update subscription');
      } else {
        return Future.error('Failed to update subscription');
      }
    } catch (e) {
      AppLog.log().e("Error while updating subscription: $e");
      return Future.error('Failed to update subscription');
    }
  }

}
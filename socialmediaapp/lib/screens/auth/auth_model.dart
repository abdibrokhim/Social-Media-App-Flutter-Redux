import 'package:socialmediaapp/screens/user/user_model.dart';

class AuthAccess {
  String accessToken;
  String refreshToken;

  AuthAccess({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthAccess.fromJson(Map<String, dynamic> json) {
    return AuthAccess(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

class UserWithAccess {
  User user;
  AuthAccess authAccess;

  UserWithAccess({
    required this.user,
    required this.authAccess,
  });

  factory UserWithAccess.fromJson(Map<String, dynamic> json) {
    return UserWithAccess(
      user: User.fromJson(json['user']),
      authAccess: AuthAccess.fromJson(json['auth_access']),
    );
  }
}
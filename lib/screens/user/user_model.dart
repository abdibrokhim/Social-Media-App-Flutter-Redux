import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';

// ========== User Model ========== //

class User {
  final int id;
  final String? firstName;
  final String? lastName;
  final String username;
  final String? profileImage;
  final String email;
  final double activityLevel;
  final bool isDeleted;
  final bool isEmailValidated;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final MetaInfo? metaInfo;
  final List<SocialMediaLink>? socialMediaLinks;
  final List<Category>? interests;
  final List<PostFilter>? posts;
  final List<UserSubscription>? subscription;

  User({
    required this.id,
    this.firstName,
    this.lastName,
    required this.username,
    this.profileImage,
    required this.email,
    required this.activityLevel,
    required this.isDeleted,
    required this.isEmailValidated,
    required this.createdAt,
    this.updatedAt,
    this.metaInfo,
    this.socialMediaLinks,
    this.interests,
    this.posts,
    this.subscription,
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? profileImage,
    String? email,
    double? activityLevel,
    bool? isDeleted,
    bool? isEmailValidated,
    DateTime? createdAt,
    DateTime? updatedAt,
    MetaInfo? metaInfo,
    List<SocialMediaLink>? socialMediaLinks,
    List<Category>? interests,
    List<PostFilter>? posts,
    List<UserSubscription>? subscription,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      activityLevel: activityLevel ?? this.activityLevel,
      isDeleted: isDeleted ?? this.isDeleted,
      isEmailValidated: isEmailValidated ?? this.isEmailValidated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metaInfo: metaInfo ?? this.metaInfo,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      interests: interests ?? this.interests,
      posts: posts ?? this.posts,
      subscription: subscription ?? this.subscription,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'],
      profileImage: json['profileImage'] ?? '',
      email: json['email'],
      activityLevel: json['activityLevel'],
      isDeleted: json['isDeleted'] == 1,
      isEmailValidated: json['isEmailValidated'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      metaInfo: json['userMetaInfo'] != null ? MetaInfo.fromJson(json['userMetaInfo']) : null,
      socialMediaLinks: json['socialMediaLinks'] != null ? (json['socialMediaLinks'] as List).map((e) => SocialMediaLink.fromJson(e)).toList() : null,
      interests: json['interests'] != null ? (json['interests'] as List).map((e) => Category.fromJson(e)).toList() : null,
      posts: json['posts'] != null ? (json['posts'] as List).map((e) => PostFilter.fromJson(e)).toList() : null,
      subscription: json['subscription'] != null ? (json['subscription'] as List).map((e) => UserSubscription.fromJson(e)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'profileImage': profileImage,
      'email': email,
      'activityLevel': activityLevel,
      'isDeleted': isDeleted,
      'isEmailValidated': isEmailValidated,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metaInfo': metaInfo?.toJson(),
      'socialMediaLinks': socialMediaLinks?.map((e) => e.toJson()).toList(),
      'interests': interests?.map((e) => e.toJson()).toList(),
      'posts': posts?.map((e) => e.toJson()).toList(),
      'subscription': subscription?.map((e) => e.toJson()).toList(),
    };
  }
}


// ========== Meta Info Model ========== //

class MetaInfo {
  final int id;
  final int followers;
  final int following;
  final int likes;

  MetaInfo({
    required this.id,
    required this.followers,
    required this.following,
    required this.likes,
  });

  MetaInfo copywith({
    int? id,
    int? followers,
    int? following,
    int? likes,
  }) {
    return MetaInfo(
      id: id ?? this.id,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      likes: likes ?? this.likes,
    );
  }

  factory MetaInfo.fromJson(Map<String, dynamic> json) {
    return MetaInfo(
      id: json['id'],
      followers: json['followers'],
      following: json['following'],
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'followers': followers,
      'following': following,
      'likes': likes,
    };
  }
}


// ========== Social Media Links Model ========== //

class SocialMediaLink {
  final int id;
  final String icon;
  final String name;
  final String url;

  SocialMediaLink({
    required this.id,
    required this.icon,
    required this.name,
    required this.url,
  });

  SocialMediaLink copyWith({
    int? id,
    String? icon,
    String? name,
    String? url,
  }) {
    return SocialMediaLink(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory SocialMediaLink.fromJson(Map<String, dynamic> json) {
    return SocialMediaLink(
      id: json['id'],
      icon: json['icon'],
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'name': name,
      'url': url,
    };
  }
}


// ========== User Interests ========== //

class UserInterest {
  final int categoryId;

  UserInterest({
    required this.categoryId,
  });

  UserInterest copyWith({
    int? categoryId,
  }) {
    return UserInterest(
      categoryId: categoryId ?? this.categoryId,
    );
  }

  factory UserInterest.fromJson(Map<String, dynamic> json) {
    return UserInterest(
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
    };
  }
}


// ========== User Update ========== //

class UpdateUser {
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final DateTime? updatedAt;

  UpdateUser({
    this.firstName,
    this.lastName,
    this.profileImage,
    this.updatedAt,
  });

  UpdateUser copyWith({
    String? firstName,
    String? lastName,
    String? profileImage,
    DateTime? updatedAt,
  }) {
    return UpdateUser(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImage: profileImage ?? this.profileImage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UpdateUser.fromJson(Map<String, dynamic> json) {
    return UpdateUser(
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImage: json['profileImage'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': profileImage,
    };
  }
}


// ========== User Small ========== //

class UserSmall {
  final int id;
  final String? firstName;
  final String? lastName;
  final String username;
  final String? profileImage;
  final String email;
  final double activityLevel;
  final bool isDeleted;
  final bool isEmailValidated;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserSmall({
    required this.id,
    this.firstName,
    this.lastName,
    required this.username,
    this.profileImage,
    required this.email,
    required this.activityLevel,
    required this.isDeleted,
    required this.isEmailValidated,
    required this.createdAt,
    this.updatedAt,
  });

  UserSmall copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? profileImage,
    String? email,
    double? activityLevel,
    bool? isDeleted,
    bool? isEmailValidated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSmall(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      activityLevel: activityLevel ?? this.activityLevel,
      isDeleted: isDeleted ?? this.isDeleted,
      isEmailValidated: isEmailValidated ?? this.isEmailValidated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserSmall.fromJson(Map<String, dynamic> json) {
    return UserSmall(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      profileImage: json['profileImage'],
      email: json['email'],
      activityLevel: json['activityLevel'],
      isDeleted: json['isDeleted'] == 1,
      isEmailValidated: json['isEmailValidated'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'profileImage': profileImage,
      'email': email,
      'activityLevel': activityLevel,
      'isDeleted': isDeleted,
      'isEmailValidated': isEmailValidated,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

}


// ========== User AutoComplete ========== //

class UserAutoComplete {
  final int id;
  final String firstName;
  final String lastName;
  final String username;

  UserAutoComplete({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
  });


  UserAutoComplete copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
  }) {
    return UserAutoComplete(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
    );
  }

  factory UserAutoComplete.fromJson(Map<String, dynamic> json) {
    return UserAutoComplete(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
    };
  }
}


// ========== Add Social Media Links Model ========== //

class AddSocialMediaLink {
  final String icon;
  final String name;
  final String url;

  AddSocialMediaLink({
    required this.icon,
    required this.name,
    required this.url,
  });

  AddSocialMediaLink copyWith({
    String? icon,
    String? name,
    String? url,
  }) {
    return AddSocialMediaLink(
      icon: icon ?? this.icon,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'name': name,
      'url': url,
    };
  }
}


// ========== Subscription Model ========== //

class UserSubscription {
  final int userId;
  final DateTime subscribedDate;
  final DateTime expirationDate;
  final bool expired;

  UserSubscription({
    required this.userId,
    required this.subscribedDate,
    required this.expirationDate,
    required this.expired,
  });

  UserSubscription copyWith({
    int? userId,
    DateTime? subscribedDate,
    DateTime? expirationDate,
    bool? expired,
  }) {
    return UserSubscription(
      userId: userId ?? this.userId,
      subscribedDate: subscribedDate ?? this.subscribedDate,
      expirationDate: expirationDate ?? this.expirationDate,
      expired: expired ?? this.expired,
    );
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      userId: json['userId'],
      subscribedDate: DateTime.parse(json['subscribedDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
      expired: json['expired'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'subscribedDate': subscribedDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'expired': expired,
    };
  }
}

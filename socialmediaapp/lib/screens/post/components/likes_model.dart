class PostLikedUser {
  final int userId;
  final String username;
  final String? profileImage;

  PostLikedUser({
    required this.userId,
    required this.username,
    this.profileImage
  });

  PostLikedUser copyWith({
    int? userId,
    String? username,
    String? profileImage,
  }) {
    return PostLikedUser(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  factory PostLikedUser.fromJson(Map<String, dynamic> json) {
    return PostLikedUser(
      userId: json['userId'],
      username: json['username'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profileImage': profileImage,
    };
  }

}
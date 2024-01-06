import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';


// ========== Post Model ========== //

class Post {
  final int id;
  final DateTime createdAt;
  final String? description;
  final String? image;
  final double activityLevel;
  final bool isDeleted;
  final String title;
  final DateTime? updatedAt;
  final List<Category>? categories;

  Post({
    required this.id,
    required this.createdAt,
    this.description,
    this.image,
    required this.activityLevel,
    required this.isDeleted,
    required this.title,
    this.updatedAt,
    this.categories,
  });

  Post copyWith({
    int? id,
    DateTime? createdAt,
    String? description,
    String? image,
    double? activityLevel,
    bool? isDeleted,
    String? title,
    DateTime? updatedAt,
    List<Category>? categories,
  }) {
    return Post(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      image: image ?? this.image,
      activityLevel: activityLevel ?? this.activityLevel,
      isDeleted: isDeleted ?? this.isDeleted,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      categories: categories ?? this.categories,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'] ?? '',
      image: json['image'],
      activityLevel: json['activityLevel'],
      isDeleted: json['isDeleted'] == 1,
      title: json['title'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      categories: json['categories'] != null ? (json['categories'] as List).map((e) => Category.fromJson(e)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'image': image,
      'activityLevel': activityLevel,
      'isDeleted': isDeleted,
      'title': title,
      'updatedAt': updatedAt?.toIso8601String(),
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
  }
}


// ========== Post Category Model ========== //

class PostCategory {
  final int categoryId;

  PostCategory({
    required this.categoryId,
  });

  PostCategory copyWith({
    int? categoryId,
  }) {
    return PostCategory(
      categoryId: categoryId ?? this.categoryId,
    );
  }

  factory PostCategory.fromJson(Map<String, dynamic> json) {
    return PostCategory(
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
    };
  }
}

class UpdatePost {
  final String? description;
  final String? image;
  final String? title;

  UpdatePost({
    this.description,
    this.image,
    this.title,
  });

  UpdatePost copyWith({
    String? description,
    String? image,
    String? title,
  }) {
    return UpdatePost(
      description: description ?? this.description,
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }

  factory UpdatePost.fromJson(Map<String, dynamic> json) {
    return UpdatePost(
      description: json['description'],
      image: json['image'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'title': title,
    };
  }
}


// ========== Create Post Model ========== //


class CreatePost {
  final String? description;
  final String? image;
  final String title;
  final List<PostCategory>? categories;

  CreatePost({
    this.description,
    this.image,
    required this.title,
    this.categories,
  });

  CreatePost copyWith({
    String? description,
    String? image,
    String? title,
    List<PostCategory>? categories,
  }) {
    return CreatePost(
      description: description ?? this.description,
      image: image ?? this.image,
      title: title ?? this.title,
      categories: categories ?? this.categories,
    );
  }

  factory CreatePost.fromJson(Map<String, dynamic> json) {
    return CreatePost(
      description: json['description'],
      image: json['image'],
      title: json['title'],
      categories: json['categories'] != null ? (json['categories'] as List).map((e) => PostCategory.fromJson(e)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'title': title,
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
  }
}



// ========== Post Meta Info Model ========== //

class PostMetaInfo {
  final Post post;
  final int likes;
  final PostLikedUser? likedUser;

  PostMetaInfo({
    required this.post,
    required this.likes,
    this.likedUser,
  });

  PostMetaInfo copyWith({
    Post? post,
    int? likes,
    PostLikedUser? likedUser,
  }) {
    return PostMetaInfo(
      post: post ?? this.post,
      likes: likes ?? this.likes,
      likedUser: likedUser ?? this.likedUser,
    );
  }

  factory PostMetaInfo.fromJson(Map<String, dynamic> json) {
    return PostMetaInfo(
      post: Post.fromJson(json['post']),
      likes: json['likes'],
      likedUser: json['likedUser'] != null ? PostLikedUser.fromJson(json['likedUser']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post': post.toJson(),
      'likes': likes,
      'likedUser': likedUser?.toJson(),
    };
  }
}


// ========== Post Filter Model ========== //

class PostFilter {
  final int postId;
  final String title;
  final String image;
  final List<Category>? categories;
  final DateTime? createdAt;

  PostFilter({
    required this.postId,
    required this.title,
    required this.image,
    this.categories,
    this.createdAt,
  });

  PostFilter copyWith({
    int? postId,
    String? title,
    String? image,
    List<Category>? categories,
    DateTime? createdAt,
  }) {
    return PostFilter(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      image: image ?? this.image,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PostFilter.fromJson(Map<String, dynamic> json) {
    return PostFilter(
      postId: json['postId'],
      title: json['title'],
      image: json['image'],
      categories: json['categories'] != null ? (json['categories'] as List).map((e) => Category.fromJson(e)).toList() : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'title': title,
      'image': image,
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
  }
}


// ========== Post Autocomplete Model ========== //

class PostAutocomplete {
  final int id;
  final String title;
  final String description;

  PostAutocomplete({
    required this.id,
    required this.title,
    required this.description,
  });

  PostAutocomplete copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return PostAutocomplete(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  factory PostAutocomplete.fromJson(Map<String, dynamic> json) {
    return PostAutocomplete(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

// ========== Post AI title and description generation Model ========== //

class PostAIGeneration {
  final String title;
  final String description;

  PostAIGeneration({
    required this.title,
    required this.description,
  });

  PostAIGeneration copyWith({
    String? title,
    String? description,
  }) {
    return PostAIGeneration(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  factory PostAIGeneration.fromJson(Map<String, dynamic> json) {
    return PostAIGeneration(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
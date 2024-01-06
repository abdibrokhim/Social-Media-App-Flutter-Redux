// ========== Category Model ========== //

// CREATE TABLE IF NOT EXISTS Categories (
//     id INTEGER PRIMARY KEY,
//     createdAt DATETIME NOT NULL,
//     name TEXT NOT NULL,
//     isDeleted BOOLEAN NOT NULL
// );

class Category {
  final int id;
  final String name;
  final bool isDeleted;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      isDeleted: json['isDeleted'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
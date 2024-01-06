class GoogleSignInData {
  final String? idToken;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  GoogleSignInData({
    this.idToken,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  GoogleSignInData copyWith({
    String? idToken,
    String? displayName,
    String? email,
    String? photoUrl,
  }) {
    return GoogleSignInData(
      idToken: idToken ?? this.idToken,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  factory GoogleSignInData.fromJson(Map<String, dynamic> json) {
    return GoogleSignInData(
      idToken: json['idToken'],
      displayName: json['displayName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
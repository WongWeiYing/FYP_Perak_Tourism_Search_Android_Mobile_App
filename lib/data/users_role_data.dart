class CurrentUserData {
  final String? role;
  final String? userID;
  final String? fcmToken;
  final String? username;
  final String? profilePic;

  CurrentUserData(
      {this.role, this.userID, this.fcmToken, this.username, this.profilePic});

  CurrentUserData copyWith({String? role, String? userID, String? fcmToken}) {
    return CurrentUserData(
        role: role ?? this.role,
        userID: userID ?? this.userID,
        fcmToken: fcmToken ?? this.fcmToken,
        username: username ?? this.username,
        profilePic: profilePic ?? this.profilePic);
  }

  factory CurrentUserData.fromJson(Map<String, dynamic> json, String userID) {
    return CurrentUserData(
      userID: json['userID'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
    };
  }
}

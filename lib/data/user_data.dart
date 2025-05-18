class UserData {
  final String userID;
  final String fullname;
  final String username;
  final String profilePic;

  UserData(
      {required this.userID,
      required this.fullname,
      required this.username,
      required this.profilePic});

  factory UserData.fromJson(Map<String, dynamic> json, String? id) {
    return UserData(
      userID: id ?? json['userID'],
      fullname: json['fullname'],
      username: json['username'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'fullname': fullname,
      'username': username,
      'profilePic': profilePic
    };
  }
}

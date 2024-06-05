// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String uid;
  String username;
  String pin;
  List<String> friends;

  UserModel({
    required this.uid,
    required this.username,
    required this.pin,
    required this.friends,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'username': this.username,
      'pin': this.pin,
      'friends': this.friends,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> userData) => UserModel(
        uid: userData['uid'],
        username: userData['username'],
        pin: userData['pin'],
        friends: List<String>.from(userData['friends']),
      );
}

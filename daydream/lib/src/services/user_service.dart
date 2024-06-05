import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daydream/src/models/user_model.dart';
import 'package:daydream/src/services/auth_service.dart';
import 'package:daydream/utils.dart';

class UserService {
  final _usersRef = FirebaseFirestore.instance.collection('users');
  final AuthService authService;

  UserService(this.authService);

  Future<void> createUser(
      String email, String password, String username) async {
    final uid = await authService.createUser(email, password);
    _usersRef.doc(uid).set(UserModel(
          uid: uid,
          username: username,
          pin: generatePin(),
          friends: [],
        ).toMap());
  }

  Future<UserModel?> getUserById(String uid) async {
    DocumentSnapshot snapshot = await _usersRef.doc(uid).get();

    if (snapshot.exists) {
      final userData = snapshot.data() as Map<String, dynamic>;
      final user = UserModel.fromMap(userData);
      return user;
    } else {
      return null;
    }
  }

  Future<UserModel?> getUserByPin(String pin) async {
    final QuerySnapshot snapshot =
        await _usersRef.where('pin', isEqualTo: pin).get();
    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs.first.data() as Map<String, dynamic>;
      final user = UserModel.fromMap(userData);
      return user;
    } else {
      return null;
    }
  }

  Future<void> addFriend(String friendUid) async {
    log('UserService-addFriend');
    final myUid = authService.myUid;
    await _usersRef.doc(myUid).update({
      'friends': FieldValue.arrayUnion([friendUid])
    });
  }

  Stream<List<UserModel>> friendsStream() {
    final uid = authService.myUid;
    return _usersRef.doc(uid).snapshots().asyncMap((snapshot) async {
      final userData = snapshot.data() as Map<String, dynamic>;
      final user = UserModel.fromMap(userData);
      final friendUids = user.friends;

      List<UserModel?> friendFutures = await Future.wait(
          friendUids.map((friendUid) => getUserById(friendUid)));

      List<UserModel> friends = friendFutures
          .where((friend) => friend != null)
          .map((friend) => friend!)
          .toList();

      return friends;
    });
  }
}

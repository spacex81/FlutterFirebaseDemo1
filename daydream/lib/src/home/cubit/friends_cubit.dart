import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:daydream/src/auth/cubit/auth_cubit.dart';
import 'package:daydream/src/models/user_model.dart';
import 'package:daydream/src/services/auth_service.dart';
import 'package:daydream/src/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  AuthService authService;
  UserService userService;
  StreamSubscription? _friendsStreamSubscription;

  FriendsCubit(this.authService, this.userService) : super(FriendsInitial()) {
    // need to cancel the subscription when we press logout
    authService.authStateStream.listen((User? user) {
      if (user == null) {
        _friendsStreamSubscription?.cancel();
      } else {
        _friendsStreamSubscription =
            userService.friendsStream().listen((List<UserModel> friends) {
          emit(FriendsLoaded(friends));
        });
      }
    });
  }

  Future<void> addFriendByPin(String friendPin) async {
    log('FriendsCubit-addFriendByPin: ${authService.myUid}');
    if (authService.myUid != null) {
      final friend = await userService.getUserByPin(friendPin);
      if (friend != null) {
        final friendUid = friend.uid;
        await userService.addFriend(friendUid);
      } else {
        emit(FriendsError(
            'FriendsCubit-addFriendByPin: No friend found for corresponding pin'));
      }
    } else {
      emit(FriendsError(
          'FriendsCubit-addFriendByPin: authService.myUid is null'));
    }
  }

  @override
  Future<void> close() {
    _friendsStreamSubscription?.cancel();
    return super.close();
  }
}

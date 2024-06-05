part of 'friends_cubit.dart';

class FriendsState {}

final class FriendsInitial extends FriendsState {}

final class FriendsLoading extends FriendsState {}

final class FriendsLoaded extends FriendsState {
  List<UserModel> friends;

  FriendsLoaded(this.friends);
}

final class FriendsError extends FriendsState {
  String message;

  FriendsError(this.message);
}

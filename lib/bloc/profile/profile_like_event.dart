part of 'profile_like_bloc.dart';

@immutable
abstract class ProfileLikeEvent {}

class ProfileLikeLoadingEvent extends ProfileLikeEvent {
  User user;
  ProfileLikeLoadingEvent(this.user);
}

class ProfileLikeAddEvent extends ProfileLikeEvent {
  User user;
  ProfileLikeAddEvent(this.user);
}

class ProfileLikeReloadEvent extends ProfileLikeEvent {
  User user;
  ProfileLikeReloadEvent(this.user);
}

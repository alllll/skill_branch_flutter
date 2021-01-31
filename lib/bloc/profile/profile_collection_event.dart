part of 'profile_collection_bloc.dart';

@immutable
abstract class ProfileCollectionEvent {}

class ProfileCollectionLoadingEvent extends ProfileCollectionEvent {
  User user;
  ProfileCollectionLoadingEvent(this.user);
}

class ProfileCollectionAddEvent extends ProfileCollectionEvent {
  User user;
  ProfileCollectionAddEvent(this.user);
}

class ProfileCollectionReloadEvent extends ProfileCollectionEvent {
  User user;
  ProfileCollectionReloadEvent(this.user);
}

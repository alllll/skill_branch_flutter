part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileAuthenticatedState extends ProfileState {
  User user;
  ProfileAuthenticatedState(this.user);
}

class ProfileNoAutheticatedState extends ProfileState {}

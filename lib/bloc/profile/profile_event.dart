part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileAuthenticatedEvent extends ProfileEvent {
  final String token;

  ProfileAuthenticatedEvent(this.token);
}

class ProfileCheckAuth extends ProfileEvent {}

class ProfileLogoutEvent extends ProfileEvent {}

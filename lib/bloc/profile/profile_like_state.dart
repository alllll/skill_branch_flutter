part of 'profile_like_bloc.dart';

@immutable
abstract class ProfileLikeState {}

class ProfilelikeInitial extends ProfileLikeState {}

class ProfileLikeLoadedState extends ProfileLikeState {
  final List<Photo> photo;
  ProfileLikeLoadedState(this.photo);
}

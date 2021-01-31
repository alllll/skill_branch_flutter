part of 'author_photo_bloc.dart';

abstract class AuthorPhotoState extends Equatable {
  const AuthorPhotoState();

  @override
  List<Object> get props => [];
}

class AuthorPhotoInitial extends AuthorPhotoState {}

class AuthorPhotoLoadedState extends AuthorPhotoState {
  final List<Photo> photo;
  //final DateTime date;
  AuthorPhotoLoadedState(this.photo);
  @override
  List<Object> get props => [photo];
}

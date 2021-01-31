part of 'author_photo_bloc.dart';

abstract class AuthorPhotoEvent extends Equatable {
  const AuthorPhotoEvent();

  @override
  List<Object> get props => [];
}

class AuthorPhotoLoadingEvent extends AuthorPhotoEvent {
  User user;
  AuthorPhotoLoadingEvent(this.user);
}

class AuthorPhotoAddEvent extends AuthorPhotoEvent {
  User user;

  AuthorPhotoAddEvent(this.user);
}

class AuthorPhotoReloadEvent extends AuthorPhotoEvent {
  User user;
  AuthorPhotoReloadEvent(this.user);
}

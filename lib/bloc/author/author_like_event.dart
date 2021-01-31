part of 'author_like_bloc.dart';

abstract class AuthorLikeEvent extends Equatable {
  const AuthorLikeEvent();

  @override
  List<Object> get props => [];
}

class AuthorLikeLoadingEvent extends AuthorLikeEvent {
  User user;
  AuthorLikeLoadingEvent(this.user);
}

class AuthorLikeAddEvent extends AuthorLikeEvent {
  User user;
  AuthorLikeAddEvent(this.user);

  @override
  List<Object> get props => [user];
}

class AuthorLikeReloadEvent extends AuthorLikeEvent {
  User user;
  AuthorLikeReloadEvent(this.user);

  @override
  List<Object> get props => [user];
}

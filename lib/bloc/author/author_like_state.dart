part of 'author_like_bloc.dart';

abstract class AuthorLikeState extends Equatable {
  const AuthorLikeState();

  @override
  List<Object> get props => [];
}

class AuthorLikeInitial extends AuthorLikeState {}

class AuthorLikeLoadedState extends AuthorLikeState {
  final List<Photo> photo;
  AuthorLikeLoadedState(this.photo);
  @override
  List<Object> get props => [photo];
}

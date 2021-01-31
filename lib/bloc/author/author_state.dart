part of 'author_bloc.dart';

abstract class AuthorState extends Equatable {
  const AuthorState();

  @override
  List<Object> get props => [];
}

class AuthorInitial extends AuthorState {}

class AuthorLoading extends AuthorState {}

class AuthorLoaded extends AuthorState {
  final User user;

  AuthorLoaded(this.user) : super();

  @override
  List<Object> get props => [user];
}

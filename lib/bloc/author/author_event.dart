part of 'author_bloc.dart';

abstract class AuthorEvent extends Equatable {
  const AuthorEvent();

  @override
  List<Object> get props => [];
}

class AuthorChoiceEvent extends AuthorEvent {
  final String id;
  const AuthorChoiceEvent(this.id) : super();

  @override
  List<Object> get props => [id];
}

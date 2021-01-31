part of 'author_collection_bloc.dart';

abstract class AuthorCollectionState extends Equatable {
  const AuthorCollectionState();

  @override
  List<Object> get props => [];
}

class AuthorCollectionInitial extends AuthorCollectionState {}

class AuthorCollectionLoadedState extends AuthorCollectionState {
  final List<Collection> collections;
  AuthorCollectionLoadedState(this.collections);
  @override
  List<Object> get props => [collections];
}

part of 'author_collection_bloc.dart';

abstract class AuthorCollectionEvent extends Equatable {
  const AuthorCollectionEvent();

  @override
  List<Object> get props => [];
}

class AuthorCollectionLoadingEvent extends AuthorCollectionEvent {
  User user;
  AuthorCollectionLoadingEvent(this.user);
}

class AuthorCollectionAddEvent extends AuthorCollectionEvent {
  User user;
  AuthorCollectionAddEvent(this.user);
}

class AuthorCollectionReloadEvent extends AuthorCollectionEvent {
  User user;
  AuthorCollectionReloadEvent(this.user);
}

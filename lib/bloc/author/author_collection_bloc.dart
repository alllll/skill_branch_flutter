import 'dart:async';

import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'author_collection_event.dart';
part 'author_collection_state.dart';

class AuthorCollectionBloc
    extends Bloc<AuthorCollectionEvent, AuthorCollectionState> {
  AuthorCollectionBloc() : super(AuthorCollectionInitial());
  List<Collection> collections = [];
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  int _page = 1;
  int _perPage = 15;

  @override
  Stream<AuthorCollectionState> mapEventToState(
    AuthorCollectionEvent event,
  ) async* {
    if (event is AuthorCollectionLoadingEvent) {
      _page = 1;
      collections = await unsplashRepository.fetchUserCollections(
          event.user.username, _page, _perPage);
      yield AuthorCollectionLoadedState(collections);
    }

    if (event is AuthorCollectionAddEvent) {
      _page++;
      collections = [
        ...collections,
        ...await unsplashRepository.fetchUserCollections(
            event.user.username, _page, _perPage)
      ];
      yield AuthorCollectionLoadedState(collections);
    }

    if (event is AuthorCollectionReloadEvent) {
      collections.clear();
      _page = 1;
      add(AuthorCollectionLoadingEvent(event.user));
    }
  }
}

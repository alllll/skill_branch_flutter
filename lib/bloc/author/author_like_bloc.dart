import 'dart:async';

import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'author_like_event.dart';
part 'author_like_state.dart';

class AuthorLikeBloc extends Bloc<AuthorLikeEvent, AuthorLikeState> {
  AuthorLikeBloc() : super(AuthorLikeInitial());

  List<Photo> photo = [];
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  int _page = 1;
  int _perPage = 15;

  @override
  Stream<AuthorLikeState> mapEventToState(
    AuthorLikeEvent event,
  ) async* {
    if (event is AuthorLikeLoadingEvent) {
      // yield AuthorLikeLo
      _page = 1;
      photo = await unsplashRepository.fetchUserLikes(
          event.user.username, _page, _perPage);
      yield AuthorLikeLoadedState(photo);
    }

    if (event is AuthorLikeAddEvent) {
      _page++;
      photo = List.from([
        ...photo,
        ...await unsplashRepository.fetchUserLikes(
            event.user.username, _page, _perPage)
      ]);
      print("add likes ${photo.length}");
      yield AuthorLikeLoadedState(photo);
    }

    if (event is AuthorLikeReloadEvent) {
      photo.clear();
      _page = 1;
      add(AuthorLikeLoadingEvent(event.user));
    }
  }
}

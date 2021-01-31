import 'dart:async';

import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profile_like_event.dart';
part 'profile_like_state.dart';

class ProfileLikeBloc extends Bloc<ProfileLikeEvent, ProfileLikeState> {
  ProfileLikeBloc() : super(ProfilelikeInitial());
  List<Photo> photo = [];
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  int _page = 1;
  int _perPage = 15;

  @override
  Stream<ProfileLikeState> mapEventToState(
    ProfileLikeEvent event,
  ) async* {
    if (event is ProfileLikeLoadingEvent) {
      _page = 1;
      photo = await unsplashRepository.fetchUserLikes(
          event.user.username, _page, _perPage);
      yield ProfileLikeLoadedState(photo);
    }

    if (event is ProfileLikeAddEvent) {
      _page++;
      photo = [
        ...photo,
        ...await unsplashRepository.fetchUserLikes(
            event.user.username, _page, _perPage)
      ];
      yield ProfileLikeLoadedState(photo);
    }

    if (event is ProfileLikeReloadEvent) {
      photo.clear();
      _page = 1;
      add(ProfileLikeLoadingEvent(event.user));
    }
  }
}

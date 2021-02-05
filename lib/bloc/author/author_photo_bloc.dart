import 'dart:async';

import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

part 'author_photo_event.dart';
part 'author_photo_state.dart';

class AuthorPhotoBloc extends Bloc<AuthorPhotoEvent, AuthorPhotoState> {
  AuthorPhotoBloc(this._notificationBloc) : super(AuthorPhotoInitial());
  NotificationBloc _notificationBloc;
  List<Photo> photo = [];
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  int _page = 1;
  int _perPage = 15;

  @override
  Stream<AuthorPhotoState> mapEventToState(
    AuthorPhotoEvent event,
  ) async* {
    try {
      if (event is AuthorPhotoLoadingEvent) {
        _page = 1;
        photo = await unsplashRepository.fetchUserPhoto(
            event.user.username, _page, _perPage);
        yield AuthorPhotoLoadedState(photo);
      }

      if (event is AuthorPhotoAddEvent) {
        _page++;
        photo = List.from([
          ...photo,
          ...await unsplashRepository.fetchUserPhoto(
              event.user.username, _page, _perPage)
        ]);
        print("add ${photo.length}");
        yield AuthorPhotoLoadedState(photo);
      }

      if (event is AuthorPhotoReloadEvent) {
        photo.clear();
        _page = 1;
        add(AuthorPhotoLoadingEvent(event.user));
      }
    } catch (e) {
      _notificationBloc.add(NotificationShowEvent(e.toString()));
    }
  }
}

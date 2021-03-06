import 'dart:async';

import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'my_photo_event.dart';
part 'my_photo_state.dart';

class MyPhotoBloc extends Bloc<MyPhotoEvent, MyPhotoState> {
  MyPhotoBloc(this._notificationBloc) : super(MyPhotoInitialState());
  NotificationBloc _notificationBloc;
  List<Photo> photo = [];
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  int _page = 1;
  int _perPage = 15;

  @override
  Stream<MyPhotoState> mapEventToState(
    MyPhotoEvent event,
  ) async* {
    try {
      if (event is MyPhotoLoadingEvent) {
        _page = 1;
        photo = await unsplashRepository.fetchUserPhoto(
            event.user.username, _page, _perPage);
        yield MyPhotoLoadedState(photo);
      }

      if (event is MyPhotoAddEvent) {
        _page++;
        photo = [
          ...photo,
          ...await unsplashRepository.fetchUserPhoto(
              event.user.username, _page, _perPage)
        ];
        yield MyPhotoLoadedState(photo);
      }

      if (event is MyPhotoReloadEvent) {
        photo.clear();
        _page = 1;
        add(MyPhotoLoadingEvent(event.user));
      }
    } catch (e) {
      _notificationBloc.add(NotificationShowEvent(e.toString()));
    }
  }
}

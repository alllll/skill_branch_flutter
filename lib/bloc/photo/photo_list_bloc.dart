import 'dart:async';

import 'package:FlutterGalleryApp/bloc/app/app_bloc.dart';
import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'photo_list_event.dart';
part 'photo_list_state.dart';

class PhotoListBloc extends Bloc<PhotoListEvent, PhotoListState> {
  PhotoListBloc(this._notificationBloc) : super(PhotoListInitial()) {
    this.add(PhotoListAdd());
  }
  NotificationBloc _notificationBloc;
  List<Photo> photo = [];
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  int _page = 1;
  int _perPage = 15;

  @override
  Stream<PhotoListState> mapEventToState(
    PhotoListEvent event,
  ) async* {
    try {
      if (event is PhotoListAdd) {
        photo = [
          ...photo,
          ...await unsplashRepository.fetchPhotos(_page, _perPage)
        ];

        //check list unique items
        photo = [
          ...{...photo}
        ];
        _page++;
        yield PhotoListLoaded(photo, DateTime.now());
      }

      if (event is PhotoListReload) {
        _page = 1;
        photo =
            List.from(await unsplashRepository.fetchPhotos(_page, _perPage));
        _page++;
        yield PhotoListLoaded(photo, DateTime.now());
      }

      if (event is PhotoListRebuild) {
        print("bloc: photolistrebuildevent");
        List<Photo> newPhoto = List.from(photo);
        yield PhotoListLoaded(newPhoto, DateTime.now());
      }
    } catch (e) {
      _notificationBloc.add(NotificationShowEvent(e.toString()));
    }
  }
}

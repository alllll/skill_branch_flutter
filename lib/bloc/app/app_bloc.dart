import 'dart:async';

import 'package:FlutterGalleryApp/bloc/collection/collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_list_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/my_photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_like_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:FlutterGalleryApp/screens/profile_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final CollectionBloc _collectionBloc;
  final NavigationBloc _navigationBloc;
  final PhotoBloc _photoBloc;
  final PhotoListBloc _photoListBloc;
  final ProfileBloc _profileBloc;
  final MyPhotoBloc _myPhotoBloc;
  final ProfileCollectionBloc _profileCollectionBloc;
  final ProfileLikeBloc _profileLikeBloc;

  UnsplashRepository _unsplashRepository = new UnsplashRepository();

  AppBloc(
      this._collectionBloc,
      this._navigationBloc,
      this._photoBloc,
      this._photoListBloc,
      this._profileBloc,
      this._myPhotoBloc,
      this._profileCollectionBloc,
      this._profileLikeBloc)
      : super(AppInitial());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppPhotoLikeEvent) {
      if (_profileBloc.isAuthenticated) {
        await _unsplashRepository.likePhoto(event.photoId);
        _profileLikeBloc.add(ProfileLikeReloadEvent(_profileBloc.user));
        var photos = _photoListBloc.photo
            .where((element) => element.id == event.photoId);
        if (photos.length == 1) {
          photos.elementAt(0).likedByUser = true;
          photos.elementAt(0).likes++;
        }
      } else {
        yield AppNotificationState("Необходимо авторизоваться!");
      }
    }

    if (event is AppPhotoUnlikeEvent) {
      if (_profileBloc.isAuthenticated) {
        await _unsplashRepository.unlikePhoto(event.photoId);
        var photos = _photoListBloc.photo
            .where((element) => element.id == event.photoId);
        if (photos.length == 1) {
          photos.elementAt(0).likedByUser = false;
          photos.elementAt(0).likes--;
        }

        _profileLikeBloc.add(ProfileLikeReloadEvent(_profileBloc.user));
      } else {
        yield AppNotificationState("Необходимо авторизоваться!");
      }
    }

    if (event is AppRebuildEvent) {
      _photoListBloc.add(PhotoListRebuild());
    }

    if (event is AppReloadEvent) {
      _photoListBloc.add(PhotoListReload());
    }
  }
}

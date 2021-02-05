import 'dart:async';

import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'photo_related_event.dart';
part 'photo_related_state.dart';

class PhotoRelatedBloc extends Bloc<PhotoRelatedEvent, PhotoRelatedState> {
  PhotoRelatedBloc(this._notificationBloc) : super(PhotoRelatedInitial());
  UnsplashRepository photoRepository = new UnsplashRepository();
  List<Photo> relatedPhoto;
  NotificationBloc _notificationBloc;

  @override
  Stream<PhotoRelatedState> mapEventToState(
    PhotoRelatedEvent event,
  ) async* {
    try {
      if (event is PhotoRelatedShowEvent) {
        yield PhotoRelatedLoadingState();
        relatedPhoto =
            (await photoRepository.searchPhotoRelated(event.id)).results;
        yield PhotoRelatedShowState(relatedPhoto);
      }
    } catch (e) {
      _notificationBloc.add(NotificationShowEvent(e.toString()));
    }
  }
}

import 'dart:async';
import 'dart:collection';

import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_related_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc(this._photoRelatedBloc, this._notificationBloc)
      : super(PhotoInitial());

  PhotoRelatedBloc _photoRelatedBloc;
  NotificationBloc _notificationBloc;

  UnsplashRepository photoRepository = new UnsplashRepository();
  Photo currentPhoto;

  Stack<PhotoBlocHistoryItem> history = new Stack();

  @override
  Stream<PhotoState> mapEventToState(
    PhotoEvent event,
  ) async* {
    try {
      if (event is PhotoEventChoice) {
        yield PhotoLoading();
        //currentPhoto = await photoRepository.fetchPhoto(event.photo.id);
        currentPhoto = event.photo;
        _photoRelatedBloc.add(PhotoRelatedShowEvent(currentPhoto.id));
        yield PhotoLoaded(currentPhoto);
      }

      if (event is PhotoEventLike) {
        await photoRepository.likePhoto(event.id);
      }

      if (event is PhotoEventUnlike) {
        await photoRepository.unlikePhoto(event.id);
      }

      if (event is PhotoEventRelatedChoice) {
        yield PhotoLoading();
        currentPhoto = await photoRepository.fetchPhoto(event.id);
        _photoRelatedBloc.add(PhotoRelatedShowEvent(currentPhoto.id));
        yield PhotoRebuild(currentPhoto);
      }

      if (event is PhotoEventRebuild) {
        yield PhotoRebuild(currentPhoto);
      }

      if (event is PhotoEventHistoryBack) {
        /* var historyItem = history.pop();
      if (historyItem != null) {
        yield PhotoLoading();
        currentPhoto = historyItem.photo;
        relatedPhoto = historyItem.relatedPhoto;
        // ребилд
        yield PhotoRebuild(currentPhoto, relatedPhoto);
      }*/
      }
    } catch (e) {
      _notificationBloc.add(NotificationShowEvent(e.toString()));
    }
  }
}

class Stack<T> {
  final _stack = Queue<T>();

  void push(T element) {
    _stack.addLast(element);
  }

  T pop() {
    if (_stack.isEmpty) {
      return null;
    }
    T lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }
}

class PhotoBlocHistoryItem {
  Photo photo;
  List<Photo> relatedPhoto;
  PhotoBlocHistoryItem(this.photo, this.relatedPhoto);
}

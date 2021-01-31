import 'dart:async';

import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc() : super(PhotoInitial());
  UnsplashRepository photoRepository = new UnsplashRepository();
  Photo currentPhoto;

  @override
  Stream<PhotoState> mapEventToState(
    PhotoEvent event,
  ) async* {
    if (event is PhotoEventChoice) {
      yield PhotoLoading();
      currentPhoto =
          await photoRepository.fetchPhoto((event as PhotoEventChoice).id);
      yield PhotoLoaded(currentPhoto);
    }

    if (event is PhotoEventLike) {
      await photoRepository.likePhoto(event.id);
    }

    if (event is PhotoEventUnlike) {
      await photoRepository.unlikePhoto(event.id);
    }
  }
}

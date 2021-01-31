import 'dart:async';

import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc() : super(CollectionInitial());
  List<Photo> photo = [];
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  int _page = 1;
  int _perPage = 15;
  String collectionId;

  @override
  Stream<CollectionState> mapEventToState(
    CollectionEvent event,
  ) async* {
    if (event is CollectionChoiceEvent) {
      _page = 1;
      collectionId = event.id;
      yield CollectionLoading();
      photo = await unsplashRepository.fetchPhotoOfCollection(
          collectionId, _page, _perPage);
      yield CollectionLoaded(photo);
    }

    if (event is CollectionEventReload) {
      _page = 1;
      yield CollectionLoading();
      photo = await unsplashRepository.fetchPhotoOfCollection(
          collectionId, _page, _perPage);
      yield CollectionLoaded(photo);
    }

    if (event is CollectionEventAdd) {
      _page++;
      photo = [
        ...photo,
        ...await unsplashRepository.fetchPhotoOfCollection(
            collectionId, _page, _perPage)
      ];
      yield CollectionLoaded(photo);
    }
  }
}

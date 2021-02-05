import 'dart:async';

import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profile_collection_event.dart';
part 'profile_collection_state.dart';

class ProfileCollectionBloc
    extends Bloc<ProfileCollectionEvent, ProfileCollectionState> {
  ProfileCollectionBloc(this._notificationBloc)
      : super(ProfileCollectionInitial());
  NotificationBloc _notificationBloc;
  List<Collection> collections = [];
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  int _page = 1;
  int _perPage = 15;

  @override
  Stream<ProfileCollectionState> mapEventToState(
    ProfileCollectionEvent event,
  ) async* {
    try {
      if (event is ProfileCollectionLoadingEvent) {
        _page = 1;
        collections = await unsplashRepository.fetchUserCollections(
            event.user.username, _page, _perPage);
        yield ProfileCollectionLoadedState(collections);
      }

      if (event is ProfileCollectionAddEvent) {
        _page++;
        collections = [
          ...collections,
          ...await unsplashRepository.fetchUserCollections(
              event.user.username, _page, _perPage)
        ];
        yield ProfileCollectionLoadedState(collections);
      }

      if (event is ProfileCollectionReloadEvent) {
        collections.clear();
        _page = 1;
        add(ProfileCollectionLoadingEvent(event.user));
      }
    } catch (e) {
      _notificationBloc.add(NotificationShowEvent(e.toString()));
    }
  }
}

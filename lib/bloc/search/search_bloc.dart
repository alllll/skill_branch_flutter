import 'dart:async';

import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._notificationBloc) : super(SearchInitialState());
  NotificationBloc _notificationBloc;
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  String currentSearch;
  int totalPages;
  int page = 1;
  int perPage = 18;
  List<Photo> photo = [];

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    try {
      if (event is SearchPhotoEvent) {
        page = 1;
        yield SearchLoadingState();
        currentSearch = event.searchString;
        SearchResult result =
            await unsplashRepository.searchPhoto(currentSearch, page, perPage);
        totalPages = result.totalPages;
        photo = result.results;
        yield SearchShowResultState(photo);
      }

      if (event is SearchPhotoAddEvent) {
        page++;
        if (page <= totalPages) {
          SearchResult result = await unsplashRepository.searchPhoto(
              currentSearch, page, perPage);
          totalPages = result.totalPages;
          photo = [...photo, ...result.results];
          yield SearchShowResultState(photo);
        }
      }
      if (event is SearchPhotoReloadEvent) {
        page = 1;
        yield SearchLoadingState();
        SearchResult result =
            await unsplashRepository.searchPhoto(currentSearch, page, perPage);
        totalPages = result.totalPages;
        photo = result.results;
        yield SearchShowResultState(photo);
      }
    } catch (e) {
      _notificationBloc.add(NotificationShowEvent(e.toString()));
    }
  }
}

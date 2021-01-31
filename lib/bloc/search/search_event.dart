part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchPhotoEvent extends SearchEvent {
  String searchString;
  SearchPhotoEvent(this.searchString) : super();

  @override
  List<Object> get props => [searchString];
}

class SearchPhotoAddEvent extends SearchEvent {
  SearchPhotoAddEvent() : super();

  @override
  List<Object> get props => [];
}

class SearchPhotoReloadEvent extends SearchEvent {
  SearchPhotoReloadEvent() : super();

  @override
  List<Object> get props => [];
}

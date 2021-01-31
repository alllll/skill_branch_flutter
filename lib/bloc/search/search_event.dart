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
  String searchString;
  SearchPhotoAddEvent(this.searchString) : super();

  @override
  List<Object> get props => [searchString];
}

class SearchPhotoReloadEvent extends SearchEvent {
  String searchString;
  SearchPhotoReloadEvent(this.searchString) : super();

  @override
  List<Object> get props => [searchString];
}

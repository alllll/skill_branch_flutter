part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitialState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {}

class SearchShowResultState extends SearchState {
  List<Photo> photo;
  SearchShowResultState(this.photo) : super();
  @override
  List<Object> get props => [photo];
}

part of 'collection_bloc.dart';

@immutable
abstract class CollectionState extends Equatable {}

class CollectionInitial extends CollectionState {
  @override
  List<Object> get props => [];
}

class CollectionLoading extends CollectionState {
  @override
  List<Object> get props => [];
}

class CollectionLoaded extends CollectionState {
  final List<Photo> photo;
  CollectionLoaded(this.photo);
  @override
  List<Object> get props => [photo];
}

class CollectionReloadedState extends CollectionState {
  final List<Photo> photo;
  CollectionReloadedState(this.photo);
  @override
  List<Object> get props => [photo];
}

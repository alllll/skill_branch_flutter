part of 'photo_related_bloc.dart';

abstract class PhotoRelatedState extends Equatable {
  const PhotoRelatedState();

  @override
  List<Object> get props => [];
}

class PhotoRelatedInitial extends PhotoRelatedState {}

class PhotoRelatedLoadingState extends PhotoRelatedState {}

class PhotoRelatedShowState extends PhotoRelatedState {
  List<Photo> photo;

  PhotoRelatedShowState(this.photo);

  @override
  List<Object> get props => [photo];
}

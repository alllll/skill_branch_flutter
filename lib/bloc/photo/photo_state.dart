part of 'photo_bloc.dart';

@immutable
abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final Photo photo;
  final List<Photo> relatedPhoto;

  PhotoLoaded(this.photo, this.relatedPhoto);
}

class PhotoRebuild extends PhotoState {
  final Photo photo;
  final List<Photo> relatedPhoto;
  PhotoRebuild(this.photo, this.relatedPhoto);
}

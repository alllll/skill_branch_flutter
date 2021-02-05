part of 'photo_bloc.dart';

@immutable
abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final Photo photo;

  PhotoLoaded(this.photo);
}

class PhotoRebuild extends PhotoState {
  final Photo photo;

  PhotoRebuild(this.photo);
}

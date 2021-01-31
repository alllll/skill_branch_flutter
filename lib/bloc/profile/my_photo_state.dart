part of 'my_photo_bloc.dart';

@immutable
abstract class MyPhotoState {}

class MyPhotoInitialState extends MyPhotoState {}

class MyPhotoLoadedState extends MyPhotoState {
  final List<Photo> photo;
  MyPhotoLoadedState(this.photo);
}

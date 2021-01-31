part of 'my_photo_bloc.dart';

@immutable
abstract class MyPhotoEvent {}

class MyPhotoLoadingEvent extends MyPhotoEvent {
  User user;
  MyPhotoLoadingEvent(this.user);
}

class MyPhotoAddEvent extends MyPhotoEvent {
  User user;
  MyPhotoAddEvent(this.user);
}

class MyPhotoReloadEvent extends MyPhotoEvent {
  User user;
  MyPhotoReloadEvent(this.user);
}

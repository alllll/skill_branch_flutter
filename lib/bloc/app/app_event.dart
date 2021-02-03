part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class AppPhotoLikeEvent extends AppEvent {
  String photoId;
  AppPhotoLikeEvent(this.photoId);
}

class AppPhotoUnlikeEvent extends AppEvent {
  String photoId;
  AppPhotoUnlikeEvent(this.photoId);
}

class AppRebuildEvent extends AppEvent {}

class AppReloadEvent extends AppEvent {}

part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppNotificationState extends AppState {
  String text;
  AppNotificationState(this.text);
}

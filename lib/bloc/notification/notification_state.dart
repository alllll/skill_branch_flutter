part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationShowState extends NotificationState {
  String text;
  NotificationShowState(this.text);

  @override
  List<Object> get props => [text];
}

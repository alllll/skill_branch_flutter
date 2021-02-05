part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationShowEvent extends NotificationEvent {
  String text;
  NotificationShowEvent(this.text);

  @override
  List<Object> get props => [text];
}

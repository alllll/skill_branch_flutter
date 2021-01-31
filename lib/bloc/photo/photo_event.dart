part of 'photo_bloc.dart';

@immutable
abstract class PhotoEvent {}

class PhotoEventChoice extends PhotoEvent {
  String id;
  PhotoEventChoice(this.id);
}

class PhotoEventLike extends PhotoEvent {
  String id;
  PhotoEventLike(this.id);
}

class PhotoEventUnlike extends PhotoEvent {
  String id;
  PhotoEventUnlike(this.id);
}

class PhotoEventRelatedChoice extends PhotoEvent {
  String id;
  PhotoEventRelatedChoice(this.id);
}

class PhotoEventHistoryBack extends PhotoEvent {}

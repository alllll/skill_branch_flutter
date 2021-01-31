part of 'collection_bloc.dart';

@immutable
abstract class CollectionEvent {}

class CollectionChoiceEvent extends CollectionEvent {
  String id;
  CollectionChoiceEvent(this.id);
}

class CollectionEventReload extends CollectionEvent {}

class CollectionEventAdd extends CollectionEvent {}

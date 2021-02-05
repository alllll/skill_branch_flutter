part of 'photo_related_bloc.dart';

abstract class PhotoRelatedEvent extends Equatable {
  const PhotoRelatedEvent();

  @override
  List<Object> get props => [];
}

class PhotoRelatedShowEvent extends PhotoRelatedEvent {
  String id;

  PhotoRelatedShowEvent(this.id);

  @override
  List<Object> get props => [id];
}

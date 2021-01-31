part of 'photo_list_bloc.dart';

@immutable
abstract class PhotoListState extends Equatable {
  const PhotoListState();
  @override
  List<Object> get props => [];
}

class PhotoListInitial extends PhotoListState {}

class PhotoListLoaded extends PhotoListState {
  final List<Photo> photo;
  final DateTime date;
  PhotoListLoaded(this.photo, this.date) : super();

  @override
  List<Object> get props => [photo, date];
}

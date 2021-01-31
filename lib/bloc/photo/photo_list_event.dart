part of 'photo_list_bloc.dart';

@immutable
abstract class PhotoListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PhotoListAdd extends PhotoListEvent {}

class PhotoListReload extends PhotoListEvent {}

class PhotoListRebuild extends PhotoListEvent {}

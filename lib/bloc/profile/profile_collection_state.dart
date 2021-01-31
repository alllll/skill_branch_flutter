part of 'profile_collection_bloc.dart';

@immutable
abstract class ProfileCollectionState {}

class ProfileCollectionInitial extends ProfileCollectionState {}

class ProfileCollectionLoadedState extends ProfileCollectionState {
  final List<Collection> collections;
  ProfileCollectionLoadedState(this.collections);
}

import 'dart:async';

import 'package:FlutterGalleryApp/bloc/author/author_collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_like_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/my_photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_like_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  AuthorBloc(
      this._authorPhotoBloc, this._authorLikeBloc, this._authorCollectionBloc)
      : super(AuthorInitial());
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  User user;
  AuthorPhotoBloc _authorPhotoBloc;
  AuthorLikeBloc _authorLikeBloc;
  AuthorCollectionBloc _authorCollectionBloc;

  @override
  Stream<AuthorState> mapEventToState(
    AuthorEvent event,
  ) async* {
    if (event is AuthorChoiceEvent) {
      yield AuthorLoading();
      user = await unsplashRepository.fetchUserProfile(event.id);
      yield AuthorLoaded(user);
      _authorPhotoBloc.add(AuthorPhotoLoadingEvent(user));
      _authorLikeBloc.add(AuthorLikeLoadingEvent(user));
      _authorCollectionBloc.add(AuthorCollectionLoadingEvent(user));
    }
  }
}

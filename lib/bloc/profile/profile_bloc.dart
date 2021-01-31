import 'dart:async';

import 'package:FlutterGalleryApp/bloc/profile/my_photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_like_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/repository/unsplash_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  bool isAuthenticated;
  String accesKey = "kqm3H046orpfR6mStQgUb-o11rd1wE7ADjHJzQDHFwY";
  String secretKey = "81AC9W2iRL0Ac_I1DvTZkbpn466PbvGRWCQ6EuR68cE";
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  User user;
  MyPhotoBloc _myPhotoBloc;
  ProfileLikeBloc _profileLikeBloc;
  ProfileCollectionBloc _profileCollectionBloc;

  ProfileBloc(
      this._myPhotoBloc, this._profileLikeBloc, this._profileCollectionBloc)
      : super(ProfileInitialState()) {
    add(ProfileCheckAuth());
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileCheckAuth) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("token")) {
        String token = prefs.getString("token");
        if (token.isNotEmpty) {
          isAuthenticated = true;
          user = await unsplashRepository.fetchMyUserProfile();
          yield ProfileAuthenticatedState(user);
          _myPhotoBloc.add(MyPhotoLoadingEvent(user));
          _profileLikeBloc.add(ProfileLikeLoadingEvent(user));
          _profileCollectionBloc.add(ProfileCollectionLoadingEvent(user));
        }
      } else
        yield ProfileNoAutheticatedState();
    }

    if (event is ProfileAuthenticatedEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", event.token);
      isAuthenticated = true;
      User user = await unsplashRepository.fetchMyUserProfile();
      yield ProfileAuthenticatedState(user);
      _myPhotoBloc.add(MyPhotoLoadingEvent(user));
      _profileLikeBloc.add(ProfileLikeLoadingEvent(user));
    }

    if (event is ProfileLogoutEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      add(ProfileCheckAuth());
    }
  }
}

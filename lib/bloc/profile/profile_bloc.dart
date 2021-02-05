import 'dart:async';

import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
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
  NotificationBloc _notificationBloc;
  bool isAuthenticated;
  String accesKey = "kqm3H046orpfR6mStQgUb-o11rd1wE7ADjHJzQDHFwY";
  String secretKey = "81AC9W2iRL0Ac_I1DvTZkbpn466PbvGRWCQ6EuR68cE";
  UnsplashRepository unsplashRepository = new UnsplashRepository();
  User user;
  MyPhotoBloc _myPhotoBloc;
  ProfileLikeBloc _profileLikeBloc;
  ProfileCollectionBloc _profileCollectionBloc;

  ProfileBloc(this._myPhotoBloc, this._profileLikeBloc,
      this._profileCollectionBloc, this._notificationBloc)
      : super(ProfileInitialState()) {
    add(ProfileCheckAuth());
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (event is ProfileCheckAuth) {
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
        } else {
          isAuthenticated = false;
          user = null;
          yield ProfileNoAutheticatedState();
        }
      }

      if (event is ProfileAuthenticatedEvent) {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("token", event.token);
        isAuthenticated = true;
        user = await unsplashRepository.fetchMyUserProfile();
        yield ProfileAuthenticatedState(user);
        _myPhotoBloc.add(MyPhotoLoadingEvent(user));
        _profileLikeBloc.add(ProfileLikeLoadingEvent(user));
      }

      if (event is ProfileLogoutEvent) {
        prefs = await SharedPreferences.getInstance();
        prefs.remove("token").then((value) {
          if (value) {
            add(ProfileCheckAuth());
          }
        });
      }
    } catch (e) {
      _notificationBloc.add(NotificationShowEvent(e.toString()));
    }
  }
}

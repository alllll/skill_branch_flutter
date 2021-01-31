import 'dart:io';

import 'package:FlutterGalleryApp/bloc/app/app_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_like_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/collection/collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_list_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/my_photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_like_bloc.dart';
import 'package:FlutterGalleryApp/bloc/search/search_bloc.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/feed_screen.dart';
import 'package:FlutterGalleryApp/screens/home.dart';
import 'package:FlutterGalleryApp/screens/home_.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/profile/profile_bloc.dart';

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  PhotoListBloc _photoListBloc;
  PhotoBloc _photoBloc;
  MyPhotoBloc _myPhotoBloc;
  ProfileBloc _profileBloc;
  ProfileLikeBloc _profileLikeBloc;
  ProfileCollectionBloc _profileCollectionBloc;
  CollectionBloc _collectionBloc;
  NavigationBloc _navigationBloc;
  AuthorBloc _authorBloc;
  AuthorLikeBloc _authorLikeBloc;
  AuthorPhotoBloc _authorPhotoBloc;
  AuthorCollectionBloc _authorCollectionBloc;
  SearchBloc _searchBloc;

  AppBloc _appBloc;
  MyApp() {
    _photoListBloc = new PhotoListBloc();
    _photoBloc = new PhotoBloc();
    _myPhotoBloc = new MyPhotoBloc();
    _profileLikeBloc = new ProfileLikeBloc();
    _profileCollectionBloc = new ProfileCollectionBloc();
    _profileBloc =
        new ProfileBloc(_myPhotoBloc, _profileLikeBloc, _profileCollectionBloc);
    _collectionBloc = new CollectionBloc();
    _navigationBloc = new NavigationBloc(_navigatorKey);
    _authorLikeBloc = new AuthorLikeBloc();
    _authorCollectionBloc = new AuthorCollectionBloc();
    _authorPhotoBloc = new AuthorPhotoBloc();
    _authorBloc = new AuthorBloc(
        _authorPhotoBloc, _authorLikeBloc, _authorCollectionBloc);
    _searchBloc = SearchBloc();
    _appBloc = new AppBloc(
        _collectionBloc,
        _navigationBloc,
        _photoBloc,
        _photoListBloc,
        _profileBloc,
        _myPhotoBloc,
        _profileCollectionBloc,
        _profileLikeBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(create: (context) => _navigationBloc),
          BlocProvider<PhotoListBloc>(create: (context) => _photoListBloc),
          BlocProvider<PhotoBloc>(create: (context) => _photoBloc),
          BlocProvider<ProfileBloc>(create: (context) => _profileBloc),
          BlocProvider<MyPhotoBloc>(create: (context) => _myPhotoBloc),
          BlocProvider<ProfileLikeBloc>(create: (context) => _profileLikeBloc),
          BlocProvider<ProfileCollectionBloc>(
              create: (context) => _profileCollectionBloc),
          BlocProvider<CollectionBloc>(create: (context) => _collectionBloc),
          BlocProvider<AuthorBloc>(create: (context) => _authorBloc),
          BlocProvider<AuthorPhotoBloc>(create: (context) => _authorPhotoBloc),
          BlocProvider<AuthorCollectionBloc>(
              create: (context) => _authorCollectionBloc),
          BlocProvider<AuthorLikeBloc>(create: (context) => _authorLikeBloc),
          BlocProvider<SearchBloc>(create: (context) => _searchBloc),
          BlocProvider<AppBloc>(create: (context) => _appBloc)
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          title: "Skillbranch app",
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: buildAppTextTheme()),
          home: Home(),
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == '/fullScreenImage') {
              final route = FullScreenImage();
              if (Platform.isAndroid) {
                return MaterialPageRoute(builder: (context) => route);
              } else if (Platform.isIOS) {
                return CupertinoPageRoute(builder: (context) => route);
              }
            }
          },
        ));
  }
}

/*
class MyApp extends StatelessWidget {
  final Stream<ConnectivityResult> onConnectivityChanged;

  const MyApp(this.onConnectivityChanged, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: buildAppTextTheme()),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/fullScreenImage') {
          FullScreenImageArguments args =
              settings.arguments as FullScreenImageArguments;
          final route = FullScreenImage(
            photo: args.photo,
            altDescription: args.altDescription,
            userName: args.userName,
            name: args.name,
            userPhoto: args.userPhoto,
            heroTag: args.heroTag,
            key: args.key,
          );
          if (Platform.isAndroid) {
            return MaterialPageRoute(
                builder: (context) => route, settings: args.routeSettings);
          } else if (Platform.isIOS) {
            return CupertinoPageRoute(
                builder: (context) => route, settings: args.routeSettings);
          }
        }
      },
      home: BlocProvider(
        create: (_) => NavigationBloc(),
        child:

      ),
    );
  }
}
*/

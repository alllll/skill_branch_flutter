import 'dart:async';
import 'dart:io';

import 'package:FlutterGalleryApp/bloc/app/app_bloc.dart';
import 'package:FlutterGalleryApp/bloc/app/connectivity_bloc.dart';
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
import 'package:FlutterGalleryApp/main.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/feed_screen.dart';
import 'package:FlutterGalleryApp/screens/home.dart';
import 'package:FlutterGalleryApp/screens/home_.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/profile/profile_bloc.dart';

class MyApp extends StatefulWidget {
  final Connectivity _connectivity;
  Stream<ConnectivityResult> onConnectivityChanged;

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
  ConnectivityBloc _connectivityBloc;

  AppBloc _appBloc;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  MyApp(this._connectivity, {Key key}) : super(key: key) {
    onConnectivityChanged = _connectivity.onConnectivityChanged;
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
    _connectivityBloc = ConnectivityBloc();
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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription subscription;
  var connectivityOverlay = ConnectivityOverlay();

  void initState() {
    super.initState();
    widget._connectivity.checkConnectivity().then((result) {
      switch (result) {
        case ConnectivityResult.wifi:
          widget._connectivityBloc.add(ConnectivityOnEvent());
          break;
        case ConnectivityResult.mobile:
          widget._connectivityBloc.add(ConnectivityOnEvent());
          break;
        case ConnectivityResult.none:
          widget._connectivityBloc.add(ConnectivityOffEvent());
          break;
      }
    });

    subscription =
        widget.onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
          widget._connectivityBloc.add(ConnectivityOnEvent());
          break;
        case ConnectivityResult.mobile:
          widget._connectivityBloc.add(ConnectivityOnEvent());
          break;
        case ConnectivityResult.none:
          widget._connectivityBloc.add(ConnectivityOffEvent());
          break;
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(
              create: (context) => widget._navigationBloc),
          BlocProvider<PhotoListBloc>(
              create: (context) => widget._photoListBloc),
          BlocProvider<PhotoBloc>(create: (context) => widget._photoBloc),
          BlocProvider<ProfileBloc>(create: (context) => widget._profileBloc),
          BlocProvider<MyPhotoBloc>(create: (context) => widget._myPhotoBloc),
          BlocProvider<ProfileLikeBloc>(
              create: (context) => widget._profileLikeBloc),
          BlocProvider<ProfileCollectionBloc>(
              create: (context) => widget._profileCollectionBloc),
          BlocProvider<CollectionBloc>(
              create: (context) => widget._collectionBloc),
          BlocProvider<AuthorBloc>(create: (context) => widget._authorBloc),
          BlocProvider<AuthorPhotoBloc>(
              create: (context) => widget._authorPhotoBloc),
          BlocProvider<AuthorCollectionBloc>(
              create: (context) => widget._authorCollectionBloc),
          BlocProvider<AuthorLikeBloc>(
              create: (context) => widget._authorLikeBloc),
          BlocProvider<SearchBloc>(create: (context) => widget._searchBloc),
          BlocProvider<ConnectivityBloc>(
              create: (context) => widget._connectivityBloc),
          BlocProvider<AppBloc>(create: (context) => widget._appBloc)
        ],
        child: MaterialApp(
          navigatorKey: widget._navigatorKey,
          debugShowCheckedModeBanner: false,
          title: "Skillbranch app",
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: buildAppTextTheme()),
          home: BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, state) {
              if (state is ConnectivityOnState) {
                return Home();
              }
              if (state is ConnectivityOffState) {
                return NoInternetScreen();
              }
              if (state is ConnectivityInitialState) {
                return CircularProgressIndicator();
              }
              widget._connectivity.checkConnectivity();
            },
          ),
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

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AntDesign.wifi, size: 100, color: AppColors.grayChateau),
            SizedBox(height: 10),
            Text("There was an error loading the feed"),
          ],
        ),
      ),
    );
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

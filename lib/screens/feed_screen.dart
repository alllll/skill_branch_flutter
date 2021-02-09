import 'package:FlutterGalleryApp/bloc/app/app_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_event.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_list_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:FlutterGalleryApp/widgets/trinity_circular_progress.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

const String kFlutterDash =
    "https://flutter.dev/assets/404/dash_nest-c64796b59b65042a2b40fae5764c13b7477a592db79eaf04c86298dcb75b78ea.png";

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoListBloc, PhotoListState>(
        builder: (context, state) {
      if (state is PhotoListInitial) {
        return Center(
          child: TrinityCircularProgress(),
        );
      }
      if (state is PhotoListLoaded) {
        return _listPhoto(context, state.photo, _controller);
      }
      return Center(child: TrinityCircularProgress());
    });
  }
}

/*
  return BlocListener<PhotoBloc, PhotoState>(
      listener: (context, state) {
        if (state is PhotoLoaded)
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return FullScreenImage();
          }));
      },
      child:
*/
_listPhoto(context, List<Photo> photo, ScrollController controller) {
  return LazyLoadScrollView(
    onEndOfPage: () {
      BlocProvider.of<PhotoListBloc>(context).add(PhotoListAdd());
    },
    child: RefreshIndicator(
      onRefresh: () async {
        //BlocProvider.of<PhotoListBloc>(context).add(PhotoListReload());
        print("refreshing");
        BlocProvider.of<PhotoListBloc>(context).add(PhotoListReload());
        return null;
      },
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              // Colors.purple,
              // Colors.transparent,
              Colors.transparent,
              Colors.white
            ],
            stops: [
              // 0.0,
              //  0.1,
              0.94,
              1
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView.builder(
            controller: controller,
            key: new PageStorageKey("feed_list"),
            itemCount: photo.length + 1,
            itemBuilder: (context, i) {
              if (i < photo.length)
                return _buildItem(context, photo[i], i);
              else
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 200, horizontal: 50),
                  child: Center(child: TrinityCircularProgress()),
                );
            }),
      ),
    ),
  );
}

/*
class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _FeedState();
  }
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Column(children: <Widget>[
                _buildItem(index.toString()),
                Divider(
                  thickness: 2,
                  color: AppColors.mercury,
                )
              ]);
            }));
  }
*/
Widget _buildItem(BuildContext context, Photo photo, int index) {
  return Column(
    key: UniqueKey(),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      GestureDetector(
        onTap: () {
          BlocProvider.of<PhotoBloc>(context).add(PhotoEventChoice(photo));
          /* BlocProvider.of<NavigationBloc>(context)
              .add(NavigationFullScreenPhotoEvent());*/
        },
        child: Hero(
          tag: photo.id,
          child: PhotoW(
            photo: photo,
          ),
        ),
      ),
      _buildPhotoMeta(context, photo),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          photo.description ?? "",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: AppColors.grayChateau),
        ),
      ),
      Divider(
        thickness: 2,
        color: AppColors.mercury,
      )
    ],
  );
}

Widget _buildPhotoMeta(BuildContext context, Photo photo) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                  onTap: () => BlocProvider.of<AuthorBloc>(context)
                      .add(AuthorChoiceEvent(photo.user.username)),
                  child: UserAvatar(photo.user.profileImage.small, 50)),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () => BlocProvider.of<AuthorBloc>(context)
                    .add(AuthorChoiceEvent(photo.user.username)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(photo.user.name,
                        style: Theme.of(context).textTheme.headline2),
                    Text("@" + photo.user.username,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(color: AppColors.manatee))
                  ],
                ),
              )
            ],
          ),
          LikeButton(
              photo.likes,
              photo.likedByUser,
              () => {
                    BlocProvider.of<AppBloc>(context)
                        .add(AppPhotoLikeEvent(photo.id))
                  },
              () => {
                    BlocProvider.of<AppBloc>(context)
                        .add(AppPhotoUnlikeEvent(photo.id))
                  })
        ],
      ));
}

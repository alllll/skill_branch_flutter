import 'dart:typed_data';

import 'package:FlutterGalleryApp/bloc/app/app_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_event.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_related_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/widgets/claim_bottom_sheet.dart';
import 'package:FlutterGalleryApp/widgets/trinity_circular_progress.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage() : super();

  @override
  State<StatefulWidget> createState() {
    return _FullScreenImageState();
  }
}

class _FullScreenImageState extends State<FullScreenImage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: BlocBuilder<PhotoBloc, PhotoState>(builder: (context, state) {
          if (state is PhotoLoading) return Container();
          if (state is PhotoLoaded) {
            _controller = AnimationController(
                duration: const Duration(milliseconds: 1500), vsync: this);
            _controller.forward();
            return _buildBody(state);
          }
          if (state is PhotoRebuild) {
            _controller = AnimationController(
                duration: const Duration(milliseconds: 1500), vsync: this);
            _controller.forward();
            return _rebuildBody(state);
          }
        }));
    /*
    return BlocBuilder<PhotoBloc, PhotoState>(builder: (context, state) {
      // if (state is PhotoLoading) return CircularProgressIndicator();
      if (state is PhotoLoading) return Container();
      if (state is PhotoLoaded || state is PhotoRebuild) {
        AnimationController _controller = AnimationController(
            duration: const Duration(milliseconds: 1500), vsync: this);
        _controller.forward();

        return Scaffold(
            appBar: _buildAppBar(),
            body: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: (state as PhotoLoaded).photo.id,
                      child: PhotoW(
                        photoLink: (state as PhotoLoaded).photo.urls.small,
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          (state as PhotoLoaded).photo.description ?? "",
                          maxLines: 3,
                          style: Theme.of(context).textTheme.headline3,
                          overflow: TextOverflow.ellipsis,
                        )),
                    // _buildPhotoMeta(),
                    AnimationPhotoMeta(
                      controller: _controller.view,
                      userName: (state as PhotoLoaded).photo.user.username,
                      name: (state as PhotoLoaded).photo.user.name,
                      userPhoto:
                          (state as PhotoLoaded).photo.user.profileImage.large,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LikeButton(
                              (state as PhotoLoaded).photo.likes,
                              (state as PhotoLoaded).photo.likedByUser,
                              () => BlocProvider.of<AppBloc>(context).add(
                                  AppPhotoLikeEvent(
                                      (state as PhotoLoaded).photo.id)),
                              () => BlocProvider.of<AppBloc>(context).add(
                                  AppPhotoUnlikeEvent(
                                      (state as PhotoLoaded).photo.id))),
                          SizedBox(
                            width: 10,
                          ),
                          _buildButton("Save", () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Downloading photos"),
                                      content: Text(
                                          "Are you sure you want to download a photo?"),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              _save(
                                                      (state as PhotoLoaded)
                                                          .photo
                                                          .urls
                                                          .full,
                                                      "${(state as PhotoLoaded).photo.id}.jpg")
                                                  .then((value) =>
                                                      Navigator.of(context)
                                                          .pop());
                                            },
                                            child: Text("Download")),
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("Close"))
                                      ],
                                    ));
                          }),
                          _buildButton("Visit", () async {
                            await launch(
                              (state as PhotoLoaded).photo.urls.full,
                              forceSafariVC: false,
                              forceWebView: false,
                            );
                          })
                        ],
                      ),
                    ),
                    GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: (state as PhotoLoaded).relatedPhoto.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<PhotoBloc>(context).add(
                                  PhotoEventRelatedChoice((state as PhotoLoaded)
                                      .relatedPhoto[i]
                                      .id));
                            },
                            child: Hero(
                              tag: (state as PhotoLoaded).relatedPhoto[i].id,
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  fit: BoxFit.cover,
                                  imageUrl: (state as PhotoLoaded)
                                      .relatedPhoto[i]
                                      .urls
                                      .small,
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                  //related photo
                ),
              );
            }));
      }
    });
    */
  }

  Widget _buildBody(PhotoLoaded state) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: (state).photo.id,
              child: PhotoW(
                photo: state.photo,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  (state).photo.description ?? "",
                  maxLines: 3,
                  style: Theme.of(context).textTheme.headline3,
                  overflow: TextOverflow.ellipsis,
                )),
            // _buildPhotoMeta(),
            AnimationPhotoMeta(
              controller: _controller.view,
              userName: (state).photo.user.username,
              name: (state).photo.user.name,
              userPhoto: (state).photo.user.profileImage.large,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LikeButton(
                      (state).photo.likes,
                      (state).photo.likedByUser,
                      () => BlocProvider.of<AppBloc>(context)
                          .add(AppPhotoLikeEvent((state).photo.id)),
                      () => BlocProvider.of<AppBloc>(context)
                          .add(AppPhotoUnlikeEvent((state).photo.id))),
                  SizedBox(
                    width: 10,
                  ),
                  _buildButton("Save", () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Downloading photos"),
                              content: Text(
                                  "Are you sure you want to download a photo?"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      _save((state).photo.urls.full,
                                              "${(state).photo.id}.jpg")
                                          .then((value) =>
                                              Navigator.of(context).pop());
                                    },
                                    child: Text("Download")),
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text("Close"))
                              ],
                            ));
                  }),
                  _buildButton("Visit", () async {
                    await launch(
                      (state).photo.urls.full,
                      forceSafariVC: false,
                      forceWebView: false,
                    );
                  })
                ],
              ),
            ),
            BlocBuilder<PhotoRelatedBloc, PhotoRelatedState>(
              builder: (context, state) {
                if (state is PhotoRelatedLoadingState) {
                  return Center(
                    child: TrinityCircularProgress(),
                  );
                }
                if (state is PhotoRelatedShowState) {
                  return GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: state.photo.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<PhotoBloc>(context).add(
                                PhotoEventRelatedChoice((state).photo[i].id));
                          },
                          child: Hero(
                            tag: (state).photo[i].id,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: CachedNetworkImage(
                                placeholder: (context, url) {
                                  return AspectRatio(
                                    aspectRatio: state.photo[i].width /
                                        state.photo[i].height,
                                    child: BlurHash(
                                      hash: state.photo[i].blurHash != null
                                          ? state.photo[i].blurHash
                                          : "L0JkyE-;j[.8_3ayogWBofaxayay",
                                    ),
                                  );
                                },
                                fit: BoxFit.cover,
                                imageUrl: (state).photo[i].urls.small,
                              ),
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _rebuildBody(PhotoRebuild state) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: state.photo.id,
              child: PhotoW(
                photo: state.photo,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  state.photo.description ?? "",
                  maxLines: 3,
                  style: Theme.of(context).textTheme.headline3,
                  overflow: TextOverflow.ellipsis,
                )),
            // _buildPhotoMeta(),
            AnimationPhotoMeta(
              controller: _controller.view,
              userName: state.photo.user.username,
              name: state.photo.user.name,
              userPhoto: state.photo.user.profileImage.large,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LikeButton(
                    state.photo.likes,
                    state.photo.likedByUser,
                    () => BlocProvider.of<AppBloc>(context)
                        .add(AppPhotoLikeEvent(state.photo.id)),
                    () => BlocProvider.of<AppBloc>(context)
                        .add(AppPhotoUnlikeEvent(state.photo.id)),
                    key: UniqueKey(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  _buildButton("Save", () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Downloading photos"),
                              content: Text(
                                  "Are you sure you want to download a photo?"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      _save(state.photo.urls.full,
                                              "${state.photo.id}.jpg")
                                          .then((value) =>
                                              Navigator.of(context).pop());
                                    },
                                    child: Text("Download")),
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text("Close"))
                              ],
                            ));
                  }),
                  _buildButton("Visit", () async {
                    await launch(
                      state.photo.urls.full,
                      forceSafariVC: false,
                      forceWebView: false,
                    );
                  })
                ],
              ),
            ),
            BlocBuilder<PhotoRelatedBloc, PhotoRelatedState>(
              builder: (context, state) {
                if (state is PhotoRelatedLoadingState) {
                  return Center(
                    child: TrinityCircularProgress(),
                  );
                }
                if (state is PhotoRelatedShowState) {
                  return GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: state.photo.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<PhotoBloc>(context).add(
                                PhotoEventRelatedChoice((state).photo[i].id));
                          },
                          child: Hero(
                            tag: (state).photo[i].id,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: CachedNetworkImage(
                                placeholder: (context, url) {
                                  return AspectRatio(
                                    aspectRatio: state.photo[i].width /
                                        state.photo[i].height,
                                    child: BlurHash(
                                      hash: state.photo[i].blurHash != null
                                          ? state.photo[i].blurHash
                                          : "L0JkyE-;j[.8_3ayogWBofaxayay",
                                    ),
                                  );
                                },
                                fit: BoxFit.cover,
                                imageUrl: (state).photo[i].urls.small,
                              ),
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ],
        ),
      );
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.white,
      actions: [],
      leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppColors.grayChateau),
          onPressed: () {
            Navigator.pop(context);
            BlocProvider.of<AppBloc>(context).add(AppRebuildEvent());
          }),
      title: Text("Photo",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildButton(String text, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
          alignment: Alignment.center,
          width: 120,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.dodgerBlue,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(text,
              style: Theme.of(context).textTheme.headline1.copyWith(
                  color: AppColors.white, fontWeight: FontWeight.bold))),
    );
  }
/*
  Widget _buildPhotoMeta(Photo photo) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                UserAvatar(
                    'https://skill-branch.ru/img/speakers/Adechenko.jpg'),
                SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(photo.user.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text("@" + photo.user.username,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.manatee))
                  ],
                )
              ],
            ),
          ],
        ));
  }*/
}

class AnimationPhotoMeta extends StatelessWidget {
  AnimationPhotoMeta(
      {Key key, this.controller, this.userName, this.name, this.userPhoto})
      : opacityUserAvatar = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                curve: Interval(0.0, 0.5, curve: Curves.ease),
                parent: controller)),
        opacityColumn = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0.5, 1, curve: Curves.ease))),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacityUserAvatar;
  final Animation<double> opacityColumn;
  final String userName;
  final String name;
  final String userPhoto;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Opacity(
                  opacity: opacityUserAvatar.value,
                  child: UserAvatar(userPhoto, 50),
                ),
                SizedBox(width: 6),
                Opacity(
                  opacity: opacityColumn.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(name,
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text("@" + userName,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.manatee))
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

Future<dynamic> _save(String path, String name) async {
  var response =
      await Dio().get(path, options: Options(responseType: ResponseType.bytes));
  return await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
      name: name);
}

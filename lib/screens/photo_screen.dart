import 'package:FlutterGalleryApp/bloc/app/app_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_event.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/widgets/claim_bottom_sheet.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage() : super();

  @override
  State<StatefulWidget> createState() {
    return _FullScreenImageState();
  }
}

class _FullScreenImageState extends State<FullScreenImage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(builder: (context, state) {
      // if (state is PhotoLoading) return CircularProgressIndicator();
      if (state is PhotoLoading) return Container();
      if (state is PhotoLoaded) {
        AnimationController _controller = AnimationController(
            duration: const Duration(milliseconds: 1500), vsync: this);
        _controller.forward();

        return Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: state.photo.id,
                  child: PhotoW(
                    photoLink: state.photo.urls.small,
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
                              .add(AppPhotoUnlikeEvent(state.photo.id))),
                      SizedBox(
                        width: 10,
                      ),
                      _buildButton("Save", () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Downloading photos"),
                                  content: Text(
                                      "Are you sure you want to upload a photo?"),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          GallerySaver.saveImage(
                                                  state.photo.urls.full)
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
                        OverlayState overlayState = Overlay.of(context);
                        OverlayEntry overlayEntry =
                            OverlayEntry(builder: (context) {
                          return Positioned(
                              top: MediaQuery.of(context).viewInsets.top + 50,
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    padding:
                                        EdgeInsets.fromLTRB(16, 10, 16, 10),
                                    decoration: BoxDecoration(
                                        color: AppColors.mercury,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text("SkillBranch"),
                                  ),
                                ),
                              ));
                        });
                        overlayState.insert(overlayEntry);
                        await Future.delayed(Duration(seconds: 1));
                        overlayEntry.remove();
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.white,
      actions: [
        IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.grayChateau),
            onPressed: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  context: context,
                  builder: (context) {
                    return ClaimBottomSheet();
                  });
            }),
      ],
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

/*
class FullScreenImageArguments {
  FullScreenImageArguments(
      {this.altDescription,
      this.userName,
      this.photo,
      this.name,
      this.heroTag,
      this.userPhoto,
      this.key,
      this.routeSettings});

  final String altDescription;
  final String userName;
  final String photo;
  final String name;
  final String heroTag;
  final String userPhoto;
  final Key key;
  final RouteSettings routeSettings;
}

class FullScreenImage extends StatefulWidget {
  FullScreenImage(
      {this.altDescription,
      this.name,
      this.photo,
      this.userName,
      Key key,
      this.heroTag,
      this.userPhoto})
      : super(key: key);
  final String altDescription;
  final String userName;
  final String photo;
  final String name;
  final String heroTag;
  final String userPhoto;

  @override
  State<StatefulWidget> createState() {
    return _FullScreenImageState();
  }
}

class _FullScreenImageState extends State<FullScreenImage>
    with TickerProviderStateMixin {
  String altDescription;
  String photo;
  String userName;
  String name;
  String heroTag;
  String userPhoto;
  AnimationController _controller;

  @override
  void initState() {
    altDescription = widget.altDescription != null ? widget.altDescription : "";
    photo = widget.photo != null
        ? widget.photo
        : "https://flutter.dev/assets/404/dash_nest-c64796b59b65042a2b40fae5764c13b7477a592db79eaf04c86298dcb75b78ea.png";
    userName = widget.userName != null ? widget.userName : "";
    name = widget.name != null ? widget.name : "";
    heroTag = widget.heroTag != null ? widget.heroTag : "";
    userPhoto = widget.userPhoto != null
        ? widget.userPhoto
        : "https://skill-branch.ru/img/speakers/Adechenko.jpg";
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: null);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: heroTag,
            child: PhotoW(
              photoLink: photo,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                altDescription,
                maxLines: 3,
                style: Theme.of(context).textTheme.headline3,
                overflow: TextOverflow.ellipsis,
              )),
          // _buildPhotoMeta(),
          AnimationPhotoMeta(
            controller: _controller.view,
            userName: userName,
            name: name,
            userPhoto: userPhoto,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LikeButton(10, true),
                SizedBox(
                  width: 10,
                ),
                _buildButton("Save", () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Downloading photos"),
                            content: Text(
                                "Are you sure you want to upload a photo?"),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    GallerySaver.saveImage(photo).then(
                                        (value) => Navigator.of(context).pop());
                                  },
                                  child: Text("Download")),
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Close"))
                            ],
                          ));
                }),
                _buildButton("Visit", () async {
                  OverlayState overlayState = Overlay.of(context);
                  OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
                    return Positioned(
                        top: MediaQuery.of(context).viewInsets.top + 50,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                              decoration: BoxDecoration(
                                  color: AppColors.mercury,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text("SkillBranch"),
                            ),
                          ),
                        ));
                  });
                  overlayState.insert(overlayEntry);
                  await Future.delayed(Duration(seconds: 1));
                  overlayEntry.remove();
                })
              ],
            ),
          )
        ],
      ),
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

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.white,
      actions: [
        IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.grayChateau),
            onPressed: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  context: context,
                  builder: (context) {
                    return ClaimBottomSheet();
                  });
            }),
      ],
      leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppColors.grayChateau),
          onPressed: () => Navigator.pop(context, false)),
      title: Text("Photo",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPhotoMeta() {
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
                    Text(name,
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text("@" + userName,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.manatee))
                  ],
                )
              ],
            ),
          ],
        ));
  }
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
                  child: UserAvatar(userPhoto),
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
*/

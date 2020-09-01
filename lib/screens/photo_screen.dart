import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage(
      {this.altDescription,
      this.name,
      this.photo,
      this.userName,
      Key key,
      this.heroTag})
      : super(key: key);
  final String altDescription;
  final String userName;
  final String photo;
  final String name;
  final String heroTag;

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
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: AppColors.grayChateau),
            onPressed: () => Navigator.pop(context, false)),
        title: Text("Photo", style: AppStyles.h1Black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: heroTag,
            child: Photo(
              photoLink: photo,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                altDescription,
                maxLines: 3,
                style: AppStyles.h3,
                overflow: TextOverflow.ellipsis,
              )),
          // _buildPhotoMeta(),
          AnimationPhotoMeta(
            controller: _controller.view,
            userName: userName,
            name: name,
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.dodgerBlue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text("Save",
                              style: AppStyles.h1Black
                                  .copyWith(color: AppColors.white)))),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.dodgerBlue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text("Visit",
                              style: AppStyles.h1Black
                                  .copyWith(color: AppColors.white)))),
                ),
              ],
            ),
          )
        ],
      ),
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
                    Text(name, style: AppStyles.h1Black),
                    Text("@" + userName,
                        style: AppStyles.h5Black
                            .copyWith(color: AppColors.manatee))
                  ],
                )
              ],
            ),
          ],
        ));
  }
}

class AnimationPhotoMeta extends StatelessWidget {
  AnimationPhotoMeta({Key key, this.controller, this.userName, this.name})
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
                  child: UserAvatar(
                      'https://skill-branch.ru/img/speakers/Adechenko.jpg'),
                ),
                SizedBox(width: 6),
                Opacity(
                  opacity: opacityColumn.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(name, style: AppStyles.h1Black),
                      Text("@" + userName,
                          style: AppStyles.h5Black
                              .copyWith(color: AppColors.manatee))
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

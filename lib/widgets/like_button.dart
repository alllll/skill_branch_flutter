import 'package:FlutterGalleryApp/res/res.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  LikeButton(this.likeCount, this.isLiked, this.onLike, this.onUnlike,
      {Key key})
      : super(key: key);

  final int likeCount;
  final bool isLiked;
  Function onLike;
  Function onUnlike;
  @override
  State<StatefulWidget> createState() {
    return _LikeButtonState();
  }
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked;
  int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    likeCount = widget.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!isLiked)
          widget.onLike();
        else
          widget.onUnlike();
        setState(() {
          isLiked = !isLiked;
          if (isLiked) {
            likeCount++;
          } else {
            likeCount--;
          }
        });
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Icon(isLiked ? AppIcons.like_fill : AppIcons.like,
                  color: isLiked ? AppColors.dodgerBlue : AppColors.black),
              SizedBox(width: 4.21),
              Text(
                likeCount.toString(),
                style: TextStyle(
                    color: isLiked ? AppColors.dodgerBlue : AppColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

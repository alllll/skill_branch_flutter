import 'dart:typed_data';

import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class PhotoW extends StatelessWidget {
  final Photo photo;
  PhotoW({Key key, this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BlurHash.decode(photo.blurHash, photo.width, photo.height);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(17)),
        child: Container(
          color: AppColors.grayChateau,
          child: CachedNetworkImage(
            imageUrl: photo.urls.small,
            placeholder: (context, url) {
              return AspectRatio(
                aspectRatio: photo.width / photo.height,
                child: BlurHash(
                  hash: photo.blurHash,
                ),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

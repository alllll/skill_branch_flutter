import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar(this.avatarLink, this.radius);

  final String avatarLink;
  final int radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius.toDouble()),
        child: CachedNetworkImage(
            imageUrl: avatarLink,
            width: radius - 10.0,
            height: radius - 10.0,
            fit: BoxFit.fill));
  }
}

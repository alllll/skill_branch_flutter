import 'package:FlutterGalleryApp/bloc/collection/collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_event.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:FlutterGalleryApp/widgets/claim_bottom_sheet.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class CollectionScreen extends StatelessWidget {
  CollectionScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<PhotoBloc, PhotoState>(
        listener: (context, state) {
          /*    if (state is PhotoLoaded)
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return FullScreenImage();
            }));*/
        },
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: BlocBuilder<CollectionBloc, CollectionState>(
              builder: (context, state) {
            if (state is CollectionLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is CollectionLoaded) {
              return _listPhoto(context, state.photo);
            }
            return Center(child: CircularProgressIndicator());
          }),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
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
          onPressed: () => Navigator.pop(context)),
      title: Text("Photo",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontWeight: FontWeight.bold)),
    );
  }

  _listPhoto(context, List<Photo> photo) {
    return LazyLoadScrollView(
      onEndOfPage: () {
        BlocProvider.of<CollectionBloc>(context).add(CollectionEventAdd());
      },
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<CollectionBloc>(context).add(CollectionEventReload());
        },
        child: ListView.builder(
            itemCount: photo.length,
            itemBuilder: (context, i) {
              return _buildItem(context, photo[i]);
            }),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Photo photo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            BlocProvider.of<PhotoBloc>(context).add(PhotoEventChoice(photo.id));
            /* BlocProvider.of<NavigationBloc>(context)
              .add(NavigationFullScreenPhotoEvent());*/
          },
          child: Hero(
            tag: photo.id,
            child: PhotoW(
              photoLink: photo.urls.small,
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
                UserAvatar(photo.user.profileImage.small, 50),
                SizedBox(width: 6),
                Column(
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
                )
              ],
            ),
            LikeButton(photo.likes, photo.likedByUser, () => {}, () => {})
          ],
        ));
  }
}

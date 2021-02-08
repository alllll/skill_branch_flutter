import 'package:FlutterGalleryApp/bloc/author/author_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_like_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/collection/collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:FlutterGalleryApp/widgets/read_more_text.dart';
import 'package:FlutterGalleryApp/widgets/user_avatar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'collection_screen.dart';

class AuthorScreen extends StatefulWidget {
  AuthorScreen({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AuthorScreenState();
  }
}

class _AuthorScreenState extends State<AuthorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: const Center(
              child: Text(
            "Profile",
            style: TextStyle(color: Colors.black, fontSize: 17),
          )),
          actions: [
            // IconButton(icon: const Icon(Icons.more_vert), onPressed: null)
          ],
          leading: IconButton(
              icon: Icon(CupertinoIcons.back, color: AppColors.grayChateau),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: BlocBuilder<AuthorBloc, AuthorState>(builder: (context, state) {
          if (state is AuthorInitial || state is AuthorLoading) {
            return authorScreenLoading();
          }

          if (state is AuthorLoaded) {
            return ProfileDetails(state.user);
          }
        }));
  }
}

Widget authorScreenLoading() {
  return Center(child: CircularProgressIndicator());
}

class ProfileDetails extends StatefulWidget {
  User user;
  ProfileDetails(this.user) : super();
  @override
  State<StatefulWidget> createState() {
    return _ProfileDetailsState();
  }
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return _buildProfileDetailsBody(context, widget.user);
  }
}

Widget _buildProfileDetailsBody(BuildContext context, User user) {
  return DefaultTabController(
    length: 3,
    child: NestedScrollView(
      //key: UniqueKey(),
      headerSliverBuilder: (context, value) {
        return [
          SliverAppBar(
            leading: Container(),
            backgroundColor: Colors.white,
            floating: true,
            pinned: true,
            bottom: TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: AppColors.dodgerBlue,
              tabs: [
                Tab(
                  icon: Icon(
                    AppIcons.home2,
                  ),
                ),
                Tab(icon: Icon(FontAwesome.heart_o)),
                Tab(icon: Icon(FontAwesome.bookmark_o))
              ],
            ),
            expandedHeight: 230,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [_buildProfileDetailsInfo(context, user)],
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        children: [
          _buildListMyPhotoList(user),
          _buildListMyLikes(user),
          _buildListMyCollections(user)
        ],
      ),
    ),
  );
}

Widget _buildProfileDetailsInfo(BuildContext context, User user) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UserAvatar(user.profileImage.large, 90),
        SizedBox(width: 18),
        Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                child: Text(user.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
                child: Row(
                  children: [
                    Text(
                      user.followersCount.toString(),
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          color: AppColors.dodgerBlue,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("   followers  "),
                    Text(user.followingCount.toString(),
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: AppColors.dodgerBlue,
                            fontWeight: FontWeight.bold)),
                    Text("   following"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Offstage(
                  offstage: user.location == null ? true : false,
                  child: Row(
                    children: [
                      Icon(
                        Icons.room,
                        color: AppColors.dodgerBlue,
                        size: 17,
                      ),
                      SizedBox(width: 3),
                      Container(
                          width: 220,
                          child: AutoSizeText(user.location ?? "", maxLines: 1))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Offstage(
                  offstage: user.portfolioUrl == null ? true : false,
                  child: Row(
                    children: [
                      Icon(
                        Entypo.link,
                        color: AppColors.dodgerBlue,
                        size: 17,
                      ),
                      SizedBox(width: 3),
                      /* FittedBox(
                        child: Text(
                          user.portfolioUrl ?? "",
                          softWrap: true,
                        ),
                      )*/
                      Container(
                          width: 220,
                          child: AutoSizeText(user.portfolioUrl ?? "",
                              maxLines: 1))
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ]),
      ReadMoreText(
        user.bio != null ? user.bio : "",
        trimLines: 3,
        colorClickableText: Colors.black,
        trimMode: TrimMode.Line,
        trimCollapsedText: " view more",
        trimExpandedText: " close",
      )
    ],
  );
}

Widget _buildListMyPhotoList(User user) {
  return BlocBuilder<AuthorPhotoBloc, AuthorPhotoState>(
      builder: (context, state) {
    if (state is AuthorPhotoLoadedState) {
      return LazyLoadScrollView(
        scrollOffset: 200,
        onEndOfPage: () {
          BlocProvider.of<AuthorPhotoBloc>(context)
              .add(AuthorPhotoAddEvent(user));
        },
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<AuthorPhotoBloc>(context)
                .add(AuthorPhotoReloadEvent(user));
          },
          child: GridView.builder(
              // key: new PageStorageKey("${user.username}_author_photo_list"),
              itemCount: state.photo.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, i) {
                return GestureDetector(
                  // key: UniqueKey(),
                  onTap: () {
                    BlocProvider.of<PhotoBloc>(context)
                        .add(PhotoEventChoice(state.photo[i]));
                  },
                  child: Hero(
                    tag: state.photo[i].id,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) {
                          return AspectRatio(
                            aspectRatio:
                                state.photo[i].width / state.photo[i].height,
                            child: BlurHash(
                              hash: state.photo[i].blurHash != null
                                  ? state.photo[i].blurHash
                                  : "L0JkyE-;j[.8_3ayogWBofaxayay",
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                        imageUrl: state.photo[i].urls.small,
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }
    if (state is AuthorPhotoInitial) return CircularProgressIndicator();
  });
}

Widget _buildListMyLikes(User user) {
  return BlocBuilder<AuthorLikeBloc, AuthorLikeState>(
      builder: (context, state) {
    if (state is AuthorLikeLoadedState) {
      return LazyLoadScrollView(
        scrollOffset: 200,
        onEndOfPage: () {
          BlocProvider.of<AuthorLikeBloc>(context)
              .add(AuthorLikeAddEvent(user));
        },
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<AuthorLikeBloc>(context)
                .add(AuthorLikeReloadEvent(user));
          },
          child: GridView.builder(
              // key: new PageStorageKey("${user.username}_author_like_list"),
              itemCount: state.photo.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, i) {
                return GestureDetector(
                  //key: UniqueKey(),
                  onTap: () {
                    BlocProvider.of<PhotoBloc>(context)
                        .add(PhotoEventChoice(state.photo[i]));
                  },
                  child: Hero(
                    tag: state.photo[i].id,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) {
                          return AspectRatio(
                            aspectRatio:
                                state.photo[i].width / state.photo[i].height,
                            child: BlurHash(
                              hash: state.photo[i].blurHash != null
                                  ? state.photo[i].blurHash
                                  : "L0JkyE-;j[.8_3ayogWBofaxayay",
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                        imageUrl: state.photo[i].urls.small,
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }
    if (state is AuthorLikeLoadingEvent) return CircularProgressIndicator();
    if (state is AuthorLikeInitial) return CircularProgressIndicator();
  });
}

Widget _buildListMyCollections(User user) {
  return BlocBuilder<AuthorCollectionBloc, AuthorCollectionState>(
      builder: (context, state) {
    if (state is AuthorCollectionLoadedState) {
      return LazyLoadScrollView(
        scrollOffset: 200,
        onEndOfPage: () {
          BlocProvider.of<AuthorCollectionBloc>(context)
              .add(AuthorCollectionAddEvent(user));
        },
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<AuthorCollectionBloc>(context)
                .add(AuthorCollectionReloadEvent(user));
          },
          child: GridView.builder(
              //  key:
              //      new PageStorageKey("${user.username}_author_collection_list"),
              itemCount: state.collections.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, i) {
                return GestureDetector(
                  //    key: UniqueKey(),
                  onTap: () {
                    BlocProvider.of<CollectionBloc>(context)
                        .add(CollectionChoiceEvent(state.collections[i].id));
                  },
                  child: Hero(
                    tag: state.collections[i].id,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: state.collections[i].totalPhotos > 0
                          ? CachedNetworkImage(
                              placeholder: (context, url) {
                                return AspectRatio(
                                  aspectRatio: state
                                          .collections[i].coverPhoto.width /
                                      state.collections[i].coverPhoto.height,
                                  child: BlurHash(
                                    hash: state.collections[i].coverPhoto
                                                .blurHash !=
                                            null
                                        ? state
                                            .collections[i].coverPhoto.blurHash
                                        : "L0JkyE-;j[.8_3ayogWBofaxayay",
                                  ),
                                );
                              },
                              fit: BoxFit.cover,
                              imageUrl:
                                  state.collections[i].coverPhoto.urls.small,
                            )
                          : Image(
                              image: AssetImage('assets/image/no-image.png'),
                            ),
                    ),
                  ),
                );
              }),
        ),
      );
    }
    if (state is AuthorCollectionLoadingEvent)
      return CircularProgressIndicator();
    if (state is AuthorCollectionInitial) return CircularProgressIndicator();
  });
}

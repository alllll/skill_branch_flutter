import 'package:FlutterGalleryApp/bloc/app/app_bloc.dart';
import 'package:FlutterGalleryApp/bloc/collection/collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_event.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/my_photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/profile/profile_like_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/res/app_icons.dart';
import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:FlutterGalleryApp/screens/collection_screen.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:FlutterGalleryApp/widgets/oAuth2.dart';
import 'package:FlutterGalleryApp/widgets/read_more_text.dart';
import 'package:FlutterGalleryApp/widgets/user_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileNoAutheticatedState) {
        return OAuth2(
            "https://unsplash.com/oauth/authorize",
            BlocProvider.of<ProfileBloc>(context).accesKey,
            BlocProvider.of<ProfileBloc>(context).secretKey,
            "https://alllll.ru", (String token) {
          print("Event to Bloc!");

          BlocProvider.of<ProfileBloc>(context)
              .add(ProfileAuthenticatedEvent(token));
        }, true);
      }
      if (state is ProfileAuthenticatedState) {
        return ProfileDetails(state.user);
      }
      return CircularProgressIndicator();
    });
  }
}

class ProfileDetails extends StatefulWidget {
  User user;
  ProfileDetails(this.user, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ProfileDetailsState();
  }
}

class _ProfileDetailsState extends State<ProfileDetails> {
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
          PopupMenuButton(
              onSelected: (value) {
                BlocProvider.of<ProfileBloc>(context).add(ProfileLogoutEvent());
              },
              icon: Icon(
                Icons.more_vert,
                color: Color.fromRGBO(159, 168, 179, 1),
              ),
              itemBuilder: (BuildContext context) {
                var list = List<PopupMenuEntry>();
                list.add(PopupMenuItem(
                  child: Text("Logout"),
                  value: "logout",
                ));
                return list;
              })
        ],
      ),
      body: _buildProfileDetailsBody(context, widget.user),
    );
  }
}

Widget _buildProfileDetailsBody(BuildContext context, User user) {
  return DefaultTabController(
    length: 3,
    child: NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          SliverAppBar(
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
                      Text(user.location ?? "")
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
                      Text(user.portfolioUrl ?? "")
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ]),
      ReadMoreText(
        user.bio,
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
  return BlocBuilder<MyPhotoBloc, MyPhotoState>(builder: (context, state) {
    if (state is MyPhotoLoadedState) {
      return LazyLoadScrollView(
        onEndOfPage: () {
          BlocProvider.of<MyPhotoBloc>(context).add(MyPhotoAddEvent(user));
        },
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<MyPhotoBloc>(context).add(MyPhotoReloadEvent(user));
          },
          child: GridView.builder(
              itemCount: state.photo.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, i) {
                return GestureDetector(
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
    if (state is MyPhotoLoadingEvent) return CircularProgressIndicator();
    if (state is MyPhotoInitialState) return CircularProgressIndicator();
  });
}

Widget _buildListMyLikes(User user) {
  return BlocBuilder<ProfileLikeBloc, ProfileLikeState>(
      builder: (context, state) {
    if (state is ProfileLikeLoadedState) {
      return LazyLoadScrollView(
        onEndOfPage: () {
          BlocProvider.of<ProfileLikeBloc>(context)
              .add(ProfileLikeAddEvent(user));
        },
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<ProfileLikeBloc>(context)
                .add(ProfileLikeReloadEvent(user));
          },
          child: GridView.builder(
              itemCount: state.photo.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, i) {
                return GestureDetector(
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
    if (state is ProfileLikeLoadingEvent) return CircularProgressIndicator();
    if (state is ProfilelikeInitial) return CircularProgressIndicator();
  });
}

Widget _buildListMyCollections(User user) {
  return BlocBuilder<ProfileCollectionBloc, ProfileCollectionState>(
      builder: (context, state) {
    if (state is ProfileCollectionLoadedState) {
      return LazyLoadScrollView(
        onEndOfPage: () {
          BlocProvider.of<ProfileCollectionBloc>(context)
              .add(ProfileCollectionAddEvent(user));
        },
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<ProfileCollectionBloc>(context)
                .add(ProfileCollectionReloadEvent(user));
          },
          child: GridView.builder(
              itemCount: state.collections.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, i) {
                return GestureDetector(
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
    if (state is ProfileCollectionLoadingEvent)
      return CircularProgressIndicator();
    if (state is ProfileCollectionInitial) return CircularProgressIndicator();
  });
}

/*
GestureDetector(
        onTap: () {
          BlocProvider.of<PhotoBloc>(context).add(PhotoEventChoice(photo.id));
          BlocProvider.of<NavigationBloc>(context)
              .add(NavigationFullScreenPhotoEvent());
        },
        child: Hero(
          tag: photo.id,
          child: PhotoW(
            photoLink: photo.urls.small,
          ),
        ),*/

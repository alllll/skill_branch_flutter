import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/bloc/search/search_bloc.dart';
import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:FlutterGalleryApp/widgets/trinity_circular_progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) {
                BlocProvider.of<SearchBloc>(context)
                    .add(SearchPhotoEvent(value));
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.grayChateau,
                ),
                labelText: "Search",
                labelStyle: TextStyle(
                    color: AppColors.grayChateau, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Color.fromARGB(255, 245, 245, 248),
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 245, 245, 248))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 245, 245, 248)),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitialState) {
                    return Container();
                  }
                  if (state is SearchLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchShowResultState) {
                    return SearchGrid(state.photo);
                  }
                  return TrinityCircularProgress();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchGrid extends StatelessWidget {
  final List<Photo> photo;
  const SearchGrid(this.photo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      onEndOfPage: () {
        BlocProvider.of<SearchBloc>(context).add(SearchPhotoAddEvent());
      },
      child: RefreshIndicator(
        onRefresh: () async {
          //BlocProvider.of<PhotoListBloc>(context).add(PhotoListReload());
          print("refreshing");
          BlocProvider.of<SearchBloc>(context).add(SearchPhotoReloadEvent());
          return null;
        },
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.white],
              stops: [0.94, 1],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: StaggeredGridView.countBuilder(
            primary: true,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            key: new PageStorageKey("search_list"),
            crossAxisCount: 3,
            itemCount: photo.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => BlocProvider.of<PhotoBloc>(context)
                      .add(PhotoEventChoice(photo[index])),
                  child: Hero(
                      tag: photo[index].id,
                      child: ImageCard(imageUrl: photo[index].urls.small)));
            },
            staggeredTileBuilder: (index) => StaggeredTile.count(
                (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}

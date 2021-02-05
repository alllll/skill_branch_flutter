import 'dart:async';

import 'package:FlutterGalleryApp/bloc/app/app_bloc.dart';
import 'package:FlutterGalleryApp/bloc/author/author_bloc.dart';
import 'package:FlutterGalleryApp/bloc/collection/collection_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_bloc.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_event.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_state.dart';
import 'package:FlutterGalleryApp/bloc/notification/notification_bloc.dart';
import 'package:FlutterGalleryApp/bloc/photo/photo_bloc.dart';
import 'package:FlutterGalleryApp/main.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/author_screen.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:FlutterGalleryApp/screens/profile_screen.dart';
import 'package:FlutterGalleryApp/screens/search_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'collection_screen.dart';
import 'feed_screen.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pages = [
    Feed(key: new PageStorageKey("feed")),
    SearchScreen(key: new PageStorageKey("feed")),
    Profile(key: new PageStorageKey("profile"))
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
      return Scaffold(
        bottomNavigationBar: BottomNavyBar(
          showElevation: false,
          containerHeight: 65,
          itemCornerRadius: 8,
          currentTab: (state as NavigationTabState).tabItemIndex,
          curve: Curves.ease,
          onItemSelected: (int index) async {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationTabEvent(index));
          },
          items: [
            BottomNavyBarItem(
                asset: AppIcons.home,
                title: Text('Home'),
                activeColor: AppColors.dodgerBlue,
                inactiveColor: AppColors.manatee),
            BottomNavyBarItem(
                asset: AppIcons.search,
                title: Text('Search'),
                activeColor: AppColors.dodgerBlue,
                inactiveColor: AppColors.manatee),
            BottomNavyBarItem(
                asset: AppIcons.user,
                title: Text('Profile'),
                activeColor: AppColors.dodgerBlue,
                inactiveColor: AppColors.manatee),
          ],
        ),
        body: MultiBlocListener(listeners: [
          BlocListener<PhotoBloc, PhotoState>(listener: (context, state) async {
            if (state is PhotoLoaded) {
              final result =
                  await Navigator.push(context, MaterialPageRoute(builder: (_) {
                return FullScreenImage();
              }));
            }
          }),
          BlocListener<CollectionBloc, CollectionState>(
              listener: (context, state) {
            if (state is CollectionLoaded)
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return CollectionScreen();
              }));
          }),
          BlocListener<AuthorBloc, AuthorState>(
            listener: (context, state) {
              if (state is AuthorLoaded) {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AuthorScreen();
                }));
              }
            },
            child: Container(),
          ),
          BlocListener<AppBloc, AppState>(listener: (context, state) {
            if (state is AppNotificationState) {
              Flushbar(
                margin: EdgeInsets.all(5),
                borderRadius: 8,
                flushbarPosition: FlushbarPosition.TOP,
                duration: Duration(seconds: 5),
                isDismissible: true,
                message: state.text,
                icon: Icon(AntDesign.warning, color: Colors.white),
                backgroundColor: Colors.red,
              )..show(context);
            }
          }),
          BlocListener<NotificationBloc, NotificationState>(
              listener: (context, state) {
            if (state is NotificationShowState) {
              Flushbar(
                margin: EdgeInsets.all(5),
                borderRadius: 8,
                flushbarPosition: FlushbarPosition.TOP,
                duration: Duration(seconds: 5),
                isDismissible: true,
                message: state.text,
                icon: Icon(AntDesign.warning, color: Colors.white),
                backgroundColor: Colors.red,
              )..show(context);
            }
          }),
        ], child: pages[(state as NavigationTabState).tabItemIndex]),
      );
    });
  }
}

class BottomNavyBar extends StatelessWidget {
  BottomNavyBar(
      {Key key,
      this.backgrounColor = Colors.white,
      this.showElevation = true,
      this.containerHeight = 70,
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
      this.items,
      this.onItemSelected,
      this.currentTab,
      this.animationDuration = const Duration(milliseconds: 270),
      this.itemCornerRadius = 24,
      this.curve})
      : super(key: key);

  final Color backgrounColor;
  final bool showElevation;
  final double containerHeight;
  final MainAxisAlignment mainAxisAlignment;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final int currentTab;
  final Duration animationDuration;
  final double itemCornerRadius;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgrounColor, boxShadow: [
        if (showElevation) const BoxShadow(color: Colors.black12, blurRadius: 2)
      ]),
      child: SafeArea(
          child: Container(
        width: double.infinity,
        height: containerHeight,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: items.map((item) {
            var index = items.indexOf(item);
            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: _ItemWidget(
                curve: curve,
                animationDuration: animationDuration,
                backgroundColor: backgrounColor,
                isSelected: currentTab == index,
                item: item,
                itemCornerRadius: itemCornerRadius,
              ),
            );
          }).toList(),
        ),
      )),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  _ItemWidget(
      {@required this.isSelected,
      @required this.item,
      @required this.backgroundColor,
      @required this.animationDuration,
      this.curve = Curves.linear,
      @required this.itemCornerRadius})
      : assert(animationDuration != null, 'animationDuration is null'),
        assert(isSelected != null, 'isSelected is null'),
        assert(item != null, 'item is null'),
        assert(backgroundColor != null, 'backgroundColor is null'),
        assert(itemCornerRadius != null, 'itemCornerRadius is null');

  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final Duration animationDuration;
  final Curve curve;
  final double itemCornerRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      /* width: isSelected
          ? 150
          : (MediaQuery.of(context).size.width - 150 - 8 * 4 - 4 * 2) / 2,*/
      width: (MediaQuery.of(context).size.width - 150 - 8 * 4 - 4 * 2) / 2,
      curve: curve,
      decoration: BoxDecoration(
          /* color:
              isSelected ? item.activeColor.withOpacity(0.2) : backgroundColor,*/
          color: backgroundColor,
          borderRadius: BorderRadius.circular(itemCornerRadius)),
      child: Column(
        children: [
          Icon(item.asset,
              size: 20,
              color: isSelected ? item.activeColor : item.inactiveColor),
          SizedBox(width: 4),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: DefaultTextStyle.merge(
                  child: item.title,
                  textAlign: item.textAlign,
                  maxLines: 1,
                  style: TextStyle(
                      color: isSelected ? item.activeColor : item.inactiveColor,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}

class BottomNavyBarItem {
  BottomNavyBarItem(
      {this.asset,
      this.title,
      this.activeColor,
      this.inactiveColor,
      this.textAlign}) {
    assert(asset != null, 'Asset is null');
    assert(title != null, 'Title is null');
  }

  final IconData asset;
  final Text title;
  final Color activeColor;
  final Color inactiveColor;
  final TextAlign textAlign;
}

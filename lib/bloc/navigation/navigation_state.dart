import 'package:flutter/material.dart';

abstract class NavigationState {}

class NavigationTabState extends NavigationState {
  int tabItemIndex;
  NavigationTabState(this.tabItemIndex);
}

class NavigationFullScreenPhotoState extends NavigationState {
  int lastTabItemIndex;
  NavigationFullScreenPhotoState(this.lastTabItemIndex);
}

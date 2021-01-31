import 'package:FlutterGalleryApp/bloc/navigation/navigation_event.dart';
import 'package:FlutterGalleryApp/bloc/navigation/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final GlobalKey<NavigatorState> navigatorKey;
  NavigationBloc(this.navigatorKey) : super(NavigationTabState(0));
  int currentTabIndex;
  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is NavigationTabEvent) {
      currentTabIndex = event.tabIndex;
      yield NavigationTabState(event.tabIndex);
    }

    if (event is NavigationFullScreenPhotoEvent)
      navigatorKey.currentState.pushNamed("/fullScreenImage");

    if (event is NavigationBackEvent) navigatorKey.currentState.pop();
  }
}

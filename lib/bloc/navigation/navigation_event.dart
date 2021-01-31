abstract class NavigationEvent {}

class NavigationTabEvent extends NavigationEvent {
  int tabIndex;
  NavigationTabEvent(this.tabIndex);
}

class NavigationFullScreenPhotoEvent extends NavigationEvent {}

class NavigationBackEvent extends NavigationEvent {}

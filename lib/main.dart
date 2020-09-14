import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  runApp(MyApp(Connectivity().onConnectivityChanged));
}

class ConnectivityOverlay {
  static final ConnectivityOverlay _singleton = ConnectivityOverlay._internal();

  factory ConnectivityOverlay() {
    return _singleton;
  }
  ConnectivityOverlay._internal();

  static OverlayEntry overlayEntry;

  void showOverlay(BuildContext context, Widget child) {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: MediaQuery.of(context).viewInsets.top + 100,
          child: Material(
            color: Colors.transparent,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.mercury,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
    final overlayState = Overlay.of(context);
    overlayState?.insert(overlayEntry);
  }

  void removeOverlay(BuildContext context) {
    overlayEntry?.remove();
  }
}

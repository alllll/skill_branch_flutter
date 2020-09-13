import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Click"))
        ],
      ),
    );
  }
}

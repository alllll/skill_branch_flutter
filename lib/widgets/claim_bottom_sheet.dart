import 'package:flutter/material.dart';

class ClaimBottomSheet extends StatelessWidget {
  List<String> claims = ['ADULT', 'HARM', 'BULLY', 'SPAM', 'COPYRIGHT', 'HATE'];

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: claims.map((item) {
          return Material(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width,
              height: 20,
              child: InkWell(
                  child: Center(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, false);
                  }),
            ),
          );
        }).toList());
  }
}

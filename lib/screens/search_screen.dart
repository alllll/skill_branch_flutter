import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              onSubmitted: (value) {},
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
            )
          ],
        ),
      ),
    );
  }
}

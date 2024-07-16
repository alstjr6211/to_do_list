import 'package:flutter/material.dart';

import '../color.dart';



class Appbarcontainer extends StatelessWidget {

  final String title;
  final double screenheight;

  Appbarcontainer(
      {
        required this.title,
        required this.screenheight,
      }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                //TODO font famliy 추가 필요     fontFamily: "",
                color: gray,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ),
    );
  }
}
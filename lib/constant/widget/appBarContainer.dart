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
      height: 36,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: "NanumBarunpen",
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
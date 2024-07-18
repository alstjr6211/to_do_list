import 'package:flutter/material.dart';
import 'package:to_do_list/constant/color.dart';

Widget textDividor(String text, double screenwidth) {
  return Container(
    alignment: Alignment.center,
    width: screenwidth * 0.92,
    child: Row(
      children: [
        const Expanded(
          child: Divider(color: darkGray, thickness: 0.7,),
        ),
        const SizedBox(width: 10,),
        Text(
          text,
          style: const TextStyle(
            fontFamily: "NanumBarunpen",
            color: darkGray,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10,),
        const Expanded(
          child: Divider(color: darkGray, thickness: 0.7,),
        ),
      ],
    ),
  );
}


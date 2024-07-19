import 'package:flutter/material.dart';
import 'package:to_do_list/constant/color.dart';

Widget homeSubjectDividor(String text, double screenwidth) {
  return Container(
    alignment: Alignment.center,
    width: screenwidth * 0.92,
    child: Row(
      children: [
        Container(
          height: 36,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: white,
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "NanumBarunpen",
                color: darkGray,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
      ],
    ),
  );
}


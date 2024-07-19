import 'package:flutter/material.dart';
import 'package:to_do_list/constant/color.dart';

import '../fonts.dart';

class Settingsline extends StatelessWidget {

  final String menuText;
  final double screenwidth;

  Settingsline(
      {
        required this.menuText,
        required this.screenwidth,
      }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenwidth,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                menuText,
                style: textStyleBold().copyWith(fontSize: 16),
              ),
            ],
          ),
          const Row(
            children: [
              Expanded(
                child: Divider(color: darkGray, thickness: 1.2,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:to_do_list/constant/color.dart';

import '../fonts.dart';

class HomeLine extends StatelessWidget {

  final double screenwidth;

  HomeLine(
      {
        required this.screenwidth,
      }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenwidth,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16, right: 16,
        ),
        child: Row(
          children: [
            Text(
              '완료',
              style: textStyleNormal().copyWith(fontSize: 16),
            ),
            const SizedBox(width: 12,),
            const Expanded(
              child: Divider(color: darkGrey, thickness: 1.0,),
            ),
          ],
        ),
      )
    );
  }
}
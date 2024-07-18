import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'icons.dart';
import 'color.dart';
import 'size.dart';

import 'package:to_do_list/screens/home_screen.dart';
import 'package:to_do_list/screens/calendar_screen.dart';
import 'package:to_do_list/screens/settings_screen.dart';


class ToDoListBottomBar extends StatelessWidget {

  final int selectedPageIndex;

  ToDoListBottomBar({required this.selectedPageIndex});

  void _iconsTapped(BuildContext context, int idx) {
    late Widget nextPage;

    switch (idx) {
      case 0:
        nextPage = HomeScreen();
        break;
      case 1:
        nextPage = CalendarScreen();
        break;
      case 2:
        nextPage = SettingsScreen();
        break;
      default:
        nextPage = HomeScreen();
        break;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedPageIndex,
      onTap: (idx) => _iconsTapped(context, idx),
      backgroundColor: white,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            homesvg,
            color: unselectedItemColor,
            height: bottomBarIconSize,
          ),
          activeIcon: SvgPicture.asset(
            homesvg,
            color: selectedItemColor,
            height: bottomBarIconSize,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            calendarsvg,
            color: unselectedItemColor,
            height: bottomBarIconSize,
          ),
          activeIcon: SvgPicture.asset(
            calendarsvg,
            color: selectedItemColor,
            height: bottomBarIconSize,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            settingssvg,
            color: unselectedItemColor,
            height: bottomBarIconSize,
          ),
          activeIcon: SvgPicture.asset(
            settingssvg,
            color: selectedItemColor,
            height: bottomBarIconSize,
          ),
          label: "",
        ),
      ],
    );
  }
}
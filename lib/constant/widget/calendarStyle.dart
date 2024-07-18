import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_list/constant/fonts.dart';

import '../color.dart';

CalendarStyle calendarStyle() {
  return CalendarStyle(
    cellPadding: EdgeInsets.symmetric(vertical: 8.0),
    todayDecoration: const BoxDecoration(
      color: calendarTodayColor,
      shape: BoxShape.circle,
    ),
    selectedDecoration: const BoxDecoration(
      color: mainContainerColor,
      shape: BoxShape.circle,
    ),
    weekendTextStyle: const TextStyle().copyWith(color: Colors.red),

    //TODO textStyle()
    todayTextStyle: textStyleNormal(),

    outsideDaysVisible: false,
    markersAlignment: Alignment.bottomCenter,
    markersMaxCount: 1,
    markerDecoration: const BoxDecoration(
      color: calendarMarkerColor,
      shape: BoxShape.rectangle,
    ),
    markerSize: 6,
  );
}

DaysOfWeekStyle daysOfWeekStyle() {
  return const DaysOfWeekStyle(
    weekdayStyle: TextStyle(
        fontFamily: "NanumBarunpen",
        fontWeight: FontWeight.normal,
        color: darkGray),
    weekendStyle: TextStyle(
        fontFamily: "NanumBarunpen",
        fontWeight: FontWeight.normal,
        color: Colors.red),
  );
}

HeaderStyle headerStyle() {
  return const HeaderStyle(
    titleTextStyle: TextStyle(
        fontFamily: "NanumBarunpen",
        fontWeight: FontWeight.bold,
        fontSize: 20.0, color: Colors.black),
    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
    formatButtonVisible: false,
    titleCentered: true,
  );
}
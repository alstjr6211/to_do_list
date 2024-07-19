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
    selectedTextStyle: textStyleNormal().copyWith(color: white),
    selectedDecoration: const BoxDecoration(
      color: mainContainerColor,
      shape: BoxShape.circle,
    ),
    weekNumberTextStyle: textStyleBold(),
    withinRangeTextStyle: textStyleBold(),
    weekendTextStyle: textStyleBold().copyWith(color: red),
    todayTextStyle: textStyleBold(),
    outsideDaysVisible: true,
    outsideTextStyle: textStyleBold().copyWith(color: gray),
    disabledTextStyle: textStyleBold().copyWith(color: gray),
    holidayTextStyle: textStyleBold().copyWith(color: red),
    defaultTextStyle: textStyleBold().copyWith(color: black),
    markersAlignment: Alignment.bottomCenter,
    markersMaxCount: 5,
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
  return HeaderStyle(
    headerMargin: const EdgeInsets.all(0.0),
    titleTextStyle: const TextStyle(
        fontFamily: "NanumBarunpen",
        fontWeight: FontWeight.bold,
        fontSize: 20.0, color: Colors.black),
    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
    titleCentered: false,

    formatButtonVisible: true,
    formatButtonShowsNext: true,
    formatButtonTextStyle: textStyleNormal().copyWith(color: darkGray, fontSize: 12),
    formatButtonDecoration: const BoxDecoration(
      border: Border.fromBorderSide(BorderSide(color: purple300)),
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      color: purple100,
    ),
    formatButtonPadding:
    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
  );
}
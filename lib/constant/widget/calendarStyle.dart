import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../color.dart';

CalendarStyle calendarStyle() {
  return CalendarStyle(
    todayDecoration: const BoxDecoration(
      color: calendarTodayColor,
      shape: BoxShape.circle,
    ),
    selectedDecoration: const BoxDecoration(
      color: mainContainerColor,
      shape: BoxShape.circle,
    ),
    weekendTextStyle: TextStyle().copyWith(color: Colors.red),
    //TODO textStyle()
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
  return DaysOfWeekStyle(
    weekdayStyle: TextStyle(color: darkGray),
    weekendStyle: TextStyle(color: Colors.red),
  );
}

HeaderStyle headerStyle() {
  return const HeaderStyle(
    titleTextStyle: TextStyle(fontSize: 20.0, color: Colors.black),
    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
    formatButtonVisible: false,
    titleCentered: true,
  );
}
import 'package:flutter/material.dart';

// This class is used to convert Postgrest date range json value to DateTimeRange
class DateUtilities {
  // Decodes Postgres compatible date format into Dart DateTimeRange
  DateTimeRange decoder(String json) {
    var splitted = json.split(",");
    String start = splitted[0].replaceAll("[", "");
    String end = splitted[1].replaceAll(")", "");
    return DateTimeRange(
        start: DateTime.parse(start), end: DateTime.parse(end));
  }

  // Encodes DateTimeRange into Postgres compatible date format
  String encoder(DateTimeRange date) {
    return "[${date.start.year}-${date.start.month}-${date.start.day},"
        "${date.end.year}-${date.end.month}-${date.end.day})";
  }

  // Turns date into YYYY-MM-DD format string
  String toYMD(DateTime date) {
    String year = date.year.toString();
    String month = ((date.month < 10) ? "0" : "") + date.month.toString();
    String day = ((date.day < 10) ? "0" : "") + date.day.toString();
    return "$year-$month-$day";
  }

  // Turns date into HH:MM format string
  String toHM(DateTime date) {
    String hour = ((date.hour < 10) ? "0" : "") + date.hour.toString();
    String minute = ((date.minute < 10) ? "0" : "") + date.minute.toString();

    return "$hour:$minute";
  }
}

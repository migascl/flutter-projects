import 'package:flutter/material.dart';

// This class is used to convert Postgrest date range json value to DateTimeRange
class DateRangeConverter {

  DateTimeRange decoder(String json) {
    var splitted = json.split(",");
    String start = splitted[0].replaceAll("[", "");
    String end = splitted[1].replaceAll(")", "");
    return DateTimeRange(start: DateTime.parse(start), end: DateTime.parse(end));
  }

  String encoder(DateTimeRange date) {
    return "[${date.start.year}-${date.start.month}-${date.start.day},"
        "${date.end.year}-${date.end.month}-${date.end.day})";
  }

}
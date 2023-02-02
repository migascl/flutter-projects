import 'package:flutter/material.dart';

// This class is used to convert PostgreSQL date range json value to DateTimeRange
class DateUtilities {
  // Decodes Postgres compatible date format into Dart DateTimeRange
  DateTimeRange decoder(String json) {
    var splitted = json.split(",");
    String start = splitted[0].replaceAll("[", "");
    String end = splitted[1].replaceAll(")", "");
    return DateTimeRange(start: DateTime.parse(start), end: DateTime.parse(end));
  }

  // Encodes DateTimeRange into Postgres compatible date format
  String encoder(DateTimeRange date) {
    return "[${date.start.year}-${date.start.month}-${date.start.day},"
        "${date.end.year}-${date.end.month}-${date.end.day})";
  }
}

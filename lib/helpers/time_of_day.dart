import 'package:flutter/material.dart';

extension CONVERTER on TimeOfDay {
  DateTime toDateTime({DateTime? date}) {
    // If no date is provided, use the current date
    date ??= DateTime.now();
    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }
}

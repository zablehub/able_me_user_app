import 'package:flutter/material.dart';

class SearchForDriver {
  final bool isWheelchairFriendly, isPetAllowed;
  final DateTime departureDate;
  final TimeOfDay departureTime;
  final int passenger, luggage, transpoType;
  final String? note;

  const SearchForDriver(
      {required this.departureDate,
      required this.departureTime,
      required this.isPetAllowed,
      required this.isWheelchairFriendly,
      required this.luggage,
      required this.note,
      required this.passenger,
      required this.transpoType});

  @override
  String toString() => "${toJson()}";
  Map<String, dynamic> toJson() => {
        "is_wheelchair_friendly": isWheelchairFriendly,
        "is_pet_allowed": isPetAllowed,
        "departure_date": departureDate.toIso8601String(),
        "departure_time": "${departureTime.hour}:${departureTime.minute}",
        "passenger": passenger,
        "luggage": luggage,
        "transpo_type": transpoType,
        "note": note
      };
}

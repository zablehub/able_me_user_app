import 'dart:ui';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/views/widget_components/promotional_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserBooking {
  final int id, userId, type, status;
  final double price;
  final DateTime createdAt, updatedAt;
  final CurrentAddress destination, pickupLocation;
  final bool isWheelChairFriendly, isRecurring, withPet;

  String statusString() {
    // e.status == 0
    //                                   ? Colors.grey
    //                                   : e.status == 1
    //                                       ? greenPalette
    //                                       : red
    if (status == 1) {
      return "Approved";
    } else if (status == 2) {
      return "Rejected";
    } else if (status == 0) {
      return 'Pending';
    } else {
      return "Cancelled";
    }
  }

  Color statusColor() {
    if (status == 1) {
      return const Color(0xFF83C441);
    } else if (status == 2) {
      return const Color(0xFFC2222B);
    } else if (status == 0) {
      return const Color(0xffBDC3C7);
    } else {
      return const Color(0xFFC2222B).darken();
    }
  }

  const UserBooking({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.destination,
    required this.pickupLocation,
    required this.isRecurring,
    required this.isWheelChairFriendly,
    required this.withPet,
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/rider_booking/user_booking_classes/user_booking_transpo.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;

class UserBookingApi with Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? accessToken = _cacher.getUserToken();
  Future<List<UserTransportationBooking>> get myBookings async {
    try {
      return await http.get(
        "${endpoint}booking/account-booking?sort_by=id/desc".toUri,
        headers: {
          "Accepts": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
      ).then((response) async {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          final List res = data['result']['data'];
          print(res);
          final filteredBookings = res
              .where((element) =>
                  element['transportation'] != null &&
                  element['pickup_location'] != null)
              .where((e) =>
                  e['rider'] != null &&
                  e['state'] != null &&
                  e['country'] != null &&
                  e['city'] != null &&
                  e['address'] != null)
              .toList();
          final List<UserTransportationBooking> result = await Future.wait(
              filteredBookings
                  .map((e) async => await UserTransportationBooking.fromJson(e))
                  .toList());
          print("BOOKING RESULT : $result");
          return result;
        }
        return [];
      });
    } catch (e, s) {
      print("ERROR : $e $s");
      return [];
    }
  }
}

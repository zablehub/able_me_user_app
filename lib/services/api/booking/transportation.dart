import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/bool_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/rider_booking/booking_data.dart';
import 'package:able_me/models/rider_booking/search_driver_config.dart';
import 'package:able_me/models/rider_booking/vehicle.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:riverpod_annotation/riverpod_annotation.dart';

class TransportationApi with Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? accessToken = _cacher.getUserToken();

  Future<List<Vehicle>> searchDrivers(
      {required SearchDriversConfiguration search}) async {
    try {
      return await http.get(
          "${endpoint}rider/search-drivers?sort_by=id/desc&is_wheelchair_friendly=${search.isWheelchairFriendly?.convertToInt() ?? ""}&is_allowed_pet=${search.withPetCompanion?.convertToInt() ?? ""}&seats=${search.passengers ?? ""}&luggage=${search.luggage ?? ""}&rider_ids=${search.riderIds?.join(',') ?? ""}"
              .toUri,
          headers: {
            "Accepts": "application/json",
            HttpHeaders.authorizationHeader: "Bearer $accessToken"
          }).then((response) {
        var data = json.decode(response.body);
        print("DRIVERS: $data");
        if (response.statusCode == 200) {
          final List result = data['data'];
          return result
              .where((e) => e['type'] != null)
              .map((e) => Vehicle.fromJson(e))
              .toList();
        }
        return [];
      });
    } catch (e, s) {
      print("ERROR: $e $s");
      return [];
    }
  }

  Future<bool> book({
    required BookingPayload payload,
  }) async {
    try {
      //
      // assert(accessToken == null, "Token is null");
      //
      // print(payload.toPayload());
      // return false;
      print(payload.toPayload());
      // return false;
      return await http
          .post(
        "${endpoint}booking/transportation/new".toUri,
        headers: {
          "Accepts": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
        body: payload.toPayload(),
      )
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          Fluttertoast.showToast(msg: "Booking Uploaded");
          return true;
        }
        print(response.statusCode);
        print(response.reasonPhrase);
        print(payload.toPayload());
        Fluttertoast.showToast(
            msg: "Booking failed to upload : ${response.reasonPhrase}");
        return false;
      });
    } catch (e, s) {
      Fluttertoast.showToast(msg: "Booking failed to upload");

      return false;
    }
  }
}

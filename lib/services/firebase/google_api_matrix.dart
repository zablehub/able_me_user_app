import 'dart:convert';

import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/services/app_src/env_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class DistanceMatrix {
  final double distance;
  final String distanceString;
  final double etaValue;
  final String etaString;
  const DistanceMatrix(
      {required this.distance,
      required this.etaString,
      required this.distanceString,
      required this.etaValue});

  @override
  String toString() => "${toJson()}";

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "distance_string": distanceString,
        "eta": etaValue,
        "eta_str": etaString
      };
}

class GoogleApiMatrix {
  static final EnvService _env = EnvService.instance;
  final String _apiKey = _env.mapApiKey;
  Future<DistanceMatrix?> getDistanceMatrix(
      GeoPoint origin, GeoPoint dest) async {
    // Construct the URL
    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json'
        '?origins=${origin.convertString()}'
        '&destinations=${dest.convertString()}'
        '&key=$_apiKey';

    try {
      // Make the HTTP GET request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the response body
        final data = jsonDecode(response.body);
        // print('Response data: $data');

        // Extract distance and duration
        final row = data['rows'][0];
        final element = row['elements'][0];
        final String distanceString = element['distance']['text'];
        final double distance =
            double.parse(element['distance']['value'].toString());
        final String duration = element['duration']['text'];
        final double durationMinutes =
            double.parse(element['duration']['value'].toString());
        return DistanceMatrix(
            distance: distance,
            etaString: duration,
            etaValue: durationMinutes,
            distanceString: distanceString);
        // print('Distance: $distance');
        // print('Duration: $duration');
      } else {
        // print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class LocationAndCoordinate {
  final GeoPoint coordinates;
  final String text;
  const LocationAndCoordinate({required this.coordinates, required this.text});
}

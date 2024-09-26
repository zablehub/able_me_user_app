import 'package:able_me/models/rider_booking/firebase_vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverDataModel {
  final int id;
  final String name;
  final FirebaseVehicle? vehicle;
  final String avatar;
  final int activeStatus;
  final Timestamp? activeDate;
  final GeoPoint? coordinates;
  const DriverDataModel({
    required this.activeDate,
    required this.avatar,
    required this.coordinates,
    required this.id,
    required this.activeStatus,
    required this.name,
    required this.vehicle,
  });
  factory DriverDataModel.fromFirestore(DocumentSnapshot doc) {
    // Map<String, dynamic> json = ;
    GeoPoint geo = doc.get('coordinates') as GeoPoint;
    return DriverDataModel(
        activeDate: doc.get('last_active') == null
            ? null
            : doc.get('last_active') as Timestamp,
        avatar: doc.get('avatar'),
        coordinates: geo,
        id: int.parse(doc.get('id').toString()),
        activeStatus: doc.get('active-status') as int,
        name: doc.get('name'),
        vehicle: FirebaseVehicle.fromJson(doc.get('vehicle')));
  }
  // factory DriverAndUserMap.fromJson(Map<String, dynamic> json) {

  // }
}

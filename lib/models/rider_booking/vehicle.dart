import 'package:able_me/models/rider_booking/driver_data.dart';

class Vehicle {
  final int id, userId, seats, luggage;
  final String plateNumber, carModel, carBrand, type;
  final bool isWheelchairFriendly, isPetAllowed;
  final DriverData driver;
  const Vehicle(
      {required this.id,
      required this.userId,
      required this.seats,
      required this.plateNumber,
      required this.carModel,
      required this.carBrand,
      required this.type,
      required this.luggage,
      required this.driver,
      required this.isPetAllowed,
      required this.isWheelchairFriendly});

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      seats: int.parse(json['seats'].toString()),
      plateNumber: json['plate_number'],
      carModel: json['car_model'],
      luggage: int.parse(json['luggage'].toString()),
      carBrand: json['car_brand'],
      type: json['type'] ?? "SUV",
      isPetAllowed: json['is_allowed_pet'] == 1,
      isWheelchairFriendly: json['is_wheelchair_friendly'] == 1,
      driver: DriverData.fromJson(json['user']));
  factory Vehicle.fromFirebase(Map<String, dynamic> json) {
    print("VEHICLE FROM FIREBASE  : $json");
    return Vehicle(
        id: int.parse(json['id'].toString()),
        userId: int.parse(json['user_id'].toString()),
        seats: int.parse(json['seats'].toString()),
        plateNumber: json['plate_number'],
        carModel: json['car_model'],
        luggage: int.parse(json['luggage'].toString()),
        carBrand: json['car_brand'],
        type: json['type'] ?? "SUV",
        isPetAllowed: json['is_allowed_pet'] == 1,
        isWheelchairFriendly: json['is_wheelchair_friendly'] == 1,
        driver: DriverData.fromJson(json['driver']));
  }
}

import 'package:able_me/models/book_rider_details.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/driver_and_vehicle.dart';
import 'package:able_me/models/rider_booking/transportation_details.dart';
import 'package:able_me/models/rider_booking/user_booking.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTransportationBooking extends UserBooking {
  final TransportationDetails details;
  final DriverAndVehicle driverDetails;
  final String address, city, state, country;
  // final BookRiderDetails rider;
  UserTransportationBooking({
    required super.id,
    required super.userId,
    required super.type,
    required super.status,
    required super.price,
    required super.createdAt,
    required super.updatedAt,
    required super.destination,
    required super.pickupLocation,
    required super.isRecurring,
    required super.isWheelChairFriendly,
    required super.withPet,
    // required this.rider,
    required this.details,
    required this.address,
    required this.city,
    required this.country,
    required this.state,
    required this.driverDetails,
  });

  static Future<UserTransportationBooking> fromJson(
      Map<String, dynamic> json) async {
    final List<double> dest = json['destination']
        .toString()
        .split(',')
        .map((e) => double.parse(e.toString()))
        .toList();
    print(json['pickup_location'].toString().split(','));
    final List<double> pck =
        json['pickup_location'].toString().split(',').map((e) {
      print("TO PARSE VALUE : $e");
      return double.parse(e.toString());
    }).toList();
    final CurrentAddress? pickup =
        await pointToAddress(GeoPoint(pck.first, pck.last));
    final CurrentAddress? dst =
        await pointToAddress(GeoPoint(dest.first, dest.last));
    return UserTransportationBooking(
        driverDetails: DriverAndVehicle.fromJson(json['rider']),
        id: json['id'],
        userId: json['customer_id'],
        type: json['type'],
        status: json['status'],
        price: double.parse(json['price'].toString()),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        destination: dst!,
        pickupLocation: pickup!,
        isRecurring: false,
        isWheelChairFriendly: json['is_wheelchair_friendly'] == 1,
        withPet: json['with_pet_companion'] == 1,
        // rider: rider,
        details: TransportationDetails.fromJson(json['transportation']),
        state: json['state'] ?? "NO STATE",
        city: json['city'] ?? "NO CITY",
        address: json['address'] ?? "NO ADDRESSLINE",
        country: json['country'] ?? "NO COUNTRY");
  }

  static Future<CurrentAddress?> pointToAddress(GeoPoint point) async {
    final List<GeoAddress> addresses =
        await Geocoder.google().findAddressesFromGeoPoint(point);
    if (addresses.isNotEmpty) {
      return CurrentAddress(
        addressLine: addresses.first.addressLine ?? "",
        city: addresses.first.adminArea ?? "", // state
        coordinates: point,
        locality: addresses.first.locality ?? "", // city
        countryCode: addresses.first.countryCode ?? "",
      );
    }
    return null;
  }
}

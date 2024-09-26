import 'package:able_me/models/rider_booking/transportation_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime parseDateTime(String dateTimeStr) {
  return DateTime.parse(dateTimeStr);
}

class BookingDetails {
  final int id;
  final int customerId;
  final int riderId;
  final int type;
  final double price;
  int status;
  final DateTime expirationDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GeoPoint destination;
  final String address;
  final String state;
  final String city;
  final String country;
  final GeoPoint pickupLocation;
  final int isWheelchairFriendly;
  final int withPetCompanion;
  final String? note;
  final String? recipientFirstname;
  final String? recipientMiddlename;
  final String? recipientLastname;
  final String? orderReference;
  final String? storeId;
  final String? parcelId;
  final String? region;
  final String? reason;
  final DateTime waitingDatetime;
  final TransportationDetails? transportationDetails;
  BookingDetails({
    required this.expirationDate,
    required this.id,
    this.transportationDetails,
    required this.customerId,
    required this.riderId,
    required this.type,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.destination,
    required this.address,
    required this.state,
    required this.city,
    required this.country,
    required this.pickupLocation,
    required this.isWheelchairFriendly,
    required this.withPetCompanion,
    required this.note,
    this.recipientFirstname,
    this.recipientMiddlename,
    this.recipientLastname,
    this.orderReference,
    this.storeId,
    this.parcelId,
    this.region,
    this.reason,
    required this.waitingDatetime,
  });
  // static final TransportationBookingApi _api = TransportationBookingApi();
  factory BookingDetails.fromJson(Map<String, dynamic> json) {
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
    return BookingDetails(
      expirationDate: DateTime.parse(json['waiting_datetime']),
      destination: GeoPoint(dest.first, dest.last),
      pickupLocation: GeoPoint(pck.first, pck.last),
      id: json['id'],
      customerId: json['customer_id'],
      riderId: json['rider_id'],
      type: json['type'],
      price: json['price'].toDouble(),
      status: json['status'],
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
      // destination: json['destination'],
      address: json['address'],
      state: json['state'],
      city: json['city'],
      country: json['country'],
      // pickupLocation: json['pickup_location'],
      isWheelchairFriendly: json['is_wheelchair_friendly'],
      withPetCompanion: json['with_pet_companion'],
      note: json['note'],
      recipientFirstname: json['recipient_firstname'],
      recipientMiddlename: json['recipient_middlename'],
      recipientLastname: json['recipient_lastname'],
      orderReference: json['order_reference'],
      storeId: json['store_id'],
      parcelId: json['parcel_id'],
      region: json['region'],
      reason: json['reason'],
      transportationDetails: json['transportation'] == null
          ? null
          : TransportationDetails.fromJson(json['transportation']),
      waitingDatetime: parseDateTime(json['waiting_datetime']),
    );
  }
  @override
  String toString() => "{$toJson()}";
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'rider_id': riderId,
      'type': type,
      'price': price,
      'status': status,
      'transportation': transportationDetails,
      'expiration_date': expirationDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'destination': destination,
      'address': address,
      'state': state,
      'city': city,
      'country': country,
      'pickup_location': pickupLocation,
      'is_wheelchair_friendly': isWheelchairFriendly,
      'with_pet_companion': withPetCompanion,
      'note': note,
      'recipient_firstname': recipientFirstname,
      'recipient_middlename': recipientMiddlename,
      'recipient_lastname': recipientLastname,
      'order_reference': orderReference,
      'store_id': storeId,
      'parcel_id': parcelId,
      'region': region,
      'reason': reason,
      'waiting_datetime': waitingDatetime.toIso8601String(),
    };
  }
}

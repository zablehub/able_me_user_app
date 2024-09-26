import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/transaction/booking_details.dart';
import 'package:able_me/models/transaction/operator.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionOrder {
  final int id;
  final int? offerId;
  final int customerId;
  final int operatorId;
  final int status;
  final String reference;
  final int orderNumber;
  final CurrentAddress pickupLocation;
  final GeoPoint destination;
  final String? title;
  final String? description;
  final String address;
  final String state;
  final String city;
  final String country;
  final double price;
  final double subtotal;
  final double vat;
  final double vatRate;
  final double discount;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int bookingId;
  final String? storeId;
  final String? parcelId;
  final String? region;
  final String? reason;
  final String? latestDocument;
  final int type;
  final String typeText;
  final String statusText;
  final String statusColor;
  final String customerName;
  final String riderName;
  final String dateDisplay;
  final List<dynamic> documents;
  final BookingDetails booking;
  final Operator customer;

  TransactionOrder({
    required this.id,
    this.offerId,
    required this.customerId,
    required this.operatorId,
    required this.status,
    required this.reference,
    required this.orderNumber,
    required this.pickupLocation,
    required this.destination,
    this.title,
    this.description,
    required this.address,
    required this.state,
    required this.city,
    required this.country,
    required this.price,
    required this.subtotal,
    required this.vat,
    required this.vatRate,
    required this.discount,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingId,
    this.storeId,
    this.parcelId,
    this.region,
    this.reason,
    this.latestDocument,
    required this.type,
    required this.typeText,
    required this.statusText,
    required this.statusColor,
    required this.customerName,
    required this.riderName,
    required this.dateDisplay,
    required this.documents,
    required this.booking,
    required this.customer,
  });

  static Future<TransactionOrder> fromJson(Map<String, dynamic> json) async {
    final GeoPoint pickupPoint =
        json['pickup_location'].toString().toGeoPoint();
    final CurrentAddress? address = await pointToAddress(pickupPoint);

    return TransactionOrder(
      id: json['id'],
      offerId: json['offer_id'],
      customerId: json['customer_id'],
      operatorId: json['operator_id'],
      status: json['status'],
      reference: json['reference'],
      orderNumber: json['order_number'],
      pickupLocation: address!,
      destination: json['destination'].toString().toGeoPoint(),
      title: json['title'],
      description: json['description'],
      address: json['address'],
      state: json['state'],
      city: json['city'],
      country: json['country'],
      price: json['price'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      vat: json['vat'].toDouble(),
      vatRate: json['vat_rate'].toDouble(),
      discount: json['discount'].toDouble(),
      total: json['total'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      bookingId: json['booking_id'],
      storeId: json['store_id'],
      parcelId: json['parcel_id'],
      region: json['region'],
      reason: json['reason'],
      latestDocument: json['latest_document'],
      type: json['type'],
      typeText: json['type_text'],
      statusText: statusToString(int.parse(json['status'].toString())),
      statusColor: json['status_color'],
      customerName: json['customer_name'],
      riderName: json['rider_name'],
      dateDisplay: json['date_display'],
      documents: json['documents'],
      booking: BookingDetails.fromJson(json['booking']),
      customer: Operator.fromJson(json['operator']),
    );
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

  static String statusToString(int state) {
    switch (state) {
      case 0:
        return "Pending";
      case 1:
        return "Payment Pending";
      case 2:
        return "Paid";
      case 3:
        return "On Transit";
      case 4:
        return "Completed";
      case 5:
        return "Cancelled";
      case 6:
        return "Refunded";
      default:
        return "System Rejected";
    }
  }
}

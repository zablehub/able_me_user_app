import 'package:able_me/models/rider_booking/firebase_vehicle.dart';

class DriverAndVehicle {
  final FirebaseVehicle vehicle;
  final int id;
  final String name;
  final String email;
  final DateTime emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatar;
  final String lastname;
  final DateTime birthday;
  final String? phoneNumber;
  final String firebaseId;
  final int isDisability;
  final int accountType;
  final int isSenior;
  final String gender;
  final int isAccountValidated;
  final String reference;
  final String? profilePic;
  final String? emailValidated;
  final String? deletedAt;
  final String? isBlind;
  final String fullname;
  final String photoUrl;
  final String dateDisplay;
  final List<String> fcmTokens;
  const DriverAndVehicle({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.avatar,
    required this.lastname,
    required this.birthday,
    this.phoneNumber,
    required this.firebaseId,
    required this.isDisability,
    required this.accountType,
    required this.isSenior,
    required this.gender,
    required this.isAccountValidated,
    required this.reference,
    this.profilePic,
    this.emailValidated,
    this.deletedAt,
    this.isBlind,
    required this.fullname,
    required this.photoUrl,
    required this.dateDisplay,
    required this.fcmTokens,
    required this.vehicle,
  });

  factory DriverAndVehicle.fromJson(Map<String, dynamic> json) {
    return DriverAndVehicle(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: DateTime.parse(json['email_verified_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      avatar: json['avatar'],
      lastname: json['lastname'],
      birthday: DateTime.parse(json['birthday']),
      phoneNumber: json['phone_number'],
      firebaseId: json['firebase_id'],
      isDisability: json['is_disability'],
      accountType: json['account_type'],
      isSenior: json['is_senior'],
      gender: json['gender'],
      isAccountValidated: json['is_account_validated'],
      reference: json['reference'],
      profilePic: json['profile_pic'],
      emailValidated: json['email_validated'],
      deletedAt: json['deleted_at'],
      isBlind: json['is_blind'],
      fullname: "${json['name']} ${json['lastname']}",
      photoUrl: json['photo_url'],
      dateDisplay: json['date_display'],
      fcmTokens: List<String>.from(json['fcm_tokens']),
      vehicle: FirebaseVehicle.fromJson(json['vehicle']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'avatar': avatar,
      'lastname': lastname,
      'birthday': birthday.toIso8601String(),
      'phone_number': phoneNumber,
      'firebase_id': firebaseId,
      'is_disability': isDisability,
      'account_type': accountType,
      'is_senior': isSenior,
      'gender': gender,
      'is_account_validated': isAccountValidated,
      'reference': reference,
      'profile_pic': profilePic,
      'email_validated': emailValidated,
      'deleted_at': deletedAt,
      'is_blind': isBlind,
      'fullname': fullname,
      'photo_url': photoUrl,
      'date_display': dateDisplay,
      'fcm_tokens': fcmTokens,
    };
  }

  @override
  String toString() => "${toJson()}";
}

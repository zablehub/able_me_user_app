class Operator {
  final int id;
  final String name;
  final String email;
  final DateTime emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatar;
  final String lastname;
  final String? phoneNumber;
  final String firebaseId;
  final int isDisability;
  final int accountType;
  final int isSenior;
  final String? gender;
  final int isAccountValidated;
  final String? profilePic;
  final bool emailValidated;
  final String? deletedAt;
  final String? isBlind;
  final String? defaultAddress;
  final String fullname;
  final int rating;
  final int ratingCount;
  final String photoUrl;
  final String dateDisplay;
  final List<dynamic> ratings;

  Operator({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.avatar,
    required this.lastname,
    this.phoneNumber,
    required this.firebaseId,
    required this.isDisability,
    required this.accountType,
    required this.isSenior,
    this.gender,
    required this.isAccountValidated,
    this.profilePic,
    required this.emailValidated,
    this.deletedAt,
    this.isBlind,
    this.defaultAddress,
    required this.fullname,
    required this.rating,
    required this.ratingCount,
    required this.photoUrl,
    required this.dateDisplay,
    required this.ratings,
  });

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: DateTime.parse(json['email_verified_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      avatar: json['avatar'],
      lastname: json['lastname'],
      phoneNumber: json['phone_number'],
      firebaseId: json['firebase_id'],
      isDisability: json['is_disability'],
      accountType: json['account_type'],
      isSenior: json['is_senior'],
      gender: json['gender'],
      isAccountValidated: json['is_account_validated'],
      profilePic: json['profile_pic'],
      emailValidated: json['email_validated'] == 1,
      deletedAt: json['deleted_at'],
      isBlind: json['is_blind'],
      defaultAddress: json['default_address'],
      fullname: json['fullname'],
      rating: json['rating'] ?? 0,
      ratingCount: json['rating_count'],
      photoUrl: json['photo_url'],
      dateDisplay: json['date_display'],
      ratings: json['ratings'],
    );
  }
}

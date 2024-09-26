class DriverData {
  final int id, ratingCount;
  final String name, lastName, fullName, avatar;
  const DriverData({
    required this.avatar,
    required this.fullName,
    required this.id,
    required this.lastName,
    required this.name,
    required this.ratingCount,
  });
  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      avatar: json['photo_url'],
      fullName: json['fullname'],
      id: json['id'],
      lastName: json['lastname'] ?? "",
      name: json['name'],
      ratingCount: json['rating_count'] ?? 0,
    );
  }

  @override
  String toString() => "${toJson()}";
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fullname": fullName,
        "lastname": lastName,
        "avatar": avatar,
        "rating_count": ratingCount,
      };
}

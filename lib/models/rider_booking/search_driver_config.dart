class SearchDriversConfiguration {
  final bool? isWheelchairFriendly, withPetCompanion;
  final int? passengers, luggage;
  final List<int>? riderIds;

  const SearchDriversConfiguration(
      {this.isWheelchairFriendly,
      this.withPetCompanion,
      this.passengers,
      this.luggage,
      this.riderIds});
  SearchDriversConfiguration copyWith({
    bool? isWheelchairFriendly,
    bool? withPetCompanion,
    int? passengers,
    int? luggage,
    List<int>? riderIds,
  }) {
    return SearchDriversConfiguration(
      isWheelchairFriendly: isWheelchairFriendly ?? this.isWheelchairFriendly,
      withPetCompanion: withPetCompanion ?? this.withPetCompanion,
      passengers: passengers ?? this.passengers,
      luggage: luggage ?? this.luggage,
      riderIds: riderIds ?? this.riderIds,
    );
  }

  @override
  String toString() => "${toJson()}";
  Map<String, dynamic> toJson() => {
        "rider_ids": riderIds?.join(','),
        "luggage": luggage,
        "passengers": passengers,
        "with_pet_companion": withPetCompanion,
        "is_wheelchair_friendly": isWheelchairFriendly,
      };
}

import 'package:cloud_firestore/cloud_firestore.dart';

const List<PwdPlaces> suggestedPlaces = [
  PwdPlaces(
      contactNumber: "+611300097154",
      coordinates: GeoPoint(-23.69479823538011, 133.8796411736896),
      locationText: "6/8 Gregory Terrace, Alice Springs NT 0870, Australia",
      name: "The Able Hub Pty Ltd",
      imagePath: "assets/images/places/us.jpeg"),
  PwdPlaces(
      contactNumber: "+611800717511",
      coordinates: GeoPoint(-23.7002011273941, 133.88039062543916),
      locationText: "12 Gregory Terrace, Alice Springs NT 0870, Australia",
      name: "Ability Spectrum",
      imagePath: "assets/images/places/ability_spectrum.jpeg"),
  PwdPlaces(
      contactNumber: "+61889534311",
      coordinates: GeoPoint(-23.697507319778644, 133.88047177032783),
      locationText: "Level 1/20 Bath St, Alice Springs NT 0870, Australia",
      name: "Casa Services",
      imagePath: "assets/images/places/casa.jpg"),
  PwdPlaces(
      contactNumber: "+61889531422",
      coordinates: GeoPoint(-23.70003725481049, 133.88269269408826),
      locationText: "79e Todd St, Alice Springs NT 0870, Australia",
      name: "Disability Advocacy Service",
      imagePath: "assets/images/places/das.jpg"),
];

class PwdPlaces {
  final GeoPoint coordinates;
  final String locationText, name, contactNumber, imagePath;

  const PwdPlaces(
      {required this.contactNumber,
      required this.coordinates,
      required this.locationText,
      required this.imagePath,
      required this.name});
}

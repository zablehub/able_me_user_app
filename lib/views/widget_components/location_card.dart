import 'package:able_me/app_config/pwd_places.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatefulWidget {
  const LocationCard({super.key, required this.place});
  final PwdPlaces place;
  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

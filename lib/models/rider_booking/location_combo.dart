import 'package:able_me/models/rider_booking/location_and_coordinate.dart';

class LocationCombo {
  final LocationAndCoordinate pickup;
  final LocationAndCoordinate dest;
  const LocationCombo({required this.dest, required this.pickup});
}

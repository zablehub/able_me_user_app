import 'package:able_me/models/rider_booking/search_driver_config.dart';
import 'package:able_me/models/rider_booking/vehicle.dart';
import 'package:able_me/services/api/booking/transportation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final apiProvider = Provider((ref) => TransportationApi());
final searchDriversProvider =
    FutureProviderFamily<List<Vehicle>, SearchDriversConfiguration>(
  (ref, params) async =>
      await ref.watch(apiProvider).searchDrivers(search: params),
);

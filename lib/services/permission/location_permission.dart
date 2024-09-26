import 'dart:io';

import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/firebase/user_location_service.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/services/geolocation_service.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:able_me/services/app_src/data_cacher.dart';

class AbleLocationPermission with GeoLocationService {
  static final UserLocationFirebaseService _locationFirebaseService =
      UserLocationFirebaseService();
  AbleLocationPermission._pr();
  static final DataCacher _cacher = DataCacher.instance;
  static WidgetRef? ref;
  static final AbleLocationPermission _instance = AbleLocationPermission._pr();
  static AbleLocationPermission instance(WidgetRef r) {
    ref = r;
    return _instance;
  }

  onDeniedCallback() async {
    await Fluttertoast.showToast(
      msg: "Please enable location permission to use the app",
    );
    await Permission.location.request();
  }

  onGrantedCallback() async {
    // final LocationPermission permission = await Geolocator.checkPermission();
    await Geolocator.getCurrentPosition().then((v) async {
      await receivedValue(v);
      // if (mounted) setState(() {});
      // _vm.updatePickupLocation(v.toGeoPoint());
      final List<GeoAddress> address =
          await Geocoder.google().findAddressesFromGeoPoint(v.toGeoPoint());
      if (address.isNotEmpty) {
        if (ref != null) {
          ref!.read(currentAddressNotifier.notifier).update(
                (state) => CurrentAddress(
                  addressLine: address.first.addressLine ?? "",
                  city: address.first.adminAreaCode ?? "", // state
                  coordinates: v.toGeoPoint(),
                  locality: address.first.locality ?? "", //city
                  countryCode: address.first.countryCode ?? "",
                ),
              );
        }
      }
    });
  }

  onPermanentlyDeniedCallback() async {
    final bool isGranted = await openAppSettings();
    if (isGranted) {
      await onGrantedCallback();
    } else {
      await onDeniedCallback();
    }
  }

  // onProvisionalCallback() {}

  Future<void> receivedValue(Position p) async {
    if (ref == null) return;
    Position? pos = ref!.read(coordinateProvider);
    final bool isNew = pos == null;

    pos ??= p;
    final double dist =
        distance(pos.latitude, pos.longitude, p.latitude, p.longitude);
    ref!.read(coordinateProvider.notifier).update((state) => p);

    if ((dist * 1000) < (Platform.isAndroid ? 2 : 1) && !isNew) return;

    final User? user = FirebaseAuth.instance.currentUser;
    final UserModel? _currentUser = ref!.watch(currentUser);

    if (user == null || _currentUser == null) return;
    _locationFirebaseService.updateOrCreateUserLocation(
      user,
      Coordinates(
        pos.latitude,
        pos.longitude,
      ),
      _currentUser,
    );
    String? firebaseAccessToken = await user.getIdToken();
    if (firebaseAccessToken == null) return;
    print(firebaseAccessToken);
    await _cacher.setFirebaseAccessToken(firebaseAccessToken);
    // hasListened = false;

    // if (mounted) setState(() {});
  }
}

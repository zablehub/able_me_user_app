import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/helpers/widget/book_rider_widget_helpers/map_picker.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/location_and_coordinate.dart';
import 'package:able_me/models/rider_booking/location_combo.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/full_create_offer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class CreateBookingDisplay extends ConsumerStatefulWidget {
  const CreateBookingDisplay({super.key, this.showDetails = true});
  final bool showDetails;

  @override
  ConsumerState<CreateBookingDisplay> createState() =>
      _CreateBookingDisplayState();
}

class _CreateBookingDisplayState extends ConsumerState<CreateBookingDisplay>
    with ColorPalette {
  final TextEditingController _pickupLocation = TextEditingController();
  final TextEditingController _dest = TextEditingController();
  late GeoPoint pickupLocation;
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  GeoPoint? destination;
  myListener(CurrentAddress? address) async {
    if (address == null) {
      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // pickupLocation =
        final Position? pos = await Geolocator.getCurrentPosition();
        if (pos == null) return;
        pickupLocation = pos.toGeoPoint();
        final List<GeoAddress> addresses =
            await Geocoder.google().findAddressesFromGeoPoint(pickupLocation);
        _pickupLocation.text = addresses.first.addressLine ?? "";
      } else {
        Fluttertoast.showToast(msg: "Please enable location");
      }
    } else {
      pickupLocation = address.coordinates;
      _pickupLocation.text = address.addressLine;
    }

    if (mounted) setState(() {});
  }

  Future<void> getPickupLocation() async {
    ref.watch(currentAddressNotifier.notifier).addListener(myListener);
    // final CurrentAddress? address = ref.watch(currentAddressNotifier.notifier).a;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPickupLocation();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Where are you going today?",
        //   style: TextStyle(
        //       fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
        // ),
        // const Gap(10),
        Container(
          padding: !widget.showDetails
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: !widget.showDetails
              ? null
              : BoxDecoration(
                  color: bgColor.lighten(),
                  borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              if (widget.showDetails) ...{
                Center(
                  child: Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                      color: bgColor.darken(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const Gap(15),
              },
              // Center(
              //   child: Text(
              //     "Lets book your next trip!",
              //     style: TextStyle(
              //       color: textColor,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // const Gap(20),
              Row(
                children: [
                  if (widget.showDetails) ...{
                    SizedBox(
                      height: 100,
                      width: 30,
                      // color: Colors.red,
                      child: Column(
                        children: [
                          const Gap(15),
                          Center(
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  color: purplePalette.lighten(),
                                  shape: BoxShape.circle),
                            ),
                          ),
                          const Gap(2),
                          // Container(
                          //   height: 10,
                          //   width: 30,
                          //   color: Colors.blueGrey,
                          // ),
                          Expanded(
                            child: Center(
                              child: Container(
                                color: purplePalette.lighten(.5),
                                width: 2,
                              ),
                            ),
                          ),
                          Center(
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                CupertinoIcons.location_circle,
                                color: purplePalette.lighten(),
                                size: 25,
                              ),
                            ),
                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                    Gap(widget.showDetails ? 15 : 5),
                  },
                  // Column(
                  //   children: [

                  //   ],
                  // ),
                  Expanded(
                    child: Form(
                      key: _kForm,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _pickupLocation,
                            validator: (text) => text == null
                                ? "Field is required"
                                : text.isEmpty
                                    ? "Field is required"
                                    : null,
                            onTap: () async {
                              final GeoPoint? result =
                                  await Navigator.of(context).push<GeoPoint>(
                                MaterialPageRoute(
                                  builder: (_) => AbleMeMapPicker(
                                    initLocation: pickupLocation,
                                    geoPointCallback: (g) async {
                                      // widget.onDestinationCallback(g);
                                      // _vm.updateDestination(g);
                                      pickupLocation = g;
                                      await Geocoder.google()
                                          .findAddressesFromGeoPoint(g)
                                          .then((value) {
                                        if (value.isNotEmpty) {
                                          _pickupLocation.text =
                                              value.first.addressLine ??
                                                  "Unknown Address";
                                          if (mounted) setState(() {});
                                        }
                                      });
                                      // ref.watch(bookDataProvider.notifier).update(
                                      //     (state) => state.copyWith(
                                      //         payload: state.payload
                                      //             .copyWith(destination: g)));
                                    },
                                  ),
                                ),
                              );
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              // enabledBorder: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              isDense: true,
                              filled: true,
                              // labelText: "From",
                              labelStyle: TextStyle(color: textColor),
                              // prefixIconConstraints:
                              //     const BoxConstraints(maxWidth: 50),
                              // prefixIcon: Center(
                              //   child: SvgPicture.asset(
                              //     "assets/icons/location.svg",
                              //     width: 20,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              fillColor: textColor.withOpacity(.1),
                              // prefixIcon: Icon(
                              //   Icons.lo,
                              //   color: textColor,
                              // ),
                            ),
                            style: TextStyle(color: textColor, fontSize: 13),
                          ),
                          const Gap(15),
                          TextFormField(
                            validator: (text) => text == null
                                ? "Field is required"
                                : text.isEmpty
                                    ? "Field is required"
                                    : null,
                            controller: _dest,
                            onTap: () async {
                              final GeoPoint? result =
                                  await Navigator.of(context).push<GeoPoint>(
                                MaterialPageRoute(
                                  builder: (_) => AbleMeMapPicker(
                                    initLocation: destination,
                                    geoPointCallback: (g) async {
                                      // widget.onDestinationCallback(g);
                                      // _vm.updateDestination(g);
                                      destination = g;
                                      await Geocoder.google()
                                          .findAddressesFromGeoPoint(g)
                                          .then((value) {
                                        if (value.isNotEmpty) {
                                          _dest.text =
                                              value.first.addressLine ??
                                                  "Unknown Address";
                                          if (mounted) setState(() {});
                                        }
                                      });
                                      // ref.watch(bookDataProvider.notifier).update(
                                      //     (state) => state.copyWith(
                                      //         payload: state.payload
                                      //             .copyWith(destination: g)));
                                    },
                                  ),
                                ),
                              );
                            },
                            readOnly: true,
                            style: TextStyle(color: textColor, fontSize: 13),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              isDense: true,
                              filled: true,
                              labelStyle: TextStyle(color: textColor),
                              // labelText: "Destination",
                              hintStyle:
                                  TextStyle(color: textColor.withOpacity(.3)),
                              hintText: "Pick your destination",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // prefixIconConstraints:
                              //     const BoxConstraints(maxWidth: 50),
                              // prefixIcon: const Center(
                              //     child: Icon(
                              //   Icons.my_location,
                              //   color: Colors.grey,
                              // )),
                              fillColor: textColor.withOpacity(.1),
                              // prefixIcon: Icon(
                              //   Icons.lo,
                              //   color: textColor,
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(20),
              MaterialButton(
                onPressed: () {
                  if (_kForm.currentState!.validate()) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullCreateOfferPage(
                          data: LocationCombo(
                        dest: LocationAndCoordinate(
                          coordinates: destination!,
                          text: _dest.text,
                        ),
                        pickup: LocationAndCoordinate(
                          coordinates: pickupLocation,
                          text: _pickupLocation.text,
                        ),
                      )),
                    ));
                  }
                },
                color: pastelPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                height: 55,
                child: const Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
      ],
    );
  }
}

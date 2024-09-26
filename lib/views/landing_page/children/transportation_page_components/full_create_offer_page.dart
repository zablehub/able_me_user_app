import 'package:able_me/app_config/fare_calculation.dart';
import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/booking_data.dart';
import 'package:able_me/models/rider_booking/location_combo.dart';
import 'package:able_me/models/rider_booking/search_driver_config.dart';
import 'package:able_me/models/rider_booking/vehicle.dart';
import 'package:able_me/models/search_for_driver.dart';
import 'package:able_me/services/api/booking/transportation.dart';
import 'package:able_me/services/firebase/google_api_matrix.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/notifiers/my_booking_history_notifier.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/pickup_and_destination_map.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/listing_drivers.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/new_booking_completer.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class FullCreateOfferPage extends ConsumerStatefulWidget {
  const FullCreateOfferPage({super.key, required this.data});
  final LocationCombo data;
  @override
  ConsumerState<FullCreateOfferPage> createState() =>
      _FullCreateOfferPageState();
}

class _FullCreateOfferPageState extends ConsumerState<FullCreateOfferPage>
    with ColorPalette {
  TransportationApi _api = TransportationApi();
  final TextEditingController _dstText = TextEditingController();
  final GlobalKey<NewBookingCompleterState> _bKey =
      GlobalKey<NewBookingCompleterState>();
  late PickupAndDestMap map = PickupAndDestMap(
    key: Key("${widget.data.pickup}"),
    destination: widget.data.dest.coordinates,
    pickUpLocation: widget.data.pickup.coordinates,
    size: context.csize!.height * .65,
  );
  late final double baseFare = FareCalculation.getRate();
  // late double distance = 0.0;
  DistanceMatrix? matrix;
  final GoogleApiMatrix _apiMatrix = GoogleApiMatrix();
  @override
  void initState() {
    _apiMatrix
        .getDistanceMatrix(
            widget.data.pickup.coordinates, widget.data.dest.coordinates)
        .then((v) {
      if (v == null) return;
      setState(() {
        matrix = v;
      });
    });
    getDest();
    // TODO: implement initState
    super.initState();
  }

  GeoAddress? destination;
  Future<void> getDest() async {
    final List<GeoAddress> address = await Geocoder.google()
        .findAddressesFromGeoPoint(widget.data.dest.coordinates);
    if (address.isNotEmpty) {
      setState(() {
        destination = address.first;
        _dstText.text = address.first.addressLine ?? "";
      });
    }
    print("ADDRESS : $destination");
  }

  Vehicle? chosenVehicle;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              backgroundColor: bgColor,
              body: Column(
                children: [
                  Expanded(
                      child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        floating: true,
                        stretch: true,
                        automaticallyImplyLeading: false,
                        forceMaterialTransparency: true,
                        backgroundColor: Colors.red,
                        // bottom: PreferredSize(
                        //     preferredSize: const Size.fromHeight(0), child: Container()),
                        // flexibleSpace: FlexibleSpaceBar(
                        //   collapseMode: CollapseMode.pin,
                        //   background:
                        // ),
                        flexibleSpace: SizedBox(
                            width: context.csize!.width,
                            height: context.csize!.height * .65,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: map,
                                ),
                                Positioned(
                                  top: 0,
                                  left: 20,
                                  child: SafeArea(
                                    bottom: false,
                                    // child: Text("ASDADS"),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: IconButton.filled(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.resolveWith(
                                                    (_) => Colors.black
                                                        .withOpacity(.5))),
                                        icon: SvgPicture.asset(
                                          "assets/icons/back.svg",
                                          color: Colors.white,
                                          height: 20,
                                        ),
                                        onPressed: () {
                                          if (context.canPop()) {
                                            context.pop();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        expandedHeight: context.csize!.height * .45,
                        collapsedHeight: context.csize!.height * .3,
                      ),
                      SliverList.list(
                        children: [
                          const Gap(10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Complete booking details".capitalizeWords(),
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                if (destination != null) ...{
                                  const Gap(20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Destination",
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Gap(10),
                                      TextField(
                                        controller: _dstText,
                                        enabled: false,
                                        readOnly: true,
                                        style: TextStyle(color: textColor),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: textColor.withOpacity(.1),
                                          prefixIcon: Icon(
                                            CupertinoIcons.location,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                },
                                const Gap(20),
                                NewBookingCompleter(
                                  key: _bKey,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
                  if (matrix != null) ...{
                    Container(
                      width: context.csize!.width,
                      color: bgColor.lighten(),
                      padding: const EdgeInsets.all(20),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.clock,
                                          color: pastelPurple,
                                        ),
                                        const Gap(5),
                                        Text(
                                          "ETA :",
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      matrix!.etaString,
                                      style: TextStyle(
                                          color: pastelPurple,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                // const Gap(5),
                                Divider(
                                  color: textColor.withOpacity(.2),
                                  thickness: .5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.money_dollar_circle,
                                          color: pastelPurple,
                                        ),
                                        const Gap(5),
                                        Text(
                                          "Base Fare :",
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "\$${baseFare.toStringAsFixed(2)}/km",
                                      style: TextStyle(
                                          color: pastelPurple,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                // const Gap(5),
                                // Icon(
                                //   CupertinoIcons.mo,
                                // ),
                                Divider(
                                  color: textColor.withOpacity(.2),
                                  thickness: .5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.flag_circle,
                                          color: pastelPurple,
                                        ),
                                        const Gap(5),
                                        Text(
                                          "Distance :",
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const Gap(5),
                                    Text(
                                      matrix!.distanceString,
                                      style: TextStyle(
                                          color: pastelPurple,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Text("Total Distance : "),
                                //     Text(matrix!.distanceString)
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Text("Base Fare : "),
                                //     Text("${baseFare.toStringAsFixed(2)}/km")
                                //   ],
                                // ),
                              ],
                            ),
                            const Gap(15),
                            if (chosenVehicle != null) ...{
                              Row(
                                children: [
                                  CustomImageBuilder(
                                    size: 70,
                                    avatar: chosenVehicle!.driver.avatar,
                                    placeHolderName:
                                        chosenVehicle!.driver.name[0],
                                  ),
                                  const Gap(15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chosenVehicle!.driver.fullName
                                              .trim()
                                              .capitalizeWords(),
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Car Brand : ",
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            chosenVehicle!.carBrand,
                                            style: TextStyle(
                                                color: pastelPurple,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      // Divider(
                                      //   color: textColor.withOpacity(.1),
                                      //   thickness: .5,
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Car Model : ",
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            chosenVehicle!.carModel,
                                            style: TextStyle(
                                                color: pastelPurple,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      // Divider(
                                      //   color: textColor.withOpacity(.1),
                                      //   thickness: .5,
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Plate Number : ",
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            chosenVehicle!.plateNumber,
                                            style: TextStyle(
                                                color: pastelPurple,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Vehicle Type : ",
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            chosenVehicle!.type,
                                            style: TextStyle(
                                                color: pastelPurple,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      // Divider(
                                      //   color: textColor.withOpacity(.1),
                                      //   thickness: .5,
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                              const Gap(15),
                            },
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Text((baseFare * distance).toStringAsFixed(2)),
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: "\$",
                                      style: TextStyle(
                                        height: 1,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: (baseFare *
                                                  (matrix!.distance / 1000))
                                              .toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                      ]),
                                ),
                                const Gap(15),

                                Expanded(
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 55,
                                    onPressed: chosenVehicle != null
                                        ? destination == null
                                            ? null
                                            : () async {
                                                // setS
                                                // final BookingPayload? data =
                                                //     _bKey.currentState!.getAllData(
                                                //   widget.data.pickup.coordinates,
                                                //   widget.data.dest.coordinates,
                                                //   baseFare *
                                                //       (matrix!.distance / 1000),
                                                // );
                                                // if (data == null) return;
                                                // data.riderID =
                                                //     chosenVehicle!.driver.id;
                                                final BookingPayload data =
                                                    _bKey.currentState!
                                                        .getAllData(
                                                          widget.data.pickup
                                                              .coordinates,
                                                          destination!,
                                                          baseFare *
                                                              (matrix!.distance /
                                                                  1000),
                                                        )!
                                                        .copyWith(
                                                            riderID:
                                                                chosenVehicle!
                                                                    .driver.id);
                                                print(
                                                    "NEW DATA : ${data.toPayload()}");
                                                // return;
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                final bool isBooked = await _api
                                                    .book(payload: data);
                                                if (isBooked) {
                                                  Fluttertoast.showToast(
                                                      msg: "Booked to rider");
                                                }
                                                ref.invalidate(
                                                    userBookingHistory);
                                                _isLoading = false;
                                                if (mounted) setState(() {});
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                                // if (data != null) {

                                                // }
                                              }
                                        : () async {
                                            final SearchDriversConfiguration?
                                                data = _bKey.currentState!
                                                    .getSearchData();
                                            print(data.toString());
                                            if (data != null) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              List<Vehicle> drivers = await _api
                                                  .searchDrivers(search: data);
                                              _isLoading = false;
                                              if (mounted) setState(() {});
                                              if (drivers.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "No driver available for this query");
                                              } else {
                                                await showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  useSafeArea: true,
                                                  isScrollControlled: true,
                                                  barrierLabel: "",
                                                  barrierColor: Colors.black
                                                      .withOpacity(.5),
                                                  isDismissible: false,
                                                  // ignore: use_build_context_synchronously
                                                  context: context,
                                                  builder: (_) =>
                                                      ListingDriversPage(
                                                          driverList: drivers,
                                                          onChooseVehicle: (v) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              chosenVehicle = v;
                                                            });
                                                          }),
                                                );
                                              }
                                            }
                                          },
                                    color: pastelPurple,
                                    child: Center(
                                      child: Text(
                                        chosenVehicle != null
                                            ? "Book"
                                            : "Look for Drivers",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  }
                ],
              ),
            ),
          ),
          if (_isLoading) ...{
            Positioned.fill(
                child: Container(
              color: Colors.black.withOpacity(.5),
              child: const Center(
                child: FullScreenLoader(
                  size: 120,
                  showText: false,
                ),
              ),
            ))
          }
        ],
      ),
    );
  }
}

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/app_config/pwd_places.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/rider_booking/location_and_coordinate.dart';
import 'package:able_me/models/rider_booking/location_combo.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/views/landing_page/children/home_page_components/eta_widget.dart';
import 'package:able_me/views/landing_page/children/home_page_components/visit_eta_widget.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/full_create_offer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class VisitSuggestedPlace extends StatefulWidget {
  const VisitSuggestedPlace({super.key});

  @override
  State<VisitSuggestedPlace> createState() => _VisitSuggestedPlaceState();
}

class _VisitSuggestedPlaceState extends State<VisitSuggestedPlace>
    with ColorPalette {
  final List<PwdPlaces> _suggestedPlaces = const [
    PwdPlaces(
      contactNumber: "+61889517777",
      coordinates: GeoPoint(-23.700999484949307, 133.87860477389154),
      locationText: "6 Gap Rd, The Gap NT 0870, Australia",
      imagePath: "assets/images/places/hospital.jpg",
      name: "Alice Springs Hospital",
    ),
    PwdPlaces(
      contactNumber: "+61889524353",
      coordinates: GeoPoint(-23.691372401301656, 133.86252913716373),
      locationText: "1/74 Elder St, Ciccone NT 0870, Australia",
      imagePath: "assets/images/places/vet.jpg",
      name: "Alice Veterinary Centre",
    ),
  ];
  function() {
    // const [error, response] ?= await
  }
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;

    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          final PwdPlaces place = _suggestedPlaces[i];
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: context.csize!.width - 40,
                  height: context.csize!.height * .35,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          place.imagePath,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(.5),
                          padding: const EdgeInsets.all(20),
                          // alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.name,
                                      style: TextStyle(
                                        fontFamily: "Lokanova",
                                        color: Colors.white,
                                        // fontWeight: FontWeight.w600,
                                        height: 1,
                                        fontSize: context.theme.textTheme
                                                .headlineLarge!.fontSize! +
                                            2,
                                      ),
                                    ),
                                    // const Gap(10),
                                    Text(
                                      place.locationText,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.5),
                                        fontWeight: FontWeight.w600,
                                        height: 1,
                                        fontSize: context.theme.textTheme
                                            .bodyMedium!.fontSize!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  VisitEtaWidget(
                                    dstPnt: place.coordinates,
                                  ),
                                  const Gap(10),
                                  Consumer(
                                    builder: (_, ref, child) {
                                      final CurrentAddress? myAddress =
                                          ref.watch(currentAddressNotifier);
                                      if (myAddress == null) return Container();
                                      return MaterialButton(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 30),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                FullCreateOfferPage(
                                                    data: LocationCombo(
                                              dest: LocationAndCoordinate(
                                                coordinates: place.coordinates,
                                                text: place.locationText,
                                              ),
                                              pickup: LocationAndCoordinate(
                                                coordinates:
                                                    myAddress.coordinates,
                                                text: myAddress.addressLine,
                                              ),
                                            )),
                                          ));
                                        },
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: pastelPurple.lighten(),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(60)),
                                        color: pastelPurple
                                            .lighten()
                                            .withOpacity(.2),
                                        child: const Text(
                                          "Book now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      );
                                    },
                                    // child: ,
                                  )
                                ],
                              ),
                              // Expanded(
                              //   child:
                              // )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
        separatorBuilder: (_, i) => const Gap(10),
        itemCount: _suggestedPlaces.length);
  }
}

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/double_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/time_of_day.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/rider_booking/user_booking_classes/user_booking_transpo.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/pickup_and_destination_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class UserBookingDetailsSheet extends StatefulWidget {
  const UserBookingDetailsSheet({super.key, required this.data});
  final UserTransportationBooking data;
  @override
  State<UserBookingDetailsSheet> createState() =>
      _UserBookingDetailsSheetState();
}

class _UserBookingDetailsSheetState extends State<UserBookingDetailsSheet>
    with ColorPalette {
  late final PickupAndDestMap map = PickupAndDestMap(
      pickUpLocation: widget.data.pickupLocation.coordinates,
      destination: widget.data.destination.coordinates,
      size: context.csize!.height * .25);
  late DateTime eta = widget.data.details.departureTime
      .toDateTime(date: widget.data.details.departureDate)
      .add(etaMinutes.minutes);
  late final double etaMinutes = widget.data.pickupLocation.coordinates
      .calculateETAMinutes(widget.data.destination.coordinates, speed: 20);
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(30)),
      child: SafeArea(
        bottom: true,
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                widget.data.statusString(),
                style: TextStyle(
                    color: widget.data.statusColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              ClipRRect(borderRadius: BorderRadius.circular(20), child: map),
              const Gap(20),
              Center(
                child: Row(
                  children: [
                    CustomImageBuilder(
                      avatar: widget.data.driverDetails.avatar,
                      placeHolderName: widget.data.driverDetails.name[0],
                      size: 60,
                    ),
                    const Gap(20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.driverDetails.fullname
                                .capitalizeWords(),
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.data.driverDetails.email,
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(.5),
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Divider(
                color: textColor.withOpacity(.2),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addressDate(
                    widget.data.details.departureTime
                        .toDateTime(date: widget.data.details.departureDate),
                    "${widget.data.pickupLocation.locality},${widget.data.pickupLocation.city}",
                    textColor,
                    "Pickup Location :",
                  ),
                  const Gap(15),
                  addressDate(
                    eta,
                    "${widget.data.destination.locality},${widget.data.destination.city}",
                    textColor,
                    "Destination :",
                  ),
                  const Gap(15),
                  Text(
                    "Distance : ${widget.data.pickupLocation.coordinates.calculateDistance(widget.data.destination.coordinates).toStringAsFixed(2)} km",
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "ETA : ${etaMinutes.convertMinutesToTimeFormat()}",
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w600),
                  ),
                  // ETAWidget(riderPoint: widget.data.)
                ],
              ),
              const Gap(20),
              Text(
                "If you rebook it will automatically use the same pickup location and destination, and time, just different date",
                style: TextStyle(color: textColor.withOpacity(.5)),
              ),
              const Gap(5),
              MaterialButton(
                onPressed: () async {},
                color: pastelPurple,
                height: 55,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    "Rebook",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              // Row(
              //   children: [
              //     Expanded(
              // child: addressDate(
              //     widget.data.createdAt,
              //     "${widget.data.pickupLocation.locality},${widget.data.pickupLocation.city}",
              //     textColor),
              //     ),
              //     const Gap(5),
              //     Row(
              //       children: List.generate(
              //         3,
              //         (i) => Icon(
              //           Icons.chevron_right,
              //           color: textColor.withOpacity(((i + 1) / 3)),
              //           weight: 5,
              //           size: 15,
              //         ),
              //       ),
              //     ),
              //     const Gap(5),
              //     Expanded(
              //       child: addressDate(
              //           widget.data.createdAt,
              //           "${widget.data.pickupLocation.locality},${widget.data.pickupLocation.city}",
              //           textColor,
              //           true),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget addressDate(DateTime date, String state, Color textColor, String title,
          [bool isRev = false]) =>
      Column(
        crossAxisAlignment:
            isRev ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: textColor, fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Text(
            DateFormat('dd MMM, yyyy - HH:mm a, EEEE').format(date),
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(.5),
            ),
          ),
          Text(
            state,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: textColor, fontSize: 13, fontWeight: FontWeight.w600),
          )
        ],
      );
}

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/date_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/helpers/widget/user_booking_widgets/user_booking_details_sheet.dart';
import 'package:able_me/view_models/notifiers/my_booking_history_notifier.dart';
import 'package:able_me/views/widget_components/promotional_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class UserBookingViewer extends ConsumerStatefulWidget {
  const UserBookingViewer({super.key});

  @override
  ConsumerState<UserBookingViewer> createState() => _UserBookingViewerState();
}

class _UserBookingViewerState extends ConsumerState<UserBookingViewer>
    with ColorPalette {
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final result = ref.watch(userBookingHistory);
    return result.when(
        data: (data) {
          if (data.isEmpty) {
            return Container();
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Booking",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.resolveWith(
                            (_) => pastelPurple)),
                    child: const Text("See all"),
                  ),
                ],
              ),
              SizedBox(
                // color: Colors.red,
                width: context.csize!.width,
                height: 150,
                child: CarouselView(
                    itemExtent: context.csize!.width - 40,
                    onTap: (i) async {
                      await showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        isScrollControlled: true,
                        barrierColor: Colors.black.withOpacity(.5),
                        barrierLabel: "",
                        backgroundColor: bgColor,
                        builder: (_) => UserBookingDetailsSheet(
                          data: data[i],
                        ),
                      );
                      // print("TAPPED : ${data[i].country}");
                    },
                    controller: CarouselController(),
                    scrollDirection: Axis.horizontal,
                    itemSnapping: true,
                    children: data
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.all(20),
                            color: bgColor.lighten(),
                            child: OverflowBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            CustomImageBuilder(
                                              avatar: e.driverDetails.avatar,
                                              placeHolderName:
                                                  e.driverDetails.name[0],
                                            ),
                                            const Gap(10),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.driverDetails.fullname
                                                      .capitalizeWords(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: textColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  e.driverDetails.email,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: textColor
                                                        .withOpacity(.5),
                                                    // fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                      const Gap(10),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: e.statusColor(),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          e.statusString(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: e.status == 0
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  // Expanded(child: Container()),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: addressDate(
                                            e.createdAt,
                                            "${e.pickupLocation.locality},${e.pickupLocation.city}",
                                            textColor),
                                      ),
                                      const Gap(5),
                                      Row(
                                        children: List.generate(
                                          3,
                                          (i) => Icon(
                                            Icons.chevron_right,
                                            color: textColor
                                                .withOpacity(((i + 1) / 3)),
                                            weight: 5,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                      const Gap(5),
                                      Expanded(
                                        child: addressDate(
                                            e.createdAt,
                                            "${e.pickupLocation.locality},${e.pickupLocation.city}",
                                            textColor,
                                            true),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList()),
              ),
            ],
          );
          // return Column(
          //   children: [
          //     const Gap(20),

          //     ...data.map(
          //       (e) => ListTile(
          // leading: CustomImageBuilder(
          //     avatar: e.driverDetails.avatar,
          //     placeHolderName: e.driverDetails.name[0]),
          //         trailing: Text(
          //           e.createdAt.formatTimeAgo,
          //           style: TextStyle(color: textColor.withOpacity(.5)),
          //         ),
          //         subtitle: Text(
          //           e.address,
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //         subtitleTextStyle: TextStyle(
          //           fontFamily: "Montserrat",
          //           fontSize: 13.5,
          //           fontWeight: FontWeight.w400,
          //           color: textColor.withOpacity(.5),
          //         ),
          //         title: Text.rich(
          //           TextSpan(
          //               text: e.driverDetails.fullname.capitalizeWords(),
          //               style: TextStyle(
          //                 fontFamily: "Montserrat",
          //                 fontSize: 15,
          //                 fontWeight: FontWeight.w600,
          //                 color: textColor,
          //               ),
          //               children: [
          //                 TextSpan(
          //                     text: " (${e.statusString()})",
          //                     style: TextStyle(
          //                         fontSize: 13,
          //                         fontWeight: FontWeight.w400,
          //                         fontStyle: FontStyle.italic,
          //                         color: e.status == 0
          //                             ? Colors.grey
          //                             : e.status == 1
          //                                 ? greenPalette
          //                                 : red))
          //               ]),
          //         ),
          //         // title: Text(e.driverDetails.fullname.capitalizeWords()),
          //         // titleTextStyle: TextStyle(
          //         //   fontFamily: "Montserrat",
          //         //   fontSize: 15,
          //         //   fontWeight: FontWeight.w600,
          //         //   color: textColor,
          //         // ),
          //       ),
          //     ),
          //   ],
          // );
        },
        error: (err, s) => Container(),
        loading: () => Container());
  }

  Widget addressDate(DateTime date, String state, Color textColor,
          [bool isRev = false]) =>
      Column(
        crossAxisAlignment:
            isRev ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd MMM, yyyy').format(date),
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(.5),
            ),
          ),
          Text(
            state,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: textColor, fontSize: 13, fontWeight: FontWeight.w600),
          )
        ],
      );
}

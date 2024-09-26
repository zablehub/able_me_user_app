import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/transaction/transaction_order.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/view_models/notifiers/transsaction_notifier.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/transaction/address_date_from_geopoint_viewer.dart';
import 'package:able_me/views/widget_components/promotional_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class RecentTransactionViewer extends ConsumerStatefulWidget {
  const RecentTransactionViewer({super.key});

  @override
  ConsumerState<RecentTransactionViewer> createState() =>
      _RecentTransactionViewerState();
}

class _RecentTransactionViewerState
    extends ConsumerState<RecentTransactionViewer> with ColorPalette {
  @override
  initState() {
    super.initState();
  }

  Widget addressDate(DateTime date, String state, [bool isRev = false]) =>
      Column(
        crossAxisAlignment:
            isRev ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd MMM, yyyy').format(date),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(.5),
            ),
          ),
          Text(
            state,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Consumer(builder: (_, ref, child) {
      final transactions = ref.watch(allTransactionsProvider);
      return transactions.when(
        data: (data) {
          if (data.isNotEmpty) {
            return Column(
              children: [
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Transactions",
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
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    final TransactionOrder order = data[i];
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: pastelPurple.darken(),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "#${order.reference}",
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              const Gap(10),
                              //STATUS
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  order.statusText.toString(),
                                  style: TextStyle(
                                      color: pastelPurple.darken(),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Expanded(
                                // child: FutureBuilder(
                                //     future: func(order.booking.pickupLocation),
                                //     builder: (_, snapshot) {
                                //       if (snapshot.hasData) {
                                //         return addressDate(
                                //           order.createdAt,
                                //           "${snapshot.data!.locality},${snapshot.data!.city}",
                                //         );
                                //       }
                                //       return Container();
                                //     }),
                                // child: AddressDateFromGeopointViewer(
                                //   point: order.booking.pickupLocation,
                                //   dateTime: order.createdAt,
                                // ),
                                child: addressDate(
                                  order.createdAt,
                                  "${order.pickupLocation.locality},${order.pickupLocation.city}",
                                ),
                              ),
                              const Gap(5),
                              Row(
                                children: List.generate(
                                  3,
                                  (i) => Icon(
                                    Icons.chevron_right,
                                    color:
                                        Colors.white.withOpacity(((i + 1) / 3)),
                                    weight: 5,
                                    size: 15,
                                  ),
                                ),
                              ),
                              const Gap(5),
                              Expanded(
                                child: addressDate(
                                  order.booking.transportationDetails!
                                      .departureDate,
                                  "${order.booking.city},${order.booking.state}",
                                  true,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, i) => const Gap(10),
                  itemCount: data.length,
                ),
              ],
            );
          }
          return Container();
        },
        error: (e, s) => Container(),
        loading: () => Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(textColor.withOpacity(.3)),
              ),
              const Gap(10),
              Text(
                "Loading Transactions",
                style: TextStyle(color: textColor.withOpacity(.3)),
              ),
            ],
          ),
        ),
      );
    });
  }
}

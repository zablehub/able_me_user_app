import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/transaction/transaction_order.dart';
import 'package:able_me/services/api/notification.dart';
import 'package:able_me/services/api/transaction/payment_api.dart';
import 'package:able_me/services/api/transaction/transaction_api.dart';
import 'package:able_me/view_models/notifiers/transsaction_notifier.dart';
import 'package:able_me/views/landing_page/children/home_page_components/eta_widget.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/pickup_and_destination_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class OnGoingTransactionUiDisplay extends ConsumerStatefulWidget {
  const OnGoingTransactionUiDisplay({super.key, required this.order});
  final TransactionOrder order;
  @override
  ConsumerState<OnGoingTransactionUiDisplay> createState() =>
      _OnGoingTransactionUiDisplayState();
}

class _OnGoingTransactionUiDisplayState
    extends ConsumerState<OnGoingTransactionUiDisplay> with ColorPalette {
  late final PickupAndDestMap map = PickupAndDestMap(
    destination: widget.order.destination,
    pickUpLocation: widget.order.pickupLocation.coordinates,
    size: context.csize!.width * .4,
  );

  final PaymentApi _api = PaymentApi();
  final TransactionApi _txApi = TransactionApi();
  final NotificationApi _notificationApi = NotificationApi();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return LayoutBuilder(builder: (context, cc) {
      return Container(
        // padding: const EdgeInsets.all(20),
        color: bgColor.lighten(),
        child: OverflowBox(
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: cc.maxWidth * .4,
                  // color: Colors.red,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: IgnorePointer(ignoring: true, child: map)),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [
                              bgColor,
                              bgColor.withOpacity(.5),
                              Colors.transparent
                            ],
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  // color: Colors.red,
                  width: cc.maxWidth * .6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.order.reference,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Gap(10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              widget.order.statusText.toString(),
                              style: TextStyle(
                                  color: pastelPurple.darken(),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                      const Gap(20),
                      // ETAWidget(riderPoint: widget.order.),
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
                              widget.order.createdAt,
                              "${widget.order.pickupLocation.locality},${widget.order.pickupLocation.city}",
                              textColor,
                            ),
                          ),
                          const Gap(5),
                          Row(
                            children: List.generate(
                              3,
                              (i) => Icon(
                                Icons.chevron_right,
                                color: textColor.withOpacity(((i + 1) / 3)),
                                weight: 5,
                                size: 15,
                              ),
                            ),
                          ),
                          const Gap(5),
                          Expanded(
                            child: addressDate(
                              widget.order.booking.transportationDetails!
                                  .departureDate,
                              "${widget.order.booking.city},${widget.order.booking.state}",
                              textColor,
                              true,
                            ),
                          ),
                        ],
                      ),
                      const Gap(14),
                      Row(
                        children: [
                          if (widget.order.status != 4) ...{
                            SizedBox(
                              width: cc.maxWidth * .25,
                              child: MaterialButton(
                                height: 45,
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  side: BorderSide(
                                    color: pastelPurple,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.chat_bubble_text,
                                      color: pastelPurple,
                                      size: 18,
                                    ),
                                    const Gap(10),
                                    Text(
                                      "Message",
                                      style: TextStyle(
                                          color: pastelPurple,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Gap(10),
                            SizedBox(
                              // width: cc.maxWidth * .15,
                              child: MaterialButton(
                                height: 45,
                                color: pastelPurple,
                                disabledColor: pastelPurple,
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (widget.order.status == 0) {
                                          await _txApi.updateStatus(
                                            widget.order.id,
                                            status: 3,
                                          );
                                          await _notificationApi.send(
                                            receiverID:
                                                widget.order.booking.riderId,
                                            title: "Booking Status Update",
                                            body:
                                                "User updated the status to 'In Transit'",
                                            type: 'update-transaction',
                                            isUrgent: false,
                                          );
                                        } else if (widget.order.status == 1) {
                                          await _api
                                              .pay(
                                            transactionID: widget.order.id,
                                            paymentMethod: "Testing",
                                            price: widget.order.total,
                                            transactionReference: widget.order
                                                .reference, // change to bank txdata
                                            gross: widget.order.subtotal,
                                            net: widget.order.total,
                                            bankFee: 0,
                                          )
                                              .then((v) async {
                                            if (v) {
                                              await _txApi.updateStatus(
                                                widget.order.id,
                                                status: 4,
                                              );
                                              await _notificationApi.send(
                                                receiverID: widget
                                                    .order.booking.riderId,
                                                title: "Transaction Payment",
                                                body:
                                                    "${widget.order.reference} is paid",
                                                type: 'update-transaction',
                                                isUrgent: false,
                                              );
                                            }
                                          });
                                        }

                                        isLoading = false;
                                        if (mounted) setState(() {});
                                        ref.invalidate(
                                          ongoingTransactionsProvider,
                                        );
                                        // ApplePay()
                                      },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  side: BorderSide(
                                    color: pastelPurple,
                                  ),
                                ),
                                child: isLoading
                                    ? Center(
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                  Colors.white),
                                          backgroundColor: Platform.isIOS
                                              ? Colors.white
                                              : null,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (widget.order.status == 0) ...{
                                            const Text(
                                              "Driver is here",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          } else if (widget.order.status ==
                                              1) ...{
                                            const Icon(
                                              CupertinoIcons
                                                  .money_dollar_circle,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            const Gap(10),
                                            const Text(
                                              "Pay",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          },
                                        ],
                                      ),
                              ),
                            ),
                          } else ...{
                            const Text(
                              "Transaction Completed",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            )
                          }
                        ],
                      )
                    ],
                  ),
                ),
                // child: Container(
                //   width: cc.maxWidth,
                //   decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //           colors: [Colors.transparent, bgColor])),
                // ),
              )
            ],
          ),
        ),
      );
    });
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

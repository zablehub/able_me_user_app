import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/rider_booking/user_booking.dart';
import 'package:able_me/models/transaction/transaction_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class NotifyingWidget extends StatelessWidget {
  const NotifyingWidget({super.key, required this.body, required this.title});
  final String title, body;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        width: context.csize!.width,
        constraints: const BoxConstraints(maxHeight: 90, minHeight: 60),
        decoration: BoxDecoration(
            color: bgColor.lighten(), borderRadius: BorderRadius.circular(20)),
        // height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 55,
              width: 55,
            ).animate().rotate(),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title.capitalizeWords(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    body.capitalizeWords(),
                    style: TextStyle(
                      color: textColor.withOpacity(.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

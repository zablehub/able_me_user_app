import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/view_models/notifiers/transsaction_notifier.dart';
import 'package:able_me/views/widget_components/on_going_transaction_ui_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class OnGoingTransactions extends ConsumerStatefulWidget {
  const OnGoingTransactions({super.key});

  @override
  ConsumerState<OnGoingTransactions> createState() =>
      _OnGoingTransactionsState();
}

class _OnGoingTransactionsState extends ConsumerState<OnGoingTransactions> {
  @override
  Widget build(BuildContext context) {
    final res = ref.watch(ongoingTransactionsProvider);
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return res.when(
        data: (data) {
          if (data.isEmpty) {
            return Container();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "ON-GOING/UPCOMING TRANSACTIONS",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: context.csize!.width,
                height: 200,
                // color: Colors.red,
                child: PageView(
                  // onTap: null,
                  controller: PageController(),
                  scrollDirection: Axis.horizontal,
                  // itemSnapping: true,
                  // itemExtent: context.csize!.width * 1,
                  children: data
                      .map((e) => OnGoingTransactionUiDisplay(
                            order: e,
                          ))
                      .toList(),
                ),
              ),
              // ListView.separated(
              //   padding: const EdgeInsets.all(0),
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (_, i) => ListTile(
              //     leading: CustomImageBuilder(
              //         size: 45,
              //         avatar: data[i].customer.avatar,
              //         placeHolderName: data[i].customer.name[0]),
              //     title: Text(
              //       data[i].customer.fullname.capitalizeWords(),
              //       style: TextStyle(
              //           color: textColor,
              //           fontSize: 15,
              //           fontWeight: FontWeight.w600),
              //     ),
              //     subtitle: Text.rich(
              //       TextSpan(
              //           text: data[i].dateDisplay,
              //           style: TextStyle(color: textColor),
              //           children: [
              //             TextSpan(
              //                 text: " (${data[i].reference})",
              //                 style: TextStyle(
              //                   color: textColor.withOpacity(.5),
              //                 ))
              //           ]),
              //     ),
              //   ),
              //   separatorBuilder: (_, i) => Divider(
              //     color: Colors.black.withOpacity(.2),
              //   ),
              //   itemCount: data.length,
              // ),
            ],
          );
        },
        error: (e, s) => Container(),
        loading: () => Container());
  }
}

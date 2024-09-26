import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/view_models/notifiers/transsaction_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return res.when(
        data: (data) {
          if (data.isEmpty) {
            return Container();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "ON-GOING/UPCOMING TRANSACTIONS",
                  style: TextStyle(color: textColor),
                ),
              ),
              ListView.separated(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) => ListTile(
                  leading: CustomImageBuilder(
                      size: 45,
                      avatar: data[i].customer.avatar,
                      placeHolderName: data[i].customer.name[0]),
                  title: Text(
                    data[i].customer.fullname.capitalizeWords(),
                    style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                        text: data[i].dateDisplay,
                        style: TextStyle(color: textColor),
                        children: [
                          TextSpan(
                              text: " (${data[i].reference})",
                              style: TextStyle(
                                color: textColor.withOpacity(.5),
                              ))
                        ]),
                  ),
                ),
                separatorBuilder: (_, i) => Divider(
                  color: Colors.black.withOpacity(.2),
                ),
                itemCount: data.length,
              ),
            ],
          );
        },
        error: (e, s) => Container(),
        loading: () => Container());
  }
}

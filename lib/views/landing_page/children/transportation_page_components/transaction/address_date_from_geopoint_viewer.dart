import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AddressDateFromGeopointViewer extends StatefulWidget {
  const AddressDateFromGeopointViewer(
      {super.key, required this.point, required this.dateTime});
  final GeoPoint point;
  final DateTime dateTime;
  @override
  State<AddressDateFromGeopointViewer> createState() =>
      _AddressDateFromGeopointViewerState();
}

class _AddressDateFromGeopointViewerState
    extends State<AddressDateFromGeopointViewer> {
  CurrentAddress? pickupAddress;
  Future<void> func() async {
    final List<GeoAddress> address =
        await Geocoder.google().findAddressesFromGeoPoint(widget.point);
    if (address.isNotEmpty) {
      pickupAddress = CurrentAddress(
        addressLine: address.first.addressLine ?? "",
        city: address.first.adminArea ?? "", // state
        coordinates: widget.point,
        locality: address.first.locality ?? "", //city
        countryCode: address.first.countryCode ?? "",
      );
      if (mounted) setState(() {});
      return;
      // if (ref != null) {
      //   ref!.read(currentAddressNotifier.notifier).update(
      //         (state) => ,
      //       );
      // }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await func();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('dd MMM, yyyy').format(widget.dateTime),
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(.5),
          ),
        ),
        pickupAddress == null
            ? Shimmer.fromColors(
                baseColor: bgColor,
                highlightColor: Colors.grey.shade400,
                child: Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: bgColor.lighten().withOpacity(.2),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(60)),
                  ),
                ))
            : Text(
                "${pickupAddress!.locality},${pickupAddress!.city}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              )
      ],
    );
  }
}

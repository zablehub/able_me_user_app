import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class VisitEtaWidget extends StatefulWidget {
  const VisitEtaWidget({super.key, required this.dstPnt});
  final GeoPoint dstPnt;
  @override
  State<VisitEtaWidget> createState() => _VisitEtaWidgetState();
}

class _VisitEtaWidgetState extends State<VisitEtaWidget> {
  // final EnvService _env = EnvService.instance;
  // DistanceMatrix? matrix;
  // String? eta;
  // final GoogleApiMatrix _matrixApi = GoogleApiMatrix();
  String calculateETA(Position userLoc) {
    // Position? userLoc;
    // Position? userLoc = ref.read(coordinateProvider);
    final String d = userLoc.toGeoPoint().calculateETA(widget.dstPnt);
    return d;
    // Geolocator.getPositionStream().listen((data) {
    //   // setState(() {
    //   //   userLoc = onData;
    //   // });
    //   eta = d; // to minutes
    //   if (mounted) setState(() {});
    // });
  }

  @override
  void initState() {
    // calculateETA();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, c) {
        Position? userLoc = ref.watch(coordinateProvider);
        if (userLoc != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white.withOpacity(.2)),
            child: Text(
              calculateETA(userLoc),
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.white),
            ),
          );
        }
        return Container();
      },
    );
    // if (eta == null) return Container();
    // final Color textColor = context.theme.secondaryHeaderColor;
    // final Color bgColor = context.theme.scaffoldBackgroundColor;
    // return Center(
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(20),
    //         color: Colors.white.withOpacity(.5)),
    //     child: Text(
    //       eta!.toString(),
    //       style: TextStyle(fontWeight: FontWeight.w500),
    //     ),
    //   ),
    // );
  }
}

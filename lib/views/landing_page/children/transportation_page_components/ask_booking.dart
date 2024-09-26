import 'package:able_me/views/landing_page/children/transportation_page_components/create_offer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AskBookingViewer extends StatefulWidget {
  const AskBookingViewer({super.key});

  @override
  State<AskBookingViewer> createState() => _AskBookingViewerState();
}

class _AskBookingViewerState extends State<AskBookingViewer> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          CreateBookingDisplay(
            showDetails: false,
          )
        ],
      ),
    );
  }
}

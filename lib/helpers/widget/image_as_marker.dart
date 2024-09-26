import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageAsMarker extends StatefulWidget {
  const ImageAsMarker(
      {super.key,
      required this.fullname,
      required this.networkImage,
      this.size = 65});
  final String? networkImage;
  final String fullname;
  final double size;
  @override
  State<ImageAsMarker> createState() => _ImageAsMarkerState();
}

class _ImageAsMarkerState extends State<ImageAsMarker> with ColorPalette {
  late final double size = widget.size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            child: SvgPicture.asset(
              "assets/icons/location.svg",
              color: purplePalette,
              height: size,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.all(10),
    //   color: purplePalette,
    // child: CustomImageBuilder(
    //   avatar: widget.networkImage,
    //   placeHolderName: widget.fullname,
    //   size: 30,
    // ),
    // );
  }
}

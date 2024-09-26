import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomMarkerAbleMe extends StatefulWidget {
  const CustomMarkerAbleMe(
      {super.key,
      this.size = 65,
      this.color = Colors.red,
      this.fullname,
      this.avatar});
  final double size;
  final Color color;
  final String? avatar;
  final String? fullname;
  @override
  State<CustomMarkerAbleMe> createState() => _CustomMarkerAbleMeState();
}

class _CustomMarkerAbleMeState extends State<CustomMarkerAbleMe>
    with ColorPalette {
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
              color: widget.color,
              height: size,
              fit: BoxFit.fitHeight,
            ),
          ),
          if (widget.avatar != null && widget.fullname != null) ...{
            Positioned(
              top: size * .16,
              child: CustomImageBuilder(
                avatar: widget.avatar,
                placeHolderName: widget.fullname![0],
                size: size * .6,
              ),
            ),
          },
          // Positioned(
          //   top: 11,
          //   child: CustomImageBuilder(
          //     avatar: widget.networkImage,
          //     placeHolderName: widget.fullname[0],
          //     size: 40,
          //   ),
          // ),
        ],
      ),
    );
  }
}

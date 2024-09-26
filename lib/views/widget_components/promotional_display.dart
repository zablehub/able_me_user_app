import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PromotionalDisplay extends StatelessWidget with ColorPalette {
  PromotionalDisplay({super.key});
  final double height = 150;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      // color: Colors.red,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height * .85,
              decoration: BoxDecoration(
                color: const Color(0xFF8967B3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: height * 1.5,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(colors: [
                          Colors.white.withOpacity(.3),
                          Colors.transparent
                        ], radius: 1.5),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: height * 1.3,
                        child: const Center(
                          child: Text(
                            "Going anywhere is now easier!",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                height: 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22),
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          // Positioned(
          //   left: 0,
          //   top: 0,
          //   bottom: 0,
          //   child: Container(
          //     width: height,
          //     height: height * .,
          //     color: Colors.red,
          //   ),
          // ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/www.png",
              // width: 200,
              height: height,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}

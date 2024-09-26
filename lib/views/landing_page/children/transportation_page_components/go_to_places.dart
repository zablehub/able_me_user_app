import 'package:able_me/app_config/palette.dart';
import 'package:able_me/app_config/pwd_places.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/rider_booking/location_and_coordinate.dart';
import 'package:able_me/models/rider_booking/location_combo.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/full_create_offer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class GoToPlacesDisplay extends ConsumerStatefulWidget {
  const GoToPlacesDisplay({super.key});

  @override
  ConsumerState<GoToPlacesDisplay> createState() => _GoToPlacesDisplayState();
}

class _GoToPlacesDisplayState extends ConsumerState<GoToPlacesDisplay>
    with ColorPalette {
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final CurrentAddress? address = ref.watch(currentAddressNotifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No idea where to go?",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
                Text(
                  "Here are some of our suggested places",
                  style: TextStyle(color: textColor),
                )
              ],
            )),
        const Gap(10),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, i) {
            final PwdPlaces place = suggestedPlaces[i];
            return ListTile(
              onTap: address == null
                  ? null
                  : () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FullCreateOfferPage(
                            data: LocationCombo(
                          dest: LocationAndCoordinate(
                            coordinates: place.coordinates,
                            text: place.locationText,
                          ),
                          pickup: LocationAndCoordinate(
                            coordinates: address.coordinates,
                            text: address.addressLine,
                          ),
                        )),
                      ));
                    },
              tileColor: bgColor.lighten(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              subtitle: Text(
                place.locationText,
              ),
              subtitleTextStyle: TextStyle(
                  color: textColor.withOpacity(.5), fontFamily: "Montserrat"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                color: textColor,
                size: 15,
              ),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: purplePalette.withOpacity(.2),
                      width: 1.5,
                    ),
                    image: DecorationImage(
                        // alignment: Alignment.centerLeft,
                        fit: BoxFit.cover,
                        image: AssetImage(
                          place.imagePath,
                        ))),
                // child: Image.asset(
                //   place.imagePath,
                //   width: 60,
                // ),
              ),
              title: Text(
                place.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: textColor,
                fontFamily: "Montserrat",
              ),
            );
          },
          separatorBuilder: (_, i) => const SizedBox(
            height: 10,
          ),
          itemCount: suggestedPlaces.length,
        )
      ],
    );
  }
}

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/rider_booking/vehicle.dart';
import 'package:able_me/views/widget_components/searched_drivers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ListingDriversPage extends StatefulWidget {
  const ListingDriversPage(
      {super.key, required this.onChooseVehicle, required this.driverList});
  final ValueChanged<Vehicle> onChooseVehicle;
  final List<Vehicle> driverList;
  @override
  State<ListingDriversPage> createState() => _ListingDriversPageState();
}

class _ListingDriversPageState extends State<ListingDriversPage>
    with ColorPalette {
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Container(
      width: context.csize!.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    color: bgColor.darken(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Gap(20),
              Row(
                children: [
                  const Gap(50),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Choose your driver",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  IconButton.filled(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith((v) => bgColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: textColor.withOpacity(.5),
                    ),
                  )
                ],
              ),
              const Gap(15),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) {
                  final Vehicle vehicle = widget.driverList[i];
                  return ListTile(
                    onTap: () {
                      widget.onChooseVehicle(vehicle);
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: SizedBox(
                        width: 55,
                        height: 55,
                        child: CustomImageBuilder(
                          avatar: vehicle.driver.avatar,
                          placeHolderName: vehicle.driver.fullName.trim()[0],
                        ),
                      ),
                    ),
                    title: Text(
                      vehicle.driver.fullName.trim().capitalizeWords(),
                    ),
                    titleTextStyle: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    subtitle: Text(
                        "${("${vehicle.carBrand}: ${vehicle.carModel}").capitalizeWords()}, ${vehicle.plateNumber}"),
                    subtitleTextStyle: TextStyle(
                      color: pastelPurple,
                    ),
                  );
                },
                separatorBuilder: (_, i) => Divider(
                  color: textColor.withOpacity(.2),
                  thickness: .5,
                ),
                itemCount: widget.driverList.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}

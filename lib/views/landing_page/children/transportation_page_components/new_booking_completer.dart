import 'package:able_me/app_config/global.dart';
import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/date_ext.dart';
import 'package:able_me/helpers/time_of_day.dart';
import 'package:able_me/models/firebase/driver_data.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/booking_data.dart';
import 'package:able_me/models/rider_booking/search_driver_config.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class NewBookingCompleter extends ConsumerStatefulWidget {
  const NewBookingCompleter({super.key});

  @override
  ConsumerState<NewBookingCompleter> createState() =>
      NewBookingCompleterState();
}

class NewBookingCompleterState extends ConsumerState<NewBookingCompleter>
    with ColorPalette {
  DriverDataModel? selectedDriver;

  TimeOfDay? _departureTime;
  final TextEditingController _time = TextEditingController();
  // late final TextEditingController _price;
  final TextEditingController _note = TextEditingController();
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  bool withPet = false;
  bool wheelChairFriendly = true;
  final DateTime nowPlus1 = DateTime.now().add(1.hours);
  // late final TextEditingController _
  DateTime _departureDate = DateTime.now().add(1.hours);
  late final TextEditingController _date = TextEditingController()
    ..text = DateFormat('MMM dd, yyyy').format(_departureDate);
  final int maxPassenger = 10;
  final int maxLuggage = 10;
  int numOfPassengers = 1;
  int numOfLuggage = 0;
  int selectedTranspoType = 2;

  BookingPayload? getAllData(GeoPoint pick, GeoAddress dst, double price) {
    if (_kForm.currentState!.validate()) {
      final UserModel? _udata = ref.watch(currentUser);
      // CurrentAddress(
      //               addressLine: address.first.addressLine ?? "",
      //               city: address.first.adminAreaCode ?? "",
      //               coordinates: v.toGeoPoint(),
      //               locality: address.first.locality ?? "",
      //               countryCode: address.first.countryCode ?? "",
      //             )
      return BookingPayload(
        departureDate: _departureDate,
        departureTime: _departureTime!,
        // isPetAllowed: withPet,
        isWheelchairFriendly: wheelChairFriendly,
        luggage: numOfLuggage,
        note: _note.text.isEmpty ? null : _note.text,
        transpoType: selectedTranspoType,
        userID: _udata!.id,
        type: 5,
        passengers: numOfPassengers,
        destination:
            GeoPoint(dst.coordinates!.latitude, dst.coordinates!.longitude),
        pickupLocation: pick,
        price: price,
        state: dst.adminArea ?? "",
        city: dst.locality ?? "",
        address: dst.addressLine ?? "",
        country: dst.countryName ?? "",
        withPet: withPet,
      );
    }
  }

  SearchDriversConfiguration? getSearchData() {
    if (_kForm.currentState!.validate()) {
      return SearchDriversConfiguration(
        passengers: numOfPassengers,
        luggage: numOfLuggage,
        riderIds: riderIDs,
        isWheelchairFriendly: wheelChairFriendly,
        withPetCompanion: withPet,
      );
    }
  }

  Widget customRadio(
    String title,
    DateTime value,
    int transpotype,
  ) {
    // final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    print(value);
    return InkWell(
      onTap: () {
        setState(() {
          _departureDate = value;
          _date.text = DateFormat('MMM dd, yyyy').format(_departureDate);
          selectedTranspoType = transpotype;
        });
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: (transpotype == 2 &&
                            transpotype == selectedTranspoType &&
                            _departureDate.isSameDay(value)) ||
                        (transpotype == 3 &&
                            transpotype == selectedTranspoType &&
                            _departureDate.isAfter(DateTime.now()))
                    ? pastelPurple
                    : textColor.withOpacity(.1),
                border: Border.all(color: Colors.white.withOpacity(.5)),
                borderRadius: BorderRadius.circular(5)),
          ),
          const Gap(5),
          Text(
            title,
            style: TextStyle(
              color: textColor,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return Form(
      key: _kForm,
      child: Column(
        children: [
          Row(
            children: [
              customRadio("Short Notice", DateTime.now().add(1.hours), 2),
              const Gap(20),
              customRadio("Pre-scheduled", DateTime.now().add(1.days), 3),
            ],
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Departure Date",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _date,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13,
                            ),
                            validator: (text) {
                              if (text == null) {
                                return "Unexpected error";
                              } else if (text.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },

                            readOnly: true,
                            enabled: !_departureDate.isSameDay(DateTime.now()),
                            // selectionHeightStyle:
                            //     BoxHeightStyle.includeLineSpacingTop,
                            onTap: !_departureDate.isSameDay(DateTime.now())
                                ? () async {
                                    await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now().add(1.days),
                                      lastDate: DateTime.now().add(30.days),
                                    ).then((value) {
                                      if (value == null) return;
                                      // _vm.updateDepartureDate(value);
                                      setState(() {
                                        _date.text = DateFormat('MMM dd, yyyy')
                                            .format(_departureDate);
                                        _departureDate = value;
                                      });
                                      _kForm.currentState!.validate();
                                      // widget.onDateCallback(value);
                                    });
                                  }
                                : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: textColor.withOpacity(.1),
                              prefixIcon: Icon(
                                Icons.calendar_month,
                                color: textColor,
                              ),
                              hintText: "When to pick you up?",
                              hintStyle: TextStyle(
                                color: textColor.withOpacity(.3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Gap(20),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Departure Time",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    TextFormField(
                      controller: _time,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                      ),
                      validator: (text) {
                        if (text == null) {
                          return "Unexpected error";
                        } else if (text.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () async {
                        await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: _departureDate.hour,
                              minute: _departureDate.minute),
                        ).then((value) {
                          if (value == null) return;
                          if (!value.toDateTime().isAfter(nowPlus1)) {
                            Fluttertoast.showToast(
                                msg: "You must pick atleast 1 hour ahead");
                            return;
                          }
                          _departureTime = value;
                          _time.text = value.format(context);
                          // _vm.updateDepartureTime(value);
                          if (mounted) setState(() {});
                          _kForm.currentState!.validate();
                          // widget.onTimeCallback(value);
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: textColor.withOpacity(.1),
                        prefixIcon: Icon(
                          Icons.watch_later_outlined,
                          color: textColor,
                        ),
                        hintText: "--:--",
                        hintStyle: TextStyle(
                          color: textColor.withOpacity(.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            children: [
              // Expanded(
              //   flex: 5,
              //   child:
              // ),
              // const Gap(20),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Passenger(s)",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        validator: (i) {
                          if (i == null) {
                            return "Required";
                          } else if (i.isNaN) {
                            return "Invalid value";
                          }
                        },
                        focusColor: Colors.red,
                        value: numOfPassengers,
                        dropdownColor: bgColor.lighten(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: textColor.withOpacity(.1),
                          prefixIcon: Icon(
                            Icons.person,
                            color: textColor,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            maxWidth: 50,
                            minWidth: 40,
                            minHeight: 50,
                          ),
                        ),
                        items: List.generate(
                          maxPassenger,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        onChanged: (i) {
                          if (i == null) return;
                          // ref.watch(bookDataProvider.notifier).update((state) =>
                          //     state.copyWith(
                          //         payload:
                          //             state.payload.copyWith(passengers: i)));
                          // _vm.updatePassenger(i);
                          _kForm.currentState!.validate();
                          // widget.passengerCallback(i);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Luggage(s)",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        dropdownColor: bgColor.lighten(),
                        validator: (i) {
                          if (i == null) {
                            return "Required";
                          } else if (i.isNaN) {
                            return "Invalid value";
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.luggage,
                            color: textColor,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            maxWidth: 50,
                            minWidth: 40,
                            minHeight: 50,
                          ),
                          filled: true,
                          fillColor: textColor.withOpacity(.1),
                        ),
                        value: numOfLuggage,
                        items: List.generate(
                          maxLuggage,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(
                              (index).toString(),
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        onChanged: (i) {
                          if (i == null) return;
                          // _vm.updateLuggage(i);
                          // dataProvider.update((state) => state!.copyWith(
                          //       payload: state.payload.copyWith(luggage: i),
                          //     ));
                          // setState(() {
                          //   numOfLuggage = i;
                          // });
                          _kForm.currentState!.validate();
                          // widget.luggageCallback(i);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            title: const Text("Wheelchair Friendly"),
            titleTextStyle: TextStyle(
              color: textColor,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
            ),
            subtitle: const Text(
                "Enable if you want a vehicle that is wheelchair friendly"),
            subtitleTextStyle: TextStyle(
              color: textColor.withOpacity(.5),
              fontFamily: "Montserrat",
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            trailing: Switch.adaptive(
                activeTrackColor: purplePalette,
                // activeColor: purplePalette,
                value: wheelChairFriendly,
                onChanged: (b) {
                  setState(() {
                    wheelChairFriendly = b;
                  });
                  // _vm.updateWheelChair(b);
                  // widget.wheelChairFriendlyCallback(b);
                }),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            title: const Text("Pet Companion"),
            titleTextStyle: TextStyle(
              color: textColor,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
            ),
            subtitle: const Text("Enable if you are with your pet companion"),
            subtitleTextStyle: TextStyle(
              color: textColor.withOpacity(.5),
              fontFamily: "Montserrat",
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            trailing: Switch.adaptive(
                activeTrackColor: purplePalette,
                // activeColor: purplePalette,
                value: withPet,
                onChanged: (b) {
                  setState(() {
                    withPet = b;
                  });
                  // _vm.updateWithPet(b);
                  // widget.withPetCallback(b);
                }),
          ),
          const Gap(10),
          Divider(
            color: textColor.withOpacity(.3),
          ),
          const Gap(10),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notes to driver",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(15),
                TextFormField(
                  controller: _note,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                  ),
                  // onFieldSubmitted: (t) {
                  //   _kForm.currentState!.validate();
                  //   widget.onNoteCallback(t);
                  // },
                  onChanged: (t) {
                    // _vm.updateNote(t);
                    // widget.onNoteCallback(t);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: textColor.withOpacity(.1),
                    hintText: "(Optional)",
                    hintStyle: TextStyle(
                      color: textColor.withOpacity(.3),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Gap(10),
          // SearchedDriversViewer(
          //   riderCallback: (DriverDataModel value) {},
          // ),
        ],
      ),
    );
  }
}

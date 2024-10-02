import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/auth/auth_helper.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/helpers/widget/user_booking_viewer.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/firebase/firebase_messaging.dart';
import 'package:able_me/services/firebase/user_location_service.dart';
import 'package:able_me/services/permission/location_permission.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/booking_payload_vm.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/blogs_page_components/main_blogs_page.dart';
import 'package:able_me/views/landing_page/children/medicine_page_components/main_medicine_page.dart';
import 'package:able_me/views/landing_page/children/restaurant_page_components/main_restaurant_page.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/ask_booking.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/create_offer.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/main_transportation_page.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/transaction/recent_transaction_viewer.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/visit_suggested_place.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:able_me/views/widget_components/on_going_transaction_viewer.dart';
import 'package:able_me/views/widget_components/promotional_display.dart';
import 'package:able_me/views/widget_components/searched_drivers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key, required this.initIndex});
  final int initIndex;
  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage>
    with ColorPalette, AuthHelper {
  late final AbleLocationPermission _locationPermission =
      AbleLocationPermission.instance(ref);
  final FirebaseMessagingServices _FCM = FirebaseMessagingServices();

  // late final SpeechAssistant _myAssistant;
  final GlobalKey<MainTransportationPageState> _kTranspo =
      GlobalKey<MainTransportationPageState>();
  bool hasListened = false;
  late int currentIndex = widget.initIndex;
  late final PageController _controller =
      PageController(initialPage: currentIndex);
  late final List<Widget> content = [
    MainTransportationPage(
      onBookPressed: () async {
        await book();
      },
      key: _kTranspo,
    ),
    const MainRestaurantPage(),
    const MainMedicinePage(),
    Container(
      color: Colors.red,
    ),
    const MainBlogPage()
  ];
  Future<bool> isNotificationEnabled() async {
    final bool isGranted = await Permission.notification.isGranted;

    return isGranted;
  }

  Future<void> initAssistant() async {
    // await _myAssistant.initialize();
  }

  Future<void> initFirebaseMessaging() async {}
  Future<void> initialize(int time) async {
    await Permission.location
        .onDeniedCallback(_locationPermission.onDeniedCallback)
        .onGrantedCallback(_locationPermission.onGrantedCallback)
        .onPermanentlyDeniedCallback(
          _locationPermission.onPermanentlyDeniedCallback,
        )
        .onRestrictedCallback(_locationPermission.onPermanentlyDeniedCallback)
        .onProvisionalCallback(_locationPermission.onGrantedCallback)
        .request();
  }

  final BookingPayloadVM _vm = BookingPayloadVM.instance;
  UserModel? udata;
  final UserLocationFirebaseService _service = UserLocationFirebaseService();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserData().then((value) async {
        ref.read(currentUser.notifier).update((state) => value);
        setState(() {
          udata = value;
        });
        print("USER : $value");
        if (value == null) {
          Fluttertoast.showToast(msg: "Account is incomplete");

          return;
        }
        _vm.updateID(value.id);

        final bool _isNotificationEnabled = await isNotificationEnabled();
        print("NOTIFICATION PERMSSION : ${_isNotificationEnabled}");
        ref
            .read(notificationProvider.notifier)
            .update((s) => _isNotificationEnabled);
        if (_isNotificationEnabled) {
          await _FCM.init(value.id).then((v) async {
            if (!v) return;
            _FCM.handleOnMessage(context, ref);
            _FCM.handleOnMessageOpened(ref);
          });
        }
      });
      await initialize(0);

      // await initAssistant();
    });
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final stream = ref.watch(currentUser.notifier).stream;
    final size = MediaQuery.of(context).size;
    final CurrentAddress? address = ref.watch(currentAddressNotifier);
    final UserModel? _udata = ref.watch(currentUser.notifier).state;
    return PopScope(
      canPop: !isLoading,
      child: Stack(
        children: [
          Positioned.fill(
            child: StreamBuilder(
              stream: stream,
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Center(
                      child: FullScreenLoader(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [Text("ERROR : ${snapshot.error}")],
                    ),
                  );
                }
                return Scaffold(
                  extendBody: false,
                  appBar: AppBar(
                    leadingWidth: 80,
                    actions: [
                      // if (_udata != null) ...{
                      //   GestureDetector(
                      //     onTap: () => context.push('/profile-page'),
                      //     child: CustomImageBuilder(
                      //       avatar: _udata.avatar,
                      //       placeHolderName: _udata.name[0].toUpperCase(),
                      //     ),
                      //   ),
                      IconButton(
                          onPressed: () {},
                          // style: ButtonStyle(
                          //     backgroundColor: WidgetStateProperty.resolveWith(
                          //         (_) => Colors.grey.shade200)),
                          icon: SvgPicture.asset(
                            "assets/icons/chats.svg",
                            color: textColor,
                          )),
                      const Gap(20),
                      // },
                    ],
                    leading: _udata != null
                        ? Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              onTap: () => context.push('/profile-page'),
                              child: Center(
                                child: CustomImageBuilder(
                                  avatar: _udata.avatar,
                                  placeHolderName: _udata.name[0].toUpperCase(),
                                ),
                              ),
                            ),
                          )
                        : null,
                    centerTitle: true,
                    title: Container(
                      // color: Colors.red,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_udata != null) ...{
                            Text(
                              "Hello, ${_udata.name.capitalizeWords()}",
                              style: TextStyle(
                                  color: pastelPurple,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            )
                          },
                          // Row(
                          //   children: [
                          //     SvgPicture.asset(
                          //       "assets/icons/location.svg",
                          //       width: 20,
                          //       color: Colors.grey,
                          //     ),
                          //     const Gap(5),
                          // const Text(
                          //   "Location",
                          //   style: TextStyle(
                          //       color: Colors.grey,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w600),
                          // )
                          //   ],
                          // ),
                          if (address != null) ...{
                            // const Gap(5),
                            InkWell(
                              onTap: () {
                                context.push('/profile-page/address');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${address.locality}, ${address.city}, ${address.countryCode}"
                                        .capitalizeWords(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: textColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  // const Gap(10),
                                  // const Icon(
                                  //   Icons.keyboard_arrow_down_outlined,
                                  //   color: Colors.black,
                                  // )
                                ],
                              ),
                            )
                          },
                        ],
                      ),
                    ),
                  ),
                  // floatingActionButton: FloatingActionButton(
                  //   tooltip: "Pay",
                  //   onPressed: () {},
                  //   child: const Center(
                  //     child: Icon(
                  //       Icons.payment_outlined,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  // floatingActionButtonLocation:
                  //     FloatingActionButtonLocation.centerDocked,
                  body: ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    children: [
                      PromotionalDisplay(),

                      const OnGoingTransactions(),

                      const Gap(20),
                      const CreateBookingDisplay(),
                      const Gap(20),
                      const VisitSuggestedPlace(),
                      // const Gap(20),
                      const UserBookingViewer(),
                      // const Gap(20),
                      const RecentTransactionViewer(),
                      // const Gap(0),
                      const Gap(20),
                      // const GoToPlacesDisplay(),
                      const Gap(10),
                      SearchedDriversViewer(
                        riderCallback: (rider) async {
                          await showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(.5),
                              barrierLabel: "",
                              transitionBuilder: (_, a1, a2, c) =>
                                  ScaleTransition(
                                    scale: a1,
                                    child: FadeTransition(
                                      opacity: a1,
                                      child: c,
                                    ),
                                  ),
                              transitionDuration: 600.ms,
                              pageBuilder: (_, a1, a2) {
                                return AlertDialog(
                                  title: Text(
                                    "Book ${rider.name.capitalizeWords()}",
                                    style: TextStyle(
                                        color: textColor, fontSize: 16),
                                  ),
                                  backgroundColor: bgColor,
                                  surfaceTintColor: purplePalette,
                                  content: const AskBookingViewer(),
                                  // content: const CreateBookingDisplay(),
                                );
                              });
                        },
                        // config: SearchDriversConfiguration(),
                      ),
                    ],
                  ),
                  // body: MainTransportationPage(
                  //   onBookPressed: () async {
                  //     await book();
                  //   },
                  // ),
                  // body: PageView(
                  //   controller: _controller,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   children: content,
                  // ),
                  // floatingActionButton: FloatingActionButton(
                  //   backgroundColor: currentIndex == 4
                  //       ? purplePalette
                  //       : isDarkMode
                  //           ? bgColor.lighten()
                  //           : bgColor.darken(),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(60)),
                  //   onPressed: () {
                  //     setState(() {
                  //       currentIndex = 4;
                  //     });
                  //     _controller.jumpToPage(
                  //       currentIndex,
                  //     );
                  //   },
                  //   child: Center(
                  //     child: Image.asset(
                  //       "assets/images/logo.png",
                  //       width: 30,
                  //       color: currentIndex == 4 ? Colors.white : null,
                  //     ),
                  //   ),
                  // ),
                  // floatingActionButtonLocation:
                  //     FloatingActionButtonLocation.centerDocked,
                  // bottomNavigationBar: BottomAppBar(
                  //   elevation: 0,
                  //   color: isDarkMode ? bgColor.lighten() : bgColor.darken(),
                  //   height: 60,
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  //   shape: const CircularNotchedRectangle(),
                  //   notchMargin: 8.0,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               currentIndex = 0;
                  //             });
                  //             _controller.animateToPage(
                  //               currentIndex,
                  //               duration: 600.ms,
                  //               curve: Curves.fastEaseInToSlowEaseOut,
                  //             );
                  //           },
                  //           child: Center(
                  //             child: SvgPicture.asset(
                  //               "assets/icons/nav_icons/car.svg",
                  //               width: 20,
                  //               color: currentIndex == 0
                  //                   ? purplePalette
                  //                   : textColor.withOpacity(.4),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               currentIndex = 1;
                  //             });
                  //             _controller.animateToPage(
                  //               currentIndex,
                  //               duration: 600.ms,
                  //               curve: Curves.fastEaseInToSlowEaseOut,
                  //             );
                  //           },
                  //           child: Center(
                  //             child: SvgPicture.asset(
                  //               "assets/icons/nav_icons/food.svg",
                  //               width: 20,
                  //               color: currentIndex == 1
                  //                   ? purplePalette
                  //                   : textColor.withOpacity(.4),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       const Gap(75),
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               currentIndex = 2;
                  //             });
                  //             _controller.animateToPage(
                  //               currentIndex,
                  //               duration: 600.ms,
                  //               curve: Curves.fastEaseInToSlowEaseOut,
                  //             );
                  //           },
                  //           child: Center(
                  //             child: SvgPicture.asset(
                  //               "assets/icons/nav_icons/doctor.svg",
                  //               width: 20,
                  //               color: currentIndex == 2
                  //                   ? purplePalette
                  //                   : textColor.withOpacity(.4),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               currentIndex = 3;
                  //             });
                  //             _controller.animateToPage(
                  //               currentIndex,
                  //               duration: 600.ms,
                  //               curve: Curves.fastEaseInToSlowEaseOut,
                  //             );
                  //           },
                  //           child: Center(
                  //             child: SvgPicture.asset(
                  //               "assets/icons/nav_icons/parcel.svg",
                  //               width: 20,
                  //               color: currentIndex == 3
                  //                   ? purplePalette
                  //                   : textColor.withOpacity(.4),
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                );
              },
            ),
          ),
          if (isLoading) ...{
            Positioned.fill(
                child: Container(
              color: Colors.black.withOpacity(.5),
              child: FullScreenLoader(
                showText: false,
                size: size.width * .3,
              ),
            ))
          },
        ],
      ),
    );
  }

  Future<void> book() async {
    final UserModel? user = ref.watch(currentUser);
    if (user == null) {
      throw "NO USER FOUND!";
    }

    setState(() {
      isLoading = true;
    });
    _vm.updateID(user.id);
    // final BookingPayload payload = BookingPayload(
    //   userID: user.id,
    //   type: 5,
    //   transpoType: 2,
    //   note: note,
    //   passengers: passengerCount,
    //   withPet: withPet,
    //   luggage: luggageCount,
    //   additionalInstructions: instructs,
    //   departureTime: pickupTime!,
    //   departureDate: pickupDateTime,
    //   destination: dest!,
    //   isWheelchairFriendly: wheelChairFriendly,
    //   pickupLocation: pickUpLocation,
    //   price: price,
    // );
    await _vm.value.book().then((val) {
      if (val) {
        _vm.reset();
        context.pushReplacement('/');
      }
      isLoading = false;
      if (mounted) setState(() {});
      // if (val) {
      //   context.pop();
      //   return;
      // }
    });
    return;
  }
}

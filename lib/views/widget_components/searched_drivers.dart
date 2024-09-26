import 'package:able_me/app_config/global.dart';
import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/firebase/driver_data.dart';
import 'package:able_me/services/firebase/connection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SearchedDriversViewer extends ConsumerStatefulWidget {
  const SearchedDriversViewer({super.key, required this.riderCallback});
  // final SearchDriversConfiguration config;
  final ValueChanged<DriverDataModel> riderCallback;
  @override
  ConsumerState<SearchedDriversViewer> createState() =>
      _SearchedDriversViewerState();
}

class _SearchedDriversViewerState extends ConsumerState<SearchedDriversViewer>
    with ColorPalette {
  final FirebaseConnection connection = FirebaseConnection();
  // late SearchDriversConfiguration config = widget.config;
  final _dataProvider = StateProvider<List<DriverDataModel>>((ref) => []);
  drivers() {
    connection.streamData().listen((v) {
      final List<DriverDataModel> res =
          v.docs.map((e) => DriverDataModel.fromFirestore(e)).toList();
      ref.read(_dataProvider.notifier).update((s) => res);
      riderIDs = res.map((e) => e.id).toList();
      if (mounted) setState(() {});
    });
  }

  @override
  initState() {
    drivers();
    super.initState();
  }

  // updateConfig(SearchDriversConfiguration newConfig) {
  //   setState(() {
  //     config = newConfig;
  //   });
  //   ref.invalidate(searchDriversProvider(config));
  // }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    var _data = ref.watch(_dataProvider);
    if (_data.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Text(
            "List of drivers",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
          ),
        ),
        const Gap(10),
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) {
            final DriverDataModel data = _data[i];
            return ListTile(
              onTap: () {
                widget.riderCallback(data);
              },
              tileColor: bgColor.lighten(),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              leading: SizedBox(
                width: 55,
                height: 55,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: SizedBox(
                          width: 55,
                          height: 55,
                          child: CachedNetworkImage(
                            imageUrl: data.avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: pastelPurple,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.group_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                            const Gap(4),
                            Text(
                              data.vehicle!.seats.toString(),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              titleTextStyle: TextStyle(
                  color: textColor,
                  fontFamily: "Montserrat",
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              title: Text(
                data.name.capitalizeWords(),
              ),
              //1 = active
              //0 = offline
              //2 = away
              //3 = busy
              trailing: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data.activeStatus == 1
                      ? Colors.green
                      : data.activeStatus == 0
                          ? Colors.grey
                          : data.activeStatus == 2
                              ? Colors.grey
                              : Colors.red,
                ),
              ),
              subtitle: Text(
                  "${data.vehicle!.carBrand} ${data.vehicle!.carModel}"
                      .capitalizeWords()),
              subtitleTextStyle: TextStyle(
                  fontFamily: "Montserrat", color: textColor.withOpacity(.5)),
            );
          },
          separatorBuilder: (_, i) => const SizedBox(
            height: 10,
          ),
          itemCount: _data.length,
        ),
      ],
    );
    // return switch (_data) {
    //   AsyncError(:final error) => Container(),
    //   AsyncData(:final value) => ListView.separated(
    // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    // shrinkWrap: true,
    // physics: const NeverScrollableScrollPhysics(),
    // itemBuilder: (_, i) {
    //   final Vehicle f = value[i];
    //   return ListTile(
    //     titleTextStyle: TextStyle(
    //         color: Colors.grey.shade800,
    //         fontFamily: "Montserrat",
    //         fontSize: 16,
    //         fontWeight: FontWeight.w600),
    //     title: Text(
    //       f.carBrand,
    //     ),
    //     subtitle: Text(f.carModel),
    //   );
    // },
    // separatorBuilder: (_, i) => const SizedBox(
    //   height: 10,
    // ),
    //       itemCount: value.length,
    //     ),
    //   _ => const CircularProgressIndicator.adaptive(),
    // };
  }
}

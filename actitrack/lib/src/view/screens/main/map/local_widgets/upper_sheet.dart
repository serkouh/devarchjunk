import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:actitrack/src/models/target_location.dart';
import 'package:actitrack/src/services/location/location_service.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/state/providers/map/map_state_provider.dart';
import 'package:actitrack/src/state/providers/tasks/ongoing_task_provider.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapViewUpperSheet extends StatelessWidget {
  const MapViewUpperSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 6.w,
          top: 18.h,
          child: Column(
            children: List.generate(
              6,
              (i) => Container(
                margin: EdgeInsets.only(bottom: 3.h),
                width: 2.w,
                height: 2.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF737373),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            FutureBuilder<String>(
              future: () async {
                Future<String> getCurrentAddress(Position position) async {
                  try {
                    MyLogger.info("ey");
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        position.latitude, position.longitude);
                    MyLogger.info("HI $placemarks");
                    if (placemarks.isNotEmpty) {
                      Placemark place = placemarks[0];
                      return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
                    } else {
                      return 'Unknown location';
                    }
                  } catch (e) {
                    return 'Error: $e';
                  }
                }

                final position = await Geolocator.getCurrentPosition();

                String address = await getCurrentAddress(position);

                return address;
              }(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildLocationTile(
                    context,
                    'POINT DE DÉPART',
                    location: snapshot.data ?? '...',
                  );
                }

                return Text("Encours...");
              },
            ),
            Gap(20.h),
            _buildLocationTile(
              context,
              'POINT DE DESTINATION',
              location: "45 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000",
              iconColor: Theme.of(context).colorScheme.secondary,
              multipleOptions: true,
            ),
            // Consumer<MapViewStateProvider>(
            //   builder: (context, MapViewStateProvider state, child) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         ChoiceChip(
            //           label: Icon(Icons.person),
            //           selected: state.travelMode == TravelMode.walking,
            //           onSelected: (selected) {
            //             state.travelMode = TravelMode.walking;
            //           },
            //         )
            //       ],
            //     );
            //   },
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationTile(
    BuildContext context,
    String title, {
    Color? circleColor,
    required String location,
    Color? iconColor,
    bool multipleOptions = false,
  }) {
    TargetLocation? _selectedTargetLocation =
        context.read<MapViewStateProvider>().selectedTargetLocation;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 13.h,
              color: iconColor,
            ),
            Gap(5.w),
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ],
        ),
        if (!multipleOptions) Gap(4.h),
        Row(
          children: [
            Gap(13.h),
            Gap(6.w),
            Expanded(
              child: multipleOptions
                  ? StatefulBuilder(builder: (context, onSetState) {
                      return DropdownButton<TargetLocation?>(
                          icon: const SizedBox.shrink(),
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const Text(
                                "Sélectionnez une adresse de destination",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Icon(
                                Icons.arrow_right_rounded,
                                size: 25.sp,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          value: _selectedTargetLocation,
                          onChanged: (value) {
                            if (value != null &&
                                value.name != _selectedTargetLocation?.name) {
                              context
                                  .read<MapViewStateProvider>()
                                  .drawPolylineRoute(value);
                              onSetState(() {
                                _selectedTargetLocation = value;
                              });
                            }
                          },
                          padding: EdgeInsets.zero,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                          items: (context
                                      .watch<OngoingTaskProvider>()
                                      .currentTask!
                                      .locations ??
                                  [])
                              .where((location) =>
                                  location.deliveryCompleted == false)
                              .map((location) {
                            // location.name.toLowerCase().replaceAll(" ", '_'),
                            return DropdownMenuItem(
                              value: location,
                              child: Text(
                                location.name!,
                                textAlign: TextAlign.start,
                              ),
                            );
                          }).toList()

                          //  [
                          //   DropdownMenuItem(
                          //     value: 'value 1',
                          //     child: Text(
                          //       "vsssssssssssssssssssssssssssssssssssssssssssssssss",
                          //       textAlign: TextAlign.start,
                          //     ),
                          //   ),
                          //   DropdownMenuItem(
                          //     value: 'value 2',
                          //     child: Text("dsssssssssssssssssssssssssssssssssssssssssssssssss"),
                          //   ),
                          //   DropdownMenuItem(
                          //     value: 'value 3',
                          //     child: Text("fsssssssssssssssssssssssssssssssssssssssssssssssss"),
                          //   ),
                          // ],
                          );
                    })
                  : Text(
                      location,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

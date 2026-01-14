import 'dart:async';
import 'dart:convert';

import 'package:actitrack/src/services/api/tasks_service.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/models/target_location.dart';
import 'package:actitrack/src/models/task.dart';
import 'package:actitrack/src/services/location/location_service.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/state/providers/map/map_state_provider.dart';
import 'package:actitrack/src/state/providers/tasks/ongoing_task_provider.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:actitrack/src/view/screens/main/map/local_widgets/delivery_info_input_sheet/deliverable_type_sheet.dart';
import 'package:actitrack/src/view/screens/main/map/local_widgets/delivery_info_input_sheet/delivery_info_input_sheet.dart';
import 'package:actitrack/src/view/widgets/loading_box.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'delivery_info_input_sheet/delivery_uploaded_success_sheet.dart';

class MapView extends StatefulWidget {
  final Task? task;

  final void Function([bool?]) onMapTapped;
  const MapView({super.key, required this.onMapTapped, required this.task});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // late CameraPosition _cameraPosition;
  late Function(LocationData) onUserLocationChanged;
  bool _mapIsFullScreen = false;

  @override
  void initState() {
    super.initState();
    onUserLocationChanged = (LocationData locationData) {
      // if (context.read<MapViewStateProvider>().isRouteDrawn) {
      MyLogger.info(
          "User location changed: ${locationData.latitude}, ${locationData.longitude}");
      final newUserLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      context.read<MapViewStateProvider>().setLiveUserLocation(newUserLocation,
          isMapInFullscreenMode: _mapIsFullScreen);
      //}
      Timer.periodic(Duration(seconds: 120), (timer) {
        updatelocation(
          locationData, //widget.task.zone
        );
      });
    };

    serviceLocator<LocationService>()
        .location
        .onLocationChanged
        .listen(onUserLocationChanged);
  }

  Future<void> updatelocation(LocationData location) async {
    final url = Uri.parse('$baseUrl/animateur/update/location');

    String? token = Prefs.getUserAccessToken();
    final Map<String, dynamic> body = {
      "latitude": location.latitude,
      "longitude": location.longitude,
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      /* print("++++++++++++++++++++++++++++++++");
      print(url);
      print(token);
      print(response.body);*/
      if (response.statusCode == 200) {
        // MyLogger.info(response.body);
      } else {
        // throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _mapIsFullScreen = false;
    super.dispose();
  }

  String? deliveryType;
  void showSaveDeliveryInfoSheet(TargetLocation location) async {
    // Always display DeliverableTypeSheet
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        showDragHandle: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: 0.85.sh,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        builder: (context) {
          return DeliverableTypeSheet(
            location: location,
            show: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                showDragHandle: true,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  minHeight: 0.65.sh,
                  maxHeight: 0.8.sh,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                builder: (context) {
                  MyLogger.info("ALL OBJECTS: ${location.distributionObjects}");
                  return DeliveryInfoInputSheet(
                      distributionObject: location.Selectedobject!,
                      tasklocationid: location.id.toString());
                },
              );
            },
          );
        });

    /*final bool isSuccessful = await
    // If delivery info is successfully saved, show confirmation
    if (isSuccessful) {
      MyLogger.info('Delivery info saved successfully');
      final repeatRes = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        showDragHandle: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: 0.85.sh,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        builder: (context) {
          return const DeliveryUploadedSuccessSheet();
        },
      );

      // If user wants to repeat the process, call the function again
      if (repeatRes == true) {
        showSaveDeliveryInfoSheet(location);
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    //TODO: make sure the app is online
    // final OngoingTaskProvider ongoingTaskProvider = Provider.of<OngoingTaskProvider>(context);
    // final Task? ongoingTask = ongoingTaskProvider.currentTask;
    // if (ongoingTask == null) {
    //   return Container();
    // }
    // return FutureBuilder(
    //   future: initializeMap(ongoingTask),
    //   builder: (context, snap) {
    //     if (snap.hasData && snap.data == true) {
    //       return _buildMap();
    //     }
    //     return const LoadingBox(fullScreen: true);
    //   },
    // );
    return Consumer<MapViewStateProvider>(
      builder: (context, mapViewStateProvider, child) {
        if (mapViewStateProvider.isLoading) {
          return const Center(
            child: Text("Loading..."),
          );
        }
        return _buildMap(mapViewStateProvider);
      },
    );
  }

  Widget _buildMap(MapViewStateProvider mapViewStateProvider) {
    return GoogleMap(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top,
      ),
      // padding: EdgeInsets.only(
      //   top: widget.rideStep == RideStep.choosePickupDest ? TOP_BAR_HEIGHT : 0,
      //   bottom: (widget.rideStep == RideStep.chooseRideOptions || widget.rideStep == RideStep.findingDriver)
      //       ? widget.isSheetExpanded
      //           ? (MediaQuery.of(context).size.height - 20) * INITIAL_SHEET_HEIGHT
      //           : (MediaQuery.of(context).size.height - 20) * MIN_SHEET_HEIGHT
      //       : widget.rideStep == RideStep.confirmPickup
      //           ? PICKUP_SHEET_HEIGHT
      //           : 0,
      // ),

      polygons: mapViewStateProvider.polygons,
      markers: mapViewStateProvider.markers.map((marker) {
        if (marker.markerId.value == 'destination_marker') {
          return marker.copyWith(
            onTapParam: () async {
              MyLogger.info('Dest Marker tapped: ${marker.infoWindow.title}');
              final destinationLocation =
                  mapViewStateProvider.destinationLocation;
              final userLocation = mapViewStateProvider.userLiveLocation;
              if (userLocation != null && destinationLocation != null) {
                final distanceBetween =
                    FuncHelpers.calculateDistanceBetweenTwoPoints(
                        userLocation, destinationLocation);
                if (distanceBetween > 1000) {
                  MyLogger.info(
                      'Distance between source and destination: $distanceBetween');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        title: Column(
                          children: [
                            Text(
                              'Destination Trop Loin!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            Gap(25.h),
                            DistanceIndicator(
                              distanceCovered:
                                  FuncHelpers.calculateDistanceBetweenTwoPoints(
                                mapViewStateProvider.sourceLocation!,
                                mapViewStateProvider.userLiveLocation!,
                                km: true,
                              ),
                              totalDistance:
                                  FuncHelpers.calculateDistanceBetweenTwoPoints(
                                mapViewStateProvider.sourceLocation!,
                                mapViewStateProvider.destinationLocation!,
                                km: true,
                              ),
                            ),
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "La destination est trop éloignée de l'endroit où vous vous trouvez actuellement",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              Gap(5.h),
                              Text.rich(
                                TextSpan(
                                  children: const [
                                    TextSpan(
                                      text: 'Vous devez être à au moins ',
                                    ),
                                    TextSpan(
                                      text: '1 Km',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' plus près de votre destination pour mettre fin à cette livraison',
                                    ),
                                  ],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              showSaveDeliveryInfoSheet(
                                mapViewStateProvider.selectedTargetLocation!,
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 15.h, horizontal: 20.w),
                              ),
                            ),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                } else {
                  print("clicked");
                  showSaveDeliveryInfoSheet(
                      mapViewStateProvider.selectedTargetLocation!);
                }

                /* showSaveDeliveryInfoSheet(
                    mapViewStateProvider.selectedTargetLocation!);*/
              }
            },
          );
        }
        if (marker.markerId.value == 'source_marker') {
          return marker.copyWith(
            onTapParam: () {
              MyLogger.info('Source Marker tapped: ${marker.infoWindow.title}');
            },
          );
        }
        if (marker.markerId.value == 'user_marker') {
          return marker.copyWith(
            onTapParam: () {
              MyLogger.info(
                  'User Location Marker tapped: ${marker.infoWindow.title}');
            },
          );
        }

        if (marker.markerId.value.startsWith('success')) {
          return marker.copyWith(
            onTapParam: () {
              MyLogger.info(
                  'Success Marker tapped: ${marker.infoWindow.title}');
              //TODO: show a details dialog or something
            },
          );
        }

        return marker.copyWith(
            visibleParam: mapViewStateProvider.showAllLocationsMarkers);

        // TargetLocation inactiveMarkerTargetLocation = context.read<OngoingTaskProvider>().currentTask!.locations.firstWhere(
        //       (element) => element.name.toLowerCase().replaceAll(" ", '_') == marker.infoWindow.title,
        //     );
        // return marker.copyWith(
        //   infoWindowParam: InfoWindow(
        //     title: inactiveMarkerTargetLocation.name.toLowerCase().replaceAll(" ", '_'),
        //   ),
        //   onTapParam: () {
        //     mapViewStateProvider.drawPolylineRoute(inactiveMarkerTargetLocation);
        //   },
        // );
      }).toSet(),
      polylines: mapViewStateProvider.polylines,
      // style: mapViewStateProvider.mapStyleString,
      initialCameraPosition: mapViewStateProvider.cameraPosition,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      compassEnabled: false,
      onTap: (tapCoordinates) {
        setState(() {
          _mapIsFullScreen = !_mapIsFullScreen;
        });
        widget.onMapTapped.call();
      },
      onMapCreated: (GoogleMapController controller) {
        // mapViewStateProvider.completeController(controller);
        mapViewStateProvider.completeController(controller);
      },
      onCameraMoveStarted: () {
        // if (widget.rideStep == RideStep.choosePickupDest) {
        //   widget.sheetController.animateTo(
        //     0,
        //     duration: const Duration(milliseconds: 200),
        //     curve: Curves.easeInOut,
        //   );
        // }
        if (!mapViewStateProvider.mapBeingDragged) {
          setState(() {
            _mapIsFullScreen = true;
          });
          widget.onMapTapped.call(true);
          mapViewStateProvider.setMapBeingDragged(true);
        }
      },
      onCameraIdle: () async {
        if (mapViewStateProvider.mapBeingDragged) {
          mapViewStateProvider.setMapBeingDragged(false);
        }
      },

      // polylines: {
      //   (widget.rideStep == RideStep.chooseRideOptions || widget.rideStep == RideStep.findingDriver)
      //       ? Polyline(
      //           polylineId: const PolylineId('route'),
      //           color: AppColors.primaryBlack.withOpacity(0.9),
      //           points: polylineCoordinates,
      //           width: 4,
      //           endCap: Cap.roundCap,
      //           startCap: Cap.roundCap,
      //         )
      //       : const Polyline(polylineId: PolylineId('polyline')),
      // },

      // polylines: {
      //   (widget.rideStep == RideStep.chooseRideOptions || widget.rideStep == RideStep.findingDriver)
      //       ? Polyline(
      //           polylineId: const PolylineId('route'),
      //           color: AppColors.primaryBlack.withOpacity(0.9),
      //           points: _polylineCoordinates,
      //           width: 4,
      //           endCap: Cap.roundCap,
      //           startCap: Cap.roundCap,
      //         )
      //       : const Polyline(polylineId: PolylineId('polyline')),
      // },

      /// markers
      // markers: {
      //   Marker(
      //     markerId: const MarkerId('source'),
      //     position: _sourceLocation,
      //     icon: markerIconDp,
      //     infoWindow: InfoWindow(
      //       title: "Tache #5",
      //       snippet: "Driisyam Sidi msmodi, 900 N50",
      //     ), // In
      //   ),
      //   Marker(
      //     markerId: const MarkerId('destination'),
      //     position: _destinationLocation,
      //     icon: markerIconDs,
      //   )
      //   //   /// this marker is just for testing the map center it uses the _mapChosenLocation
      //   //   Marker(
      //   //     markerId: const MarkerId('1'),
      //   //     position: _mapChosenLocation,
      //   //   ),
      //   //   (widget.rideStep == RideStep.chooseRideOptions || widget.rideStep == RideStep.findingDriver)
      //   //       ? Marker(
      //   //           markerId: const MarkerId('source'),
      //   //           position: _sourceLocation,
      //   //           icon: markerIconDp,
      //   //         )
      //   //       : const Marker(markerId: MarkerId('source')),
      //   //   (widget.rideStep == RideStep.chooseRideOptions || widget.rideStep == RideStep.findingDriver)
      //   //       ? Marker(
      //   //           markerId: const MarkerId('destination'),
      //   //           position: _destinationLocation,
      //   //           icon: markerIconDs,
      //   //         )
      //   //       : const Marker(markerId: MarkerId('destination')),
      // },
    );
  }
}

class DistanceIndicator extends StatelessWidget {
  final double distanceCovered;
  final double totalDistance;

  DistanceIndicator(
      {required this.distanceCovered, required this.totalDistance});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        border: Border.all(color: Colors.black, width: 2.w),
      ),
      padding: EdgeInsets.all(16.0.w),
      alignment: Alignment.center,
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constrains) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 20),
                    painter: DistancePainter(distanceCovered, totalDistance),
                  ),
                  Positioned(
                    top: -26.h,
                    right: -12.w,
                    child: Image.asset(
                      height: 30.h,
                      Assets.kPng_BrochureMarker,
                    ),
                  ),
                  Positioned(
                    top: -26.h,
                    left: -12.w,
                    child: Image.asset(
                      height: 30.h,
                      Assets.kPng_SourceMarker,
                    ),
                  ),
                  Positioned(
                    top: -26.h,
                    left: (constrains.maxWidth - 24.w) *
                        (distanceCovered / totalDistance),
                    child: Image.asset(
                      height: 30.h,
                      Assets.kPng_UserLocationMarker,
                    ),
                  ),
                ],
              );
            },
          ),
          Gap(5.h),
          Text(
            '${(totalDistance - distanceCovered).toStringAsFixed(2)} km restants pour la destination',
            style: TextStyle(color: Colors.black, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

class DistancePainter extends CustomPainter {
  final double distanceCovered;
  final double totalDistance;

  DistancePainter(this.distanceCovered, this.totalDistance);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..strokeWidth = 4;

    final completedPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4;

    double completedLineLength = (distanceCovered / totalDistance) * size.width;

    // Draw the completed part of the line
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(completedLineLength, size.height / 2), completedPaint);

    // Draw the remaining part of the line
    canvas.drawLine(Offset(completedLineLength, size.height / 2),
        Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:async';
import 'package:actitrack/src/models/distribution_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:actitrack/src/config/constants/palette.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/models/target_location.dart';
import 'package:actitrack/src/models/task.dart';
import 'package:actitrack/src/services/location/location_service.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';

class MapViewStateProvider extends ChangeNotifier {
  Completer<GoogleMapController>? _controller =
      Completer<GoogleMapController>();
  TravelMode _travelMode = TravelMode.walking;
  List<TargetLocation> _targetLocations = [];
  late CameraPosition _cameraPosition;

  bool _isLoading = true;
  bool _showAllLocationsMarkers = true;
  bool _isMapBeingDragged = false;
  bool _isDrawingRoute = false;
  // final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  String? _mapStyleString;
  LatLng? _sourceLocation;
  LatLng? _destinationLocation;
  LatLng? _liveUserLocation;
  String? _drawnRouteDistance = '';

  TargetLocation? _selectedTargetLocation;
  final Set<LatLng> _polylineCoordinates = {};
  final Set<LatLng> _userToDesPolylineCoordinates = {};
  final Set<Polygon> _polygons = {};
  final Set<Marker> _markers = {};
  late BitmapDescriptor markerIconDp;
  late BitmapDescriptor markerIconBrochureDs;
  late BitmapDescriptor markerIconInactiveBrochureDs;
  late BitmapDescriptor markerIconUser;
  late BitmapDescriptor markerIconSuccessDelivery;

  // MapViewStateProvider() {
  //   // Initialize any necessary data here
  // }

  Completer<GoogleMapController> get controller => _controller!;

  // set controller(Completer<GoogleMapController> val) {
  //   _controller = val;
  //   notifyListeners();
  // }

  // disposeOfContoller() {
  //   _controller?.future.then((value) {
  //     value.dispose();
  //   });
  // }

  completeController(ctrler) {
    _controller?.complete(ctrler);
  }

  TargetLocation? get selectedTargetLocation => _selectedTargetLocation;
  set selectedTargetLocation(TargetLocation? value) {
    _selectedTargetLocation = value;
    notifyListeners();
  }

  bool get showAllLocationsMarkers => _showAllLocationsMarkers;
  set showAllLocationsMarkers(bool value) {
    _showAllLocationsMarkers = value;
    notifyListeners();
  }

  List<TargetLocation> get targetLocations => _targetLocations;
  set targetLocations(List<TargetLocation> value) {
    _targetLocations = value;
    notifyListeners();
  }

  String? get drawnRouteDistance => _drawnRouteDistance;
  set drawnRouteDistance(String? value) {
    _drawnRouteDistance = value;
    notifyListeners();
  }

  TravelMode get travelMode => _travelMode;
  set travelMode(TravelMode value) {
    _travelMode = value;
    notifyListeners();
  }

  bool get isDrawingRoute => _isDrawingRoute;
  set isDrawingRoute(bool value) {
    _isDrawingRoute = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // void completeController(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }

  // Completer<GoogleMapController> get controller => _controller;
  bool get isRouteDrawn =>
      _polylineCoordinates.isNotEmpty &&
      _sourceLocation != null &&
      _destinationLocation != null;
  String? get mapStyleString => _mapStyleString;
  CameraPosition get cameraPosition => _cameraPosition;
  LatLng? get userLiveLocation => _liveUserLocation;
  LatLng? get sourceLocation => _sourceLocation;
  LatLng? get destinationLocation => _destinationLocation;
  bool get mapBeingDragged => _isMapBeingDragged;
  Set<Polygon> get polygons => _polygons;
  Set<Marker> get markers => _markers;
  Set<LatLng> get polylineCoordinates => _polylineCoordinates;
  Set<LatLng> get userToDestinationPolyPoints => _userToDesPolylineCoordinates;
  Set<Polyline> get polylines => {
        if (polylineCoordinates.isNotEmpty)
          Polyline(
            polylineId: const PolylineId('source_destination_route'),
            color: Colors.red,
            points: polylineCoordinates.toList(),
            width: 4,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
          ),
        if (userToDestinationPolyPoints.isNotEmpty)
          Polyline(
            polylineId: const PolylineId('user_destination_route'),
            color: kSecondaryColor,
            points: userToDestinationPolyPoints.toList(),
            width: 4,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
          )

        // : const Polyline(
        //     polylineId: PolylineId('polyline'),
        //   ),
      };

  void resetAll({bool notify = true}) {
    _targetLocations = <TargetLocation>[];
    _showAllLocationsMarkers = true;
    _controller = Completer<GoogleMapController>();
    _isLoading = true;
    _isMapBeingDragged = false;
    _isDrawingRoute = false;
    _travelMode = TravelMode.walking;
    _cameraPosition = CameraPosition(
      target: LatLng(0, 0), // Set a default position, you can adjust as needed
      zoom: 1.0, // Set a default zoom level, you can adjust as needed
    );
    // _mapStyleString = null;
    _sourceLocation = null;
    _destinationLocation = null;
    _liveUserLocation = null;
    _drawnRouteDistance = '';
    _selectedTargetLocation = null;
    _polylineCoordinates.clear();
    _userToDesPolylineCoordinates.clear();
    _polygons.clear();
    _markers.clear();

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> initializeMap(Task ongoingTask) async {
    final List<TargetLocation> zoneLocations = ongoingTask.locations ?? [];

    final List<LatLng> zoneCoords = ongoingTask.coordinates;

    try {
      await loadMapStyles();
      await getMarkerIcons();
      _polylineCoordinates.clear();
      _userToDesPolylineCoordinates.clear();
      _markers.clear();
      _polygons.clear();
      if (zoneLocations.isNotEmpty) {
        _targetLocations = zoneLocations;
        convertZoneLocationsToMarkers(zoneLocations);
      }
      if (zoneCoords.isNotEmpty) {
        _cameraPosition = CameraPosition(
          target: FuncHelpers.calculateCoordsCenter(zoneCoords),
          zoom: 14.5,
        );
        convertZoneCoordsToPolygon(ongoingTask.zone!.locations);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      MyLogger.error(e);
    }
  }

  Future<void> loadMapStyles() async {
    if (_mapStyleString != null) {
      return;
    }
    _mapStyleString =
        await rootBundle.loadString('assets/data/map_styles.json');
    notifyListeners();
  }

  Future<void> getMarkerIcons() async {
    Future<BitmapDescriptor> loadMarkerAsset(String asset) =>
        BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 2.5),
          asset,
        );
    markerIconDp = await loadMarkerAsset(Assets.kPng_SourceMarker);
    markerIconBrochureDs = await loadMarkerAsset(Assets.kPng_BrochureMarker);
    markerIconUser = await loadMarkerAsset(Assets.kPng_UserLocationMarker);
    markerIconSuccessDelivery =
        await loadMarkerAsset(Assets.kPng_SuccessDeliveryMarker);
    markerIconInactiveBrochureDs =
        await loadMarkerAsset(Assets.kPng_InactiveBrochureMarker);
    notifyListeners();
  }

  Future<PolylineResult?> getPolyPoints(LatLng from, LatLng to) async {
    MyLogger.info('Getting route between the points');
    MyLogger.info('From: $from');
    MyLogger.info('To: $to');
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      //TODO: replace the test by the real api key, which needs to have payment activated
      // final googleMapApi = "AIzaSyCzGcu4QfKJsyDCAC0IZGgfmjLjCC--zTo";
      final googleMapApiTEST = "AIzaSyCVgRxsFUXudZRBOCtja3AjV85Gr8VSiTc";
      print(from.latitude);
      print(from.longitude);
      print(to.latitude);
      print(to.longitude);
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapApiTEST,
        // googleMapApi,
        PointLatLng(from.latitude, from.longitude),
        PointLatLng(to.latitude, to.longitude),
        //  travelMode: travelMode,
      );
      MyLogger.info('Result: $result');
      MyLogger.info('Status: ${result.status}');
      MyLogger.info('Points: ${result.points}');

      if (result.status != 'OK') {
        MyLogger.error('Failed to get route between the points');
        MyLogger.info(result.errorMessage);
        return null;
      }

      if (result.points.isNotEmpty) {
        return result;
        // for (PointLatLng point in result.points) {
        //   retVal['points'].add(LatLng(point.latitude, point.longitude));
        // }
      }
    } catch (e) {
      MyLogger.error(e);
    }
    return null;
  }

  markTargetLocationAsCompleted(TargetLocation targetLocation) {
    int index = targetLocations
        .indexWhere((location) => location.id == targetLocation.id);
    MyLogger.info(targetLocations);
    MyLogger.info("Target location index: $index");
    _targetLocations[index] = targetLocation.copyWith(deliveryCompleted: true);
    if (_targetLocations[index].deliveryCompleted) {
      _polylineCoordinates.clear();
      //convertZoneLocationsToMarkers(targetLocations);
      convertZoneCoordsToPolygon(
        targetLocations.map((location) => location.coordinates).toList(),
        color: targetLocations.every((location) => location.deliveryCompleted)
            ? kSuccessColor
            : kSecondaryColor,
      );
      final CameraPosition newCameraPosition =
          CameraPosition(target: targetLocation.coordinates, zoom: 13.0);
      updateCameraPosition(newCameraPosition);
      controller.future.then(
        (ctrler) => ctrler.animateCamera(
          CameraUpdate.newCameraPosition(newCameraPosition),
        ),
      );
      _showAllLocationsMarkers = true;
      _selectedTargetLocation = null;
      // for (Marker marker in _markers) {
      //   if (marker.markerId.value == targetLocation.name.toLowerCase().replaceAll(" ", '_')) {
      //     MyLogger.info("Marker FOUND: ${marker.markerId}");
      //     _markers.remove(marker);
      //     _markers.add(
      //       Marker(
      //         markerId: MarkerId("success_${targetLocation.name.toLowerCase().replaceAll(" ", '_')}"),
      //         position: targetLocation.coordinates,
      //         icon: markerIconSuccessDelivery,
      //         onTap: () {
      //           MyLogger.info('Completed Marker tapped: ${targetLocation.name}');
      //         },
      //         infoWindow: InfoWindow(
      //           title: targetLocation.name,
      //         ),
      //       ),
      //     );
      //   }
      // }
    }
    notifyListeners();
  }

  void convertZoneCoordsToPolygon(List<LatLng> zoneCoords,
      {Color color = kSecondaryColor}) {
    _polygons.add(
      Polygon(
        polygonId: const PolygonId('task_zone'),
        points: zoneCoords,
        strokeColor: color, // Replace with your desired color
        strokeWidth: 2,
        fillColor: color.withOpacity(0.2), // Replace with your desired color
      ),
    );
    notifyListeners();
  }

  void convertZoneLocationsToMarkers(List<TargetLocation> zoneLocations) {
    if (markers.isNotEmpty) _markers.clear();
    for (TargetLocation location in zoneLocations) {
      bool finished = true;
      for (DistributionObject location in location.distributionObjects) {
        if (location.distributed < location.quantity) {
          finished = false;
        }
      }
      _markers.add(
        finished
            ? Marker(
                markerId: MarkerId(
                    "success_${location.name?.toLowerCase().replaceAll(" ", '_')}"),
                position: location.coordinates,
                icon: markerIconSuccessDelivery,
                onTap: () {
                  MyLogger.info('Completed Marker tapped: ${location.name}');
                  //drawPolylineRoute(location);
                },
                infoWindow: InfoWindow(
                  title: location.name,
                ),
              )
            : Marker(
                markerId:
                    MarkerId(location.name!.toLowerCase().replaceAll(" ", '_')),
                position: location.coordinates,
                icon: markerIconBrochureDs,
                onTap: () {
                  MyLogger.info('Marker tapped: ${location.name}');
                  drawPolylineRoute(location);
                },
                infoWindow: InfoWindow(
                  title: location.name,
                ),
              ),
      );
    }
    if (_liveUserLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _liveUserLocation!,
          icon: markerIconUser,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> drawPolylineRoute(TargetLocation targetLocation) async {
    try {
      isDrawingRoute = true;
      final destination = targetLocation.coordinates;
      Position? userPosition =
          await serviceLocator<LocationService>().getCurrentPosition();
      if (userPosition != null) {
        _sourceLocation = /*LatLng(35.75358718,
            -5.8127599)*/
            LatLng(userPosition.latitude, userPosition.longitude);
        _liveUserLocation = _sourceLocation;
        _destinationLocation = destination;
        PolylineResult? polyPointsResult =
            await getPolyPoints(_sourceLocation!, _destinationLocation!);
        MyLogger.info(
            'results latitude: ${_sourceLocation!.latitude.toString()}');
        MyLogger.info('results: ${polyPointsResult}');
        // PolylineResult? userToDestinationPolyPointsResult = await getPolyPoints(_liveUserLocation!, _destinationLocation!);
        if (polyPointsResult != null) {
          List<LatLng> polyPoints = [];
          for (PointLatLng point in polyPointsResult.points) {
            polyPoints.add(LatLng(point.latitude, point.longitude));
          }

          List<Marker> newMarkers = [];

          // if (showAllLocationsMarkers) {
          for (TargetLocation location in targetLocations) {
            if (location.name != targetLocation.name &&
                !location.deliveryCompleted) {
              newMarkers.add(
                Marker(
                  visible: showAllLocationsMarkers,
                  markerId: MarkerId(
                      location.name!.toLowerCase().replaceAll(" ", '_')),
                  position: location.coordinates,
                  icon: markerIconInactiveBrochureDs,
                  zIndex: 0.0,
                  infoWindow: InfoWindow(
                    title: location.name,
                  ),
                  onTap: () {
                    MyLogger.info('Marker tapped: ${location.name}');
                    drawPolylineRoute(location);
                  },
                ),
                // marker.copyWith(
                //   zIndexParam: 0.0,
                //   iconParam: markerIconInactiveBrochureDs,
                //   // onTapParam: () {
                //   //   MyLogger.info('Marker tapped: ${marker.infoWindow.title}');
                //   //   // TargetLocation inactiveMarkerTargetLocation = marker.position
                //   //   TargetLocation inactiveMarkerTargetLocation = targetLocations.firstWhere((element) => element.name.toLowerCase().replaceAll(" ", '_') == marker.infoWindow.title);
                //   //   drawPolylineRoute(inactiveMarkerTargetLocation);
                //   // },
                // ),
              );
            }
          }
          // }

          newMarkers.addAll(
            [
              if (_sourceLocation != null)
                Marker(
                  markerId: const MarkerId("source_marker"),
                  position: _sourceLocation!,
                  icon: markerIconDp,
                  zIndex: 1.0,
                  infoWindow: const InfoWindow(
                    title: "Point de Départ",
                  ),
                ),
              if (_destinationLocation != null)
                Marker(
                  markerId: const MarkerId("destination_marker"),
                  position: _destinationLocation!,
                  icon: markerIconBrochureDs,
                  zIndex: 1.0,
                  infoWindow: InfoWindow(
                    title: targetLocation.name,
                  ),
                ),
              if (_liveUserLocation != null)
                Marker(
                  markerId: const MarkerId("user_marker"),
                  position: _liveUserLocation!,
                  icon: markerIconUser,
                  zIndex: 2.0,
                  infoWindow: const InfoWindow(
                    title: "Moi",
                  ),
                ),
            ],
          );

          _markers.clear();
          _polygons.clear();
          _polylineCoordinates.clear();
          // _userToDesPolylineCoordinates.clear();

          isDrawingRoute = false;

          _markers.addAll(newMarkers);
          _polylineCoordinates.addAll(polyPoints);
          _drawnRouteDistance = polyPointsResult.distance;
          _selectedTargetLocation = targetLocation;
          _userToDesPolylineCoordinates.addAll(userToDestinationPolyPoints);
          notifyListeners();

          if (_liveUserLocation != null) {
            Future.delayed(const Duration(milliseconds: 600), () {
              final newCameraPosition = CameraPosition(
                target: _liveUserLocation!,
                zoom: 12.0,
              );
              updateCameraPosition(newCameraPosition);
              controller.future.then((ctrler) {
                ctrler.animateCamera(
                  CameraUpdate.newCameraPosition(newCameraPosition),
                );
              });
            });
          }
        }
      }
    } catch (e) {
      MyLogger.error(e);
      isDrawingRoute = false;
    }
    if (isDrawingRoute) {
      isDrawingRoute = false;
    }
  }

  void updateCameraPosition(CameraPosition position) {
    _cameraPosition = position;
    notifyListeners();
  }

  void setMapBeingDragged(bool value) {
    _isMapBeingDragged = value;
    notifyListeners();
  }

  void setLiveUserLocation(LatLng location,
      {bool isMapInFullscreenMode = false}) {
    _liveUserLocation = location;
    final Marker? userMarker = _markers.firstWhere(
        (marker) => marker.markerId.value == 'user_marker',
        orElse: () => const Marker(markerId: MarkerId('empty_marker')));
    if (userMarker != null && userMarker.markerId.value == 'user_marker') {
      MyLogger.info(
          'Updating user marker position from ${userMarker.position} to $location');
      _markers
        ..remove(userMarker)
        ..add(
          userMarker.copyWith(positionParam: location),
        );
      // if (!mapBeingDragged && !isMapInFullscreenMode) {
      // final newCameraPosition = CameraPosition(
      //   target: location,
      //   zoom: 17.0,
      // );
      // updateCameraPosition(newCameraPosition);
      // controller.future.then((ctrler) {
      //   ctrler.animateCamera(
      //     CameraUpdate.newCameraPosition(newCameraPosition),
      //   );
      // });
      // }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // disposeOfContoller();
    super.dispose();
  }
}

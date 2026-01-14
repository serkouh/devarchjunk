import 'dart:async';
import 'dart:ui' as ui;
import 'package:dotted_border/dotted_border.dart';
import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/pages/profile/language.dart';
import 'package:tennis/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final stationList = [
    {
      "image": "assets/home/cycle1.png",
      "address": "6391 Elgin St. Celina, Mumbai ,Maharashtra",
      "time": "15 min",
      "distance": "2.5 km",
      "available": 5,
      "battery": "90%",
      "range": "30-35 km",
      "latLang": const LatLng(51.518020, -0.180043),
      "id": 0
    },
    {
      "image": "assets/home/cycle3.png",
      "address": "8502 Preston Road, Mumbai ,Maharashtra",
      "time": "20 min",
      "distance": "3.5 km",
      "available": 10,
      "battery": "90%",
      "range": "30-35 km",
      "latLang": const LatLng(51.538992, -0.115456),
      "id": 1
    },
    {
      "image": "assets/home/cycle2.png",
      "address": "4140, Parker road,Mumbai ,Maharashtra",
      "time": "25 min",
      "distance": "4.5 km",
      "available": 6,
      "battery": "90%",
      "range": "30-35 km",
      "latLang": const LatLng(51.518020, -0.080757),
      "id": 2
    },
    {
      "image": "assets/home/cycle1.png",
      "address": "1901, Thornridge Cir, Mumbai ,Maharashtra",
      "time": "15 min",
      "distance": "2.5 km",
      "available": 8,
      "battery": "90%",
      "range": "30-35 km",
      "latLang": const LatLng(51.540447, -0.159087),
      "id": 4
    },
    {
      "image": "assets/home/cycle3.png",
      "address": "8502 Preston Road, Mumbai ,Maharashtra",
      "time": "20 min",
      "distance": "3.5 km",
      "available": 10,
      "battery": "90%",
      "range": "30-35 km",
      "latLang": const LatLng(51.498361, -0.072168),
      "id": 5
    },
    {
      "image": "assets/home/cycle2.png",
      "address": "4140, Parker road,Mumbai ,Maharashtra",
      "time": "25 min",
      "distance": "4.5 km",
      "available": 6,
      "battery": "90%",
      "range": "30-35 km",
      "latLang": const LatLng(51.497934, -0.172142),
      "id": 6
    },
  ];

  GoogleMapController? mapController;

  List<Marker> allMarkers = [];

  PageController pageController =
      PageController(viewportFraction: 0.9, initialPage: 1);
  double _currPageValue = 1.0;
  double scaleFactor = .8;
  double height = 150;

  static const CameraPosition _currentPosition =
      CameraPosition(target: LatLng(51.507351, -0.127758), zoom: 12);

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  marker() async {
    allMarkers.add(
      Marker(
        markerId: const MarkerId("your location"),
        position: const LatLng(51.507351, -0.127758),
        infoWindow: const InfoWindow(title: "You are here"),
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset("assets/home/location.png", 170),
        ),
      ),
    );

    for (int i = 0; i < stationList.length; i++) {
      allMarkers.add(Marker(
        markerId: MarkerId(stationList[i]['id'].toString()),
        position: stationList[i]['latLang'] as LatLng,
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset("assets/home/marker.png", 120),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          googleMap(size),
          stationListContent(size),
          profileImageAndSeach()
        ],
      ),
    );
  }

  profileImageAndSeach() {
    return Padding(
      padding: const EdgeInsets.only(
          top: fixPadding * 4.5,
          left: fixPadding * 2.0,
          right: fixPadding * 2.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 45,
              margin: languageValue == 4
                  ? const EdgeInsets.only(right: fixPadding * 3)
                  : const EdgeInsets.only(left: fixPadding * 3),
              padding: languageValue == 4
                  ? const EdgeInsets.only(
                      left: fixPadding * 2.0, right: fixPadding * 4)
                  : const EdgeInsets.only(
                      right: fixPadding * 2.0, left: fixPadding * 4),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.25),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTranslation(context, 'home.where_to_go'),
                      style: bold15Grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  widthSpace,
                  const Icon(
                    Icons.near_me,
                    color: primaryColor,
                  )
                ],
              ),
            ),
            languageValue == 4
                ? Positioned(
                    right: 0,
                    child: profileImage(),
                  )
                : Positioned(
                    left: 0,
                    child: profileImage(),
                  )
          ],
        ),
      ),
    );
  }

  profileImage() {
    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        color: whiteColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: whiteColor,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.25),
            blurRadius: 6,
          ),
        ],
        image: const DecorationImage(
          image: AssetImage("assets/home/userImage.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  stationListContent(Size size) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: fixPadding * 9,
      child: SizedBox(
        height: languageValue == 4 ? 210.0 : 195.0,
        width: size.width,
        child: PageView.builder(
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            moveCamera(stationList[index]['latLang'] as LatLng);
          },
          controller: pageController,
          itemCount: stationList.length,
          itemBuilder: (context, index) {
            return _buildListContent(index, size);
          },
        ),
      ),
    );
  }

  _buildListContent(int index, Size size) {
    Matrix4 matrix = Matrix4.identity();

    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          scaleFactor + (_currPageValue - index + 1) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
        ..setTranslationRaw(0.0, height * (1 - scaleFactor) / 2, 0.0);
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail');
      },
      child: Transform(
        transform: matrix,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: fixPadding, vertical: fixPadding / 2),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.25),
                blurRadius: 6,
              ),
            ],
          ),
          width: double.maxFinite,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: fixPadding, horizontal: fixPadding * 1.5),
                child: Row(
                  children: [
                    Image.asset(
                      stationList[index]['image'].toString(),
                      width: size.width * 0.4,
                      height: 85,
                    ),
                    widthSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stationList[index]['address'].toString(),
                            style: bold15BlackText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          height5Space,
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: greyColor,
                                size: 15,
                              ),
                              Expanded(
                                child: Text(
                                  "${stationList[index]['time']}/${stationList[index]['distance']}",
                                  style: semibold14Grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                          height5Space,
                          Text(
                            "${stationList[index]['available']} ${getTranslation(context, 'home.scooters_available')}",
                            style: bold15Primary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              height5Space,
              DottedBorder(
                padding: EdgeInsets.zero,
                dashPattern: const [3],
                color: greyColor,
                child: Container(
                  width: double.maxFinite,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: fixPadding * 1.5, vertical: fixPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  getTranslation(context, 'home.battery'),
                                  style: bold14Grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  stationList[index]['battery'].toString(),
                                  style: bold12BlackText,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: fixPadding),
                              height: 30,
                              width: 1,
                              color: greyColor,
                            ),
                            Expanded(
                              child: Align(
                                alignment: languageValue == 4
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text(
                                      getTranslation(context, 'home.range'),
                                      style: bold14Grey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      stationList[index]['range'].toString(),
                                      style: bold12BlackText,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      widthSpace,
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/detail');
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                              horizontal: fixPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: blackColor.withOpacity(0.25),
                                  blurRadius: 6)
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            getTranslation(context, 'home.go_detail'),
                            style: bold16White,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      widthSpace,
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/direction');
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  color: blackColor.withOpacity(0.25),
                                  blurRadius: 6)
                            ],
                          ),
                          child: const Icon(
                            Icons.near_me,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  moveCamera(LatLng target) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          bearing: 45.0,
          zoom: 14.0,
          tilt: 45.0,
        ),
      ),
    );
  }

  googleMap(Size size) {
    return SizedBox(
      height: double.maxFinite,
      width: size.width,
      child: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: _currentPosition,
        markers: Set.from(allMarkers),
        onMapCreated: mapCreated,
        zoomControlsEnabled: false,
      ),
    );
  }

  mapCreated(GoogleMapController controller) async {
    mapController = controller;
    await marker();
    if (mounted) {
      setState(() {});
    }
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}

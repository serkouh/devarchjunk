import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:actitrack/src/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/services/permissions/permissions_service.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/state/providers/map/map_state_provider.dart';
import 'package:actitrack/src/state/providers/tasks/ongoing_task_provider.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:actitrack/src/view/screens/main/map/local_widgets/task_progress_counter.dart';
import 'package:actitrack/src/view/widgets/loading_box.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animate_do/animate_do.dart' as anido;

import 'local_widgets/bottom_sheet.dart';
import 'local_widgets/map_view.dart';
import 'local_widgets/upper_sheet.dart';

class MapScreen extends StatefulWidget {
  final Task? task;
  MapScreen({super.key, this.task});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ValueNotifier<bool> _isMapFullScreenNotifier = ValueNotifier(true);

  void _toggleMapFullScreenState([bool? val]) {
    _isMapFullScreenNotifier.value = val ?? !_isMapFullScreenNotifier.value;
  }

  @override
  void initState() {
    super.initState();
    MyLogger.info("MapScreen initialized");

    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) {
        _isMapFullScreenNotifier.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    OngoingTaskProvider ongoingTaskProvider =
        Provider.of<OngoingTaskProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          MapView(
            task: widget.task,
            onMapTapped: _toggleMapFullScreenState,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isMapFullScreenNotifier,
            builder: (context, isMapFullScreen, _) {
              return Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  top: isMapFullScreen,
                  child: AnimatedContainer(
                    margin: EdgeInsets.all(isMapFullScreen ? 16.w : 0),
                    padding: EdgeInsets.only(
                      left: isMapFullScreen ? 0 : 16.w,
                      right: isMapFullScreen ? 0 : 16.w,
                      top: isMapFullScreen ? 0 : 16.w,
                    ),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn,
                    clipBehavior: Clip.antiAlias,
                    width: isMapFullScreen
                        ? 40.w
                        : FuncHelpers.getDeviceSize(context).width,
                    height: isMapFullScreen ? 40.w : 200.h,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(isMapFullScreen ? 9999 : 20.r),
                          bottomRight:
                              Radius.circular(isMapFullScreen ? 9999 : 20.r),
                          topLeft: Radius.circular(isMapFullScreen ? 9999 : 0),
                          topRight: Radius.circular(isMapFullScreen ? 9999 : 0),
                        ),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x30000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: isMapFullScreen
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Hero(
                                  tag: 'back-btn-icon',
                                  child: SizedBox(
                                    width: 40.w,
                                    height: 40.w,
                                    child: const Icon(Icons.arrow_back_rounded),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SafeArea(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: 'back-btn-icon',
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.arrow_back_rounded),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: anido.ElasticInDown(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        animate: !isMapFullScreen,
                                        child: const MapViewUpperSheet(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                    // child: AnimatedCrossFade(
                    //   crossFadeState: isMapFullScreen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    //   duration: Duration(milliseconds: isMapFullScreen ? 150 : 250),
                    //   firstCurve: Curves.easeIn,
                    //   secondCurve: Curves.easeIn,
                    //   firstChild: Material(
                    //     color: Colors.transparent,
                    //     child: InkWell(
                    //       onTap: () {},
                    //       child: Center(
                    //         child: Hero(
                    //           tag: 'back-btn-icon',
                    //           child: SizedBox(
                    //             width: 40.w,
                    //             height: 40.w,
                    //             child: const Icon(Icons.arrow_back_rounded),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   secondChild: SafeArea(
                    //     child: anido.FadeInDown(
                    //       // color: Colors.blue,
                    //       animate: !isMapFullScreen,
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Hero(
                    //             tag: 'back-btn-icon',
                    //             child: IconButton(
                    //               onPressed: () {},
                    //               icon: const Icon(Icons.arrow_back_rounded),
                    //             ),
                    //           ),
                    //           Expanded(
                    //             child: SingleChildScrollView(
                    //               child: Padding(
                    //                 padding: EdgeInsets.only(top: 10.h),
                    //                 child: const MapViewUpperSheet(),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SafeArea(
                    //   top: !isMapFullScreen,
                    //   bottom: !isMapFullScreen,
                    //   left: !isMapFullScreen,
                    //   right: !isMapFullScreen,
                    //   child: Container(
                    //     color: Colors.blue,
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Container(
                    //           color: Colors.red,
                    //           child: Icon(Icons.arrow_back_rounded),
                    //         ),
                    //         Expanded(
                    //           child: AnimatedCrossFade(
                    //             firstChild: const SizedBox.shrink(),
                    //             secondChild: _buildCurrentLocationDetails(),
                    //             crossFadeState: isMapFullScreen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    //             duration: const Duration(milliseconds: 200),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              );
            },
          ),
          if (context.watch<MapViewStateProvider>().isRouteDrawn)
            ValueListenableBuilder<bool>(
              valueListenable: _isMapFullScreenNotifier,
              builder: (context, isMapFullScreen, _) {
                return AnimatedPositioned(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 250),
                  left: 16.w,
                  top: !isMapFullScreen ? 150.h : (16.h + 45.w),
                  child: SafeArea(
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x30000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context
                                    .read<MapViewStateProvider>()
                                    .showAllLocationsMarkers =
                                !context
                                    .read<MapViewStateProvider>()
                                    .showAllLocationsMarkers;
                          },
                          child: Center(
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                SvgPicture.asset(
                                  Assets.kSvg_Locations,
                                  height: 19.w,
                                ),
                                if (context
                                    .watch<MapViewStateProvider>()
                                    .showAllLocationsMarkers)
                                  Transform.rotate(
                                    angle: math.pi / 6,
                                    child: Container(
                                      height: 3.w,
                                      width: 200.w,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(9999),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          if (context.watch<MapViewStateProvider>().isRouteDrawn)
            ValueListenableBuilder<bool>(
              valueListenable: _isMapFullScreenNotifier,
              builder: (context, isMapFullScreen, _) {
                return AnimatedPositioned(
                  bottom: !isMapFullScreen ? -180.h : 20.h,
                  left: 16.w,
                  right: 16.w,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.fastOutSlowIn,
                  child: TaskProgressCounter(
                      value: ((ongoingTaskProvider
                                  .currentTask?.flyersDistributed ??
                              0) /
                          (ongoingTaskProvider.currentTask?.flyersCount ?? 1))),
                );
              },
            ),
          ValueListenableBuilder<bool>(
            valueListenable: _isMapFullScreenNotifier,
            builder: (context, isMapFullScreen, _) {
              return AnimatedPositioned(
                bottom: isMapFullScreen ? -180.h : 0,
                left: 0,
                right: 0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                child: const MapViewBottomSheet(),
              );
            },
          ),
          if (context.watch<MapViewStateProvider>().isDrawingRoute)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 0,
              child: MapActionLoadingSheet(),
            )
        ],
      ),
    );
  }
}

class MapActionLoadingSheet extends StatelessWidget {
  const MapActionLoadingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        clipBehavior: Clip.antiAlias,
        width: MediaQuery.of(context).size.width,
        height: FuncHelpers.getDeviceSize(context).height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
        ),
        child: Center(
          child: anido.ElasticIn(
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 20.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x30000000),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.kSvg_Distance,
                    height: 50.h,
                  ),
                  Gap(10.h),
                  LinearProgressIndicator(
                    minHeight: 5.h,
                    borderRadius: BorderRadius.circular(9999),
                    color: Theme.of(context).primaryColor,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.05),
                  ),
                  Gap(5.h),
                  Text(
                    "Calculer le meilleur itinéraire vers votre prochaine destination...",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

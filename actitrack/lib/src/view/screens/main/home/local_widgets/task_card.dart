import 'dart:async';

import 'package:actitrack/src/config/constants/enums.dart';
import 'package:actitrack/src/services/api/tasks_service.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/view/screens/main/map/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/config/constants/constants.dart';
import 'package:actitrack/src/config/constants/palette.dart';
import 'package:actitrack/src/models/task.dart';
import 'package:actitrack/src/state/providers/map/map_state_provider.dart';
import 'package:actitrack/src/state/providers/tasks/ongoing_task_provider.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:actitrack/src/view/screens/main/map/local_widgets/task_progress_counter.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;

class TaskCard extends StatelessWidget {
  final Task task;
  final TaskStatus status;
  final ValueChanged<bool> onExpansionChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onExpansionChanged,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    print(task.status.toString() + "+");
    return Consumer(
      builder: (context, OngoingTaskProvider ongoingTaskProvider, child) {
        bool taskSelected = ongoingTaskProvider.taskInProgress
            ? ongoingTaskProvider.currentTask!.id == task.id
            : false;
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              onExpansionChanged: onExpansionChanged,
              initiallyExpanded:
                  taskSelected, //ongoingTaskProvider.taskInProgress,
              // minTileHeight: 78.h,
              tilePadding: EdgeInsets.fromLTRB(12.w, 0, 0, 0),
              trailing: const SizedBox.shrink(),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      task.isCompleted
                          ? Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: ShapeDecoration(
                                color: kSuccessColor.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2.w, color: kSuccessColor),
                                  borderRadius: BorderRadius.circular(99999),
                                ),
                              ),
                              child: Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: kSuccessColor,
                                size: 22.h,
                              ),
                            )
                          : task.isCancelled
                              ? Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: ShapeDecoration(
                                    color: kErrorColor.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 2.w, color: kErrorColor),
                                      borderRadius:
                                          BorderRadius.circular(99999),
                                    ),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.xmark_circle_fill,
                                    color: kErrorColor,
                                    size: 22.h,
                                  ),
                                )
                              : Container(
                                  height: 50,
                                  padding: EdgeInsets.all(12.w),
                                  decoration: ShapeDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 2.w),
                                      borderRadius:
                                          BorderRadius.circular(99999),
                                    ),
                                  ),
                                  child: Image.asset(
                                    Assets.kPng_Brochure,
                                    height: 22.h,
                                  ),
                                ),
                      if (!task.isCancelled && !task.isCompleted)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 20.w,
                            height: 20.w,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(width: 2.w, color: Colors.white),
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                            child: Text(
                              task.flyersCount.toString().padLeft(2, '0'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              title: Text(
                "${task.name ?? ''} - ${task.description ?? ''}",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  height: 0,
                ),
              ),
              childrenPadding: EdgeInsets.symmetric(horizontal: 12.w),
              children: [
                if (task.isCompleted)
                  // Task is completed
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      "Cette tâche a été complétée avec succès.",
                      style: TextStyle(
                        color: kSuccessColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        height: 0,
                      ),
                    ),
                  )
                else if (task.isCancelled)
                  // Task is cancelled
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      "Cette tâche a été annulée.",
                      style: TextStyle(
                        color: kErrorColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        height: 0,
                      ),
                    ),
                  )
                else
                  _buildExpandedBody(context, ongoingTaskProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandedBody(
      BuildContext context, OngoingTaskProvider ongoingTaskProvider) {
    bool taskSelected = ongoingTaskProvider.taskInProgress
        ? ongoingTaskProvider.currentTask!.id == task.id
        : false;
    MyLogger.info(task.locations);
    return Column(
      children: [
        if (!(taskSelected &&
            context.watch<MapViewStateProvider>().isRouteDrawn))
          Column(
            children: [
              Gap(8.h),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 155.h,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TaskZoneMap(
                    // zoneCoords: (task.locations ?? []).map((location) => location.coordinates).toList(),
                    zoneCoords: (task.zone?.locations ?? [])
                        .map((location) => location)
                        .toList(),
                  ),
                ),
              ),
              Gap(15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 12.h,
                    height: 12.h,
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Gap(8.w),
                  Text(
                    'POINT INITIAL',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color(0xFF8B8B8B),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 7.h),
                child: Row(
                  children: [
                    Container(
                      width: 12.h,
                      height: 12.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: Text(
                        task.locations?.first.name ?? '',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.sp,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 12.h,
                    height: 12.h,
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Gap(8.w),
                  Text(
                    'POINT SUIVANT',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color(0xFF8B8B8B),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.h - 12.w, top: 7.h),
                child: Row(
                  children: [
                    Container(
                      width: 12.h,
                      height: 12.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    Gap(8.w),
                    if ((task.locations?.length ?? 0) > 1)
                      Expanded(
                        child: Text(
                          task.locations?[1].name ?? '',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Gap(25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          Assets.kSvg_Layers,
                          width: 13.h,
                        ),
                        Gap(5.w),
                        Text(
                          '${task.locations?.length.toString().padLeft(2, '0')} Locations',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 0.40.w,
                      height: 28.h,
                      decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.4000000059604645),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.kSvg_Locations,
                          width: 13.h,
                        ),
                        Gap(5.w),
                        Text(
                          "${task.flyersCount} object",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(13.h),
            ],
          )
        else
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Divider(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
              ),
              Gap(10.h),
              // Text(
              //   "Cette tâche est déjà en cours",
              // ),
              // Gap(10.h),
              TaskProgressCounter(
                value:
                    (ongoingTaskProvider.currentTask!.flyersDistributed ?? 0) /
                        (ongoingTaskProvider.currentTask!.flyersCount ?? 1),
                showFlyerIcon: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(10.w),
                  Text(
                    '${ongoingTaskProvider.currentTask!.flyersDistributed.toString().padLeft(2, '0')}/${ongoingTaskProvider.currentTask!.flyersCount.toString().padLeft(2, '0')} a été livré.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      height: 0,
                    ),
                  ),
                ],
              ),
              Gap(20.h),
            ],
          ),
        if (status == TaskStatus.today)
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: (task.status == "accepted")
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            context.read<MapViewStateProvider>().resetAll();
                            ongoingTaskProvider.cancelTask();
                          },
                          child: Text(
                            "Annuler",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Gap(10.w),*/
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                          ),
                          onPressed: () async {
                            _starttask(task.id.toString());

                            ongoingTaskProvider.startTask(task);
                            /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                        task: task,
                                      )),
                            );*/
                            context.read<MapViewStateProvider>()
                              ..resetAll()
                              ..initializeMap(task).then(
                                (res) {
                                  Navigator.of(context).pushNamed(kMapRoute);
                                },
                              );
                          },
                          child: Text(
                            "Continuer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                    ),
                    onPressed: () async {
                      try {
                        _starttask(task.id.toString());
                      } catch (e) {
                        print(e);
                      }
// (taskSelected && context.watch<MapViewStateProvider>().isRouteDrawn)
                      if (!taskSelected &&
                          context.read<MapViewStateProvider>().isRouteDrawn) {
                        // ongoingTaskProvider.cancelTask();
                        // context.read<MapViewStateProvider>().resetAll();
                        FuncHelpers.showToastNotification(
                          title: "Vous avez déjà une tâche en cours",
                          notiType: ToastificationType.warning,
                          description: "Terminez-le ou annulez-le d'abord.",
                        );
                        return;
                      }
                      // if (ongoingTaskProvider.taskInProgress && taskSelected) {

                      // }
                      // if (!ongoingTaskProvider.taskInProgress) {
                      task.status = "accepted";
                      ongoingTaskProvider.startTask(task);
                      context.read<MapViewStateProvider>()
                        ..resetAll()
                        ..initializeMap(task).then(
                          (res) {
                            Navigator.of(context).pushNamed(kMapRoute);
                          },
                        );
                      print(task.status);

                      // }
                    },
                    child: Text(
                      "Démarrer la tâche",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
          ),
        Gap(20.h),
      ],
    );
  }

  Future<void> _starttask(String task) async {
    final url = Uri.parse('$baseUrl/animateur/task/$task/start');

    String? token = Prefs.getUserAccessToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      print("------------------------------------");
      print(url);
      print(token);
      print(task);
      print(response.body);
      if (response.statusCode == 200) {
        MyLogger.info(response.body);
      } else {
        // throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class TaskZoneMap extends StatefulWidget {
  final List<LatLng> zoneCoords;
  const TaskZoneMap({super.key, required this.zoneCoords});

  @override
  State<TaskZoneMap> createState() => TaskZoneMaptState();
}

class TaskZoneMaptState extends State<TaskZoneMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late CameraPosition _cameraPosition;

  final Set<Polygon> _polygons = {};

  void _convertZoneCoordsToPolygon() {
    _polygons.add(
      Polygon(
        polygonId: const PolygonId('task_zone'),
        points: [
          ...widget.zoneCoords,
          // LatLng(35.760000, -5.810222222),
        ],
        strokeColor: kSecondaryColor,
        strokeWidth: 2,
        fillColor: kSecondaryColor.withOpacity(0.2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: FuncHelpers.calculateCoordsCenter(widget.zoneCoords),
      zoom: 11.6,
      // zoom: 14.4746,
    );
    _convertZoneCoordsToPolygon();
  }

  @override
  void dispose() {
    _controller.future.then((ctrler) => ctrler.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _cameraPosition,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: false,
      zoomGesturesEnabled: false,
      zoomControlsEnabled: true,
      polygons: _polygons,
      onMapCreated: (GoogleMapController controller) {
        MyLogger.info("Map Created!");
        _controller.complete(controller);
      },
    );
  }
}

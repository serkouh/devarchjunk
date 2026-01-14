import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/config/constants/palette.dart';
import 'package:actitrack/src/services/api/task/ongoing_task_service.dart';
import 'package:actitrack/src/state/providers/map/map_state_provider.dart';
import 'package:actitrack/src/state/providers/tasks/ongoing_task_provider.dart';
import 'package:actitrack/src/view/screens/main/map/local_widgets/task_progress_counter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MapViewBottomSheet extends StatelessWidget {
  const MapViewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final MapViewStateProvider mapViewStateProvider =
        Provider.of<MapViewStateProvider>(context);
    final OngoingTaskProvider ongoingTaskProvider =
        Provider.of<OngoingTaskProvider>(context);
    int totalQuantity = 0;
    int distributed = 0;
    if (ongoingTaskProvider.currentTask != null) {
      for (var task in ongoingTaskProvider.currentTask!.locations!) {
        for (var l in task.distributionObjects) {
          totalQuantity += l.quantity;
          distributed += l.distributed;
        }
      }
    }
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        clipBehavior: Clip.antiAlias,
        width: MediaQuery.of(context).size.width,
        height: 180.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
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
        child: mapViewStateProvider.isRouteDrawn
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(10.h),
                  Container(
                    width: 32.w,
                    height: 4.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Gap(15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.kSvg_Brochure,
                              width: 13.h,
                            ),
                            Gap(5.w),
                            Text(
                              'Brochure',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF424242),
                                fontSize: 11.sp,
                                fontFamily: 'Lato',
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
                          children: [
                            SvgPicture.asset(
                              Assets.kSvg_Layers,
                              width: 13.h,
                            ),
                            Gap(5.w),
                            Text(
                              ongoingTaskProvider.taskInProgress
                                  ? '${ongoingTaskProvider.currentTask!.flyersCount.toString().padLeft(2, '0')} Flyers'
                                  : 'N/A',
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
                          children: [
                            SvgPicture.asset(
                              Assets.kSvg_Distance,
                              width: 13.h,
                            ),
                            Gap(5.w),
                            Text(
                              mapViewStateProvider.drawnRouteDistance != null
                                  ? "${mapViewStateProvider.drawnRouteDistance}"
                                  : "N/A",
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
                  Gap(20.h),
                  Text(
                    "${ongoingTaskProvider.currentTask!.name} - ${ongoingTaskProvider.currentTask!.description ?? 'aucun description'}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Gap(15.h),
                  TaskProgressCounter(
                    value: distributed / totalQuantity,
                  ),
                  Gap(16.h)
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(10.h),
                  Container(
                    width: 32.w,
                    height: 4.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Gap(15.h),
                  Row(
                    children: [
                      // Stack(
                      //   children: [
                      //     Container(
                      //       padding: EdgeInsets.all(12.w),
                      //       decoration: ShapeDecoration(
                      //         color: Theme.of(context).scaffoldBackgroundColor,
                      //         shape: RoundedRectangleBorder(
                      //           side: BorderSide(width: 2.w),
                      //           borderRadius: BorderRadius.circular(99999),
                      //         ),
                      //       ),
                      //       child: Image.asset(
                      //         Assets.kPng_Brochure,
                      //         height: 22.h,
                      //       ),
                      //     ),
                      //     Positioned(
                      //       right: 0,
                      //       bottom: 0,
                      //       child: Container(
                      //         width: 20.w,
                      //         height: 20.w,
                      //         alignment: Alignment.center,
                      //         decoration: ShapeDecoration(
                      //           color: Theme.of(context).primaryColor,
                      //           shape: RoundedRectangleBorder(
                      //             side: BorderSide(width: 2.w, color: Colors.white),
                      //             borderRadius: BorderRadius.circular(90),
                      //           ),
                      //         ),
                      //         child: Text(
                      //           ongoingTaskProvider.currentTask!.flyersCount.toString().padLeft(2, '0'),
                      //           textAlign: TextAlign.center,
                      //           style: const TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 8,
                      //             fontWeight: FontWeight.w400,
                      //             height: 0,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Gap(10.w),
                      Expanded(
                        child: Text(
                          "${ongoingTaskProvider.currentTask!.name} - ${ongoingTaskProvider.currentTask!.description ?? 'aucun description'}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(10.h),
                  TaskProgressCounter(
                    value: distributed / totalQuantity,
                    showFlyerIcon: false,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gap(15.w),
                      Text(
                        "${distributed} flyers sur un total de ${totalQuantity} ont été distribués avec succès !",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  if (!(ongoingTaskProvider.currentTask!.locations ?? [])
                      .every((location) => location.deliveryCompleted))
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            color: Colors.black54,
                          )
                        ],
                      ),
                      child: Text(
                        "Sélectionnez la destination cible ci-dessus ou cliquez sur l'un des marqueurs pour démarrer votre tâche.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 208, 255, 209),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            color: kSuccessColor,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 30.sp,
                            color: kSuccessColor,
                          ),
                          Gap(10.w),
                          Expanded(
                            child: Text(
                              "Tous les flyers de cette tâche ont été distribués avec succès !",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Gap(10.h),
                ],
              ),
      ),
    );
  }
}

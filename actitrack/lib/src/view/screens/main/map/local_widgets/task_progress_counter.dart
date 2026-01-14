import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/state/providers/tasks/ongoing_task_provider.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TaskProgressCounter extends StatelessWidget {
  final bool showFlyerIcon;
  final double value;
  const TaskProgressCounter(
      {super.key, this.showFlyerIcon = true, required this.value});

  @override
  Widget build(BuildContext context) {
    final OngoingTaskProvider ongoingTaskProvider =
        Provider.of<OngoingTaskProvider>(context);
    final totalFlyersCount = ongoingTaskProvider.currentTask!.flyersCount;
    final deliveredFlyersCount =
        ongoingTaskProvider.currentTask!.flyersDistributed;
    return Container(
      decoration: showFlyerIcon
          ? ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.50),
                borderRadius: BorderRadius.circular(9999),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x2D000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ],
            )
          : null,
      child: Row(
        children: [
          if (showFlyerIcon) Gap(16.w),
          // if (showFlyerIcon)
          //   Text(
          //     '${deliveredFlyersCount.toString().padLeft(2, '0')}/${totalFlyersCount.toString().padLeft(2, '0')}',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 13.sp,
          //       fontFamily: 'Lato',
          //       fontWeight: FontWeight.w800,
          //       height: 0,
          //     ),
          //   ),
          Gap(10.w),
          Expanded(
            child: LinearProgressIndicator(
              minHeight: (showFlyerIcon ? 13 : 8).h,
              borderRadius: BorderRadius.circular(9999),
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
              value: value.clamp(0, 1),
            ),
          ),
          Gap(10.w),
          if (showFlyerIcon)
            Container(
              width: 40.h,
              height: 40.h,
              padding: EdgeInsets.all(8.h),
              decoration: ShapeDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              child: SvgPicture.asset(
                Assets.kSvg_Brochure,
              ),
            )
          else
            SizedBox(
              height: 20.h,
            )
        ],
      ),
    );
  }
}

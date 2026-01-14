import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/state/providers/tasks/tasks_provider.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class TotalTasksCard extends StatelessWidget {
  final String acomplis;
  final String left;
  const TotalTasksCard({
    super.key,
    required this.acomplis,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 55.h),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.6),
          width: 0.5.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 13.w,
          vertical: 20.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Salut ${Prefs.getUserData()?.firstName}!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Gap(8.w),
                  Text(
                    "Vous avez encore ${context.read<TasksProvider>().tasks. /*where((task) => task.isToday).*/ length} tâches à accomplir aujourd'hui.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
            Gap(10.w),
            SizedBox(
              height: 70.h,
              width: 70.h,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SimpleCircularProgressBar(
                    startAngle: 0,
                    animationDuration: 2,
                    backColor: Colors.grey[350]!,
                    fullProgressColor: Theme.of(context).primaryColor,
                    mergeMode: true,
                    maxValue: 0,
                    // maxValue:
                    //     ((context.read<TasksProvider>().tasks.where((task) => task.isCompleted && task.isToday).length / context.read<TasksProvider>().tasks.where((task) => task.isToday).length) *
                    //             100)
                    //         .clamp(0, 100),
                    progressColors: [
                      Theme.of(context).primaryColor,
                    ],
                  ),
                  Text(
                    '${context.read<TasksProvider>().tasks.where((task) => task.isCompleted).length}/${context.read<TasksProvider>().tasks.length}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      height: 0,
                      letterSpacing: -0.80,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

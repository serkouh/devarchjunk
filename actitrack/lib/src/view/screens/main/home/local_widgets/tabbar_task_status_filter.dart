import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:actitrack/src/config/constants/enums.dart';
import 'package:actitrack/src/state/providers/tasks/tasks_provider.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:provider/provider.dart';

class TabbarTaskStatusFilter extends StatelessWidget {
  const TabbarTaskStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 55.h,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTabSelector(context, "Aujourd'hui", status: TaskStatus.today),
          _buildTabSelector(context, "Demain", status: TaskStatus.tomorrow),
          _buildTabSelector(context, "Complété", status: TaskStatus.completed),
          _buildTabSelector(context, "Annulé", status: TaskStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildTabSelector(BuildContext context, String title,
      {required TaskStatus status}) {
    bool isSelected = context.watch<TasksProvider>().currentStatus == status;
    return Container(
      decoration: ShapeDecoration(
        color: isSelected ? const Color(0xFFD9D9D9) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9999),
        child: InkWell(
          borderRadius: BorderRadius.circular(9999),
          onTap: () {
            HapticFeedback.mediumImpact();
            context.read<TasksProvider>().currentStatus = status;
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    isSelected ? Theme.of(context).colorScheme.secondary : null,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

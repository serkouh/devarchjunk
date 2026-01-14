import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:gap/gap.dart';

class CustomRightDrawer extends StatefulWidget {
  const CustomRightDrawer({super.key});

  @override
  _CustomRightDrawerState createState() => _CustomRightDrawerState();
}

class _CustomRightDrawerState extends State<CustomRightDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          bottomLeft: Radius.circular(20.r),
        ),
      ),
      width: 210.w,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /* SizedBox(
              height: 55.h,
              child: _buildHeader(context),
            ),*/
            Gap(20.h),
            NotificationCard(),
            NotificationCard(),
            NotificationCard(),
            NotificationCard(),
            NotificationCard(),
          ],
        ),
      ),
    );
  }

  DrawerHeader _buildHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: Text(
          'Vous avez 5 notifications',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      child: ListTile(
        dense: true,
        minLeadingWidth: 10.w,
        // minTileHeight: 85.h,
        // trailing: Container(
        //   color: Colors.red,
        //   child: Column(
        //     children: [
        //       Icon(
        //         Icons.circle,
        //         size: 10.sp,
        //       ),
        //     ],
        //   ),
        // ),
        leading: SvgPicture.asset(Assets.kSvg_Notification),
        title: Text(
          'Lorem ipsum dolor sit amet',
          style: TextStyle(
            color: Colors.black,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
        subtitle: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 9.sp,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ),
    );
  }
}

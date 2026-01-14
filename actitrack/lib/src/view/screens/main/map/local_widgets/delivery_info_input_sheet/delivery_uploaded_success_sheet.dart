import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DeliveryUploadedSuccessSheet extends StatelessWidget {
  const DeliveryUploadedSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 23.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Theme.of(context).primaryColor,
            size: 100.sp,
          ),
          Gap(20.h),
          Text(
            'Votre livraison est enregistrée avec succès.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          Gap(80.h),
          SizedBox(
            height: 45.h,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Fermer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      'Répéter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

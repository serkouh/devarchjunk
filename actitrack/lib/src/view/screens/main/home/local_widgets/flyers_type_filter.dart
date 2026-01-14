import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/config/constants/enums.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class FlyerTypeFilter extends StatelessWidget {
  final bool loading;
  FlyerTypeFilter({super.key, this.loading = false});
  final ValueNotifier<FlyerType> _flyerTypeNotifier =
      ValueNotifier(FlyerType.flyer);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).scaffoldBackgroundColor,
        highlightColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 75.h,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Gap(11.w),
              Expanded(
                child: Container(
                  height: 75.h,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ValueListenableBuilder<FlyerType>(
        valueListenable: _flyerTypeNotifier,
        builder: (context, flyerType, _) {
          final showFlyersOnly = flyerType == FlyerType.flyer;
          return Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.ease,
                  decoration: ShapeDecoration(
                    color: showFlyersOnly
                        ? Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.13)
                        : Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50,
                        color: Colors.black.withOpacity(0.36000001430511475),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _flyerTypeNotifier.value = FlyerType.flyer;
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 13.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Flyers',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const Text(
                              '8 flyers à livrer',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  Assets.kPng_Brochure,
                                  height: 24.h,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(11.w),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.ease,
                  decoration: ShapeDecoration(
                    color: !showFlyersOnly
                        ? Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.13)
                        : Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50,
                        color: Colors.black.withOpacity(0.36000001430511475),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _flyerTypeNotifier.value = FlyerType.brochure;
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 13.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Brochures',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const Text(
                              '8 brochures à livrer',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  Assets.kPng_Brochure,
                                  height: 24.h,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

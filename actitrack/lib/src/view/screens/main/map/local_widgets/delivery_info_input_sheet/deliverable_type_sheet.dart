import 'package:actitrack/src/models/distribution_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/models/target_location.dart';
import 'package:gap/gap.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gap/gap.dart';

class DeliverableTypeSheet extends StatefulWidget {
  final TargetLocation location;
  Function() show;
  DeliverableTypeSheet({super.key, required this.location, required this.show});

  @override
  _DeliverableTypeSheetState createState() => _DeliverableTypeSheetState();
}

class _DeliverableTypeSheetState extends State<DeliverableTypeSheet> {
  String? selectedType;

  List<DistributionObject> deliverableTypes = [];

  @override
  void initState() {
    super.initState();
    deliverableTypes = widget.location.distributionObjects;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 23.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Quel est l'objet que vous livrez maintenant ?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          Gap(20.h),
          Column(
            children: deliverableTypes.map((type) {
              bool isSelected = selectedType == type.name;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedType = type.name;
                    widget.location.Selectedobject = type;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.w,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.r),
                    ),
                    color: isSelected ? Colors.blue.shade50 : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          Assets.kSvg_Brochure,
                          height: 20.h,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Text(
                          type.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                      if (isSelected)
                        ElasticIn(
                          duration: Duration(milliseconds: 1000),
                          child: Icon(Icons.check,
                              color: Theme.of(context).primaryColor),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          Gap(40.h),
          SizedBox(
            height: 45.h,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                if (widget.location.Selectedobject != null) {
                  print("------------------------------------------");
                  print(widget.location.Selectedobject!.name);
                  Navigator.pop(context);
                  widget.show();
                }
              },
              child: Text(
                'Suivant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

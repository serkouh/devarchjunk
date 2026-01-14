import 'package:flutter/material.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:shimmer/shimmer.dart';

class LoadingBox extends StatelessWidget {
  final double? height;
  final double? width;
  final bool fullScreen;
  const LoadingBox({
    super.key,
    this.height,
    this.width,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    double? finalWidth = width;
    double? finalHeight = height;
    if (fullScreen) {
      finalHeight = FuncHelpers.getDeviceSize(context).height;
      finalWidth = FuncHelpers.getDeviceSize(context).height;
    }
    return Shimmer.fromColors(
      baseColor: Theme.of(context).scaffoldBackgroundColor,
      highlightColor: Colors.white,
      child: Container(
        width: finalWidth,
        height: finalHeight,
        color: Colors.white,
      ),
    );
  }
}

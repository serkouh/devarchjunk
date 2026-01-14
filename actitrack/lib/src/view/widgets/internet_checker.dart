import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';

class InternetConnectivityChecker extends StatefulWidget {
  final String? actionButtonLabel;
  final VoidCallback? actionCallback;
  final Widget child;
  final bool withFutaBg;
  final bool enableDefaultOfflineWidget;
  final Widget? offlineWidget;
  InternetConnectivityChecker({
    super.key,
    required this.child,
    this.withFutaBg = false,
    this.enableDefaultOfflineWidget = true,
    this.offlineWidget,
    this.actionButtonLabel,
    this.actionCallback,
  });

  @override
  State<InternetConnectivityChecker> createState() =>
      _InternetConnectivityCheckerState();
}

class _InternetConnectivityCheckerState
    extends State<InternetConnectivityChecker> {
  final Stream<ConnectivityResult> _connectivityStream =
      Connectivity().onConnectivityChanged;
  late Function(ConnectivityResult) _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    _onConnectivityChanged = (ConnectivityResult result) {
      if (result != ConnectivityResult.wifi &&
          result != ConnectivityResult.mobile) {
        FuncHelpers.showToastNotification(
          noWifi: true,
          title: "Tu es hors ligne!",
          description: "Votre appareil n'est pas connecté à Internet",
        );
      }
    };
    _connectivityStream.listen(_onConnectivityChanged);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableDefaultOfflineWidget) {
      return widget.child;
    }
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox.shrink();
        }
        final bool isOnline = snap.data == ConnectivityResult.wifi ||
            snap.data == ConnectivityResult.mobile;
        if (isOnline) {
          return widget.child;
        } else {
          return widget.offlineWidget ??
              _buildNoInternetWidget(context, isOnline);
        }
      },
    );
  }

  Widget _buildNoInternetWidget(context, bool isOnline) {
    return Center(
      child: Card(
        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Assets.kSvg_NoWifi,
                height: 80.h,
              ),
              Gap(15.h),
              Text(
                'Tu es hors ligne!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 29.sp,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              Gap(12.h),
              Text(
                "Votre appareil n'est pas connecté à Internet, connectez-vous à un réseau pour voir vos tâches",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              Gap(40.h),
              if (widget.actionCallback != null)
                OutlinedButton(
                  style: ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    side: MaterialStatePropertyAll(
                      BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.w,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    widget.actionCallback!.call();
                  },
                  child: Text(
                    widget.actionButtonLabel ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

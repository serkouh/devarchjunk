import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/config/constants/constants.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/state/providers/auth_provider.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:actitrack/src/view/screens/main/auth/auth_screen.dart';
import 'package:actitrack/src/view/widgets/custom_image.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CustomLeftDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldStateKey;
  const CustomLeftDrawer({super.key, required this.scaffoldStateKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      width: 210.w,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100.h,
              child: _buildHeader(context),
            ),
            Gap(60.h),
            _buildDrawerItem(context, "Mes tâches", Assets.kPng_Brochure,
                onPress: () {
              scaffoldStateKey.currentState?.closeDrawer();
            }),
            Gap(25.h),
            _buildDrawerItem(
              context,
              "Notifications",
              Assets.kSvg_Notification,
              onPress: () {
                scaffoldStateKey.currentState?.closeDrawer();
                scaffoldStateKey.currentState?.openEndDrawer();
              },
              outlined: true,
            ),
            const Spacer(),
            _buildDrawerItem(context, "Déconnecter", Assets.kSvg_Logout,
                onPress: () async {
              final confirmation = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Déconnexion"),
                    content: const Text(
                        "Êtes-vous sûr de vouloir vous déconnecter ?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("Annuler"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text("Déconnecter"),
                      ),
                    ],
                  );
                },
              );
              if (confirmation == true) {
                await _logOut(context);
              }
            }),
            Gap(40.h),
          ],
        ),
      ),
    );
  }

  Future<void> _logOut(BuildContext context) async {
    final res = await Prefs.clearAllData();
    if (res) {
      // Navigator.pop(context);
      context.read<AuthProvider>().isAuthenticated = false;
      FuncHelpers.showToastNotification(
          title: "Déconnecté avec succès",
          notiType: ToastificationType.success);
      Navigator.of(context).pushReplacementNamed(kAuthRoute);

      // Navigator.pushNamed(context, kAuthRoute);
    } else {
      FuncHelpers.showToastNotification(
          title: "Erreur lors de la déconnexion",
          notiType: ToastificationType.error);
    }
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    dynamic iconAssetPath, {
    required VoidCallback onPress,
    bool outlined = false,
  }) {
    const BorderRadius borderRadius = BorderRadius.only(
      topRight: Radius.circular(9999),
      bottomRight: Radius.circular(9999),
    );
    return Container(
      width: 158.w,
      height: 35.h,
      decoration: BoxDecoration(
        color: outlined ? null : Theme.of(context).primaryColor,
        borderRadius: borderRadius,
        border: outlined
            ? Border(
                right: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
                top: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : null,
      ),
      child: Material(
        borderRadius: borderRadius,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onPress,
          child: Row(
            children: [
              Gap(16.w),
              Container(
                width: 26.h,
                height: 26.h,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                padding: EdgeInsets.all(6.w),
                child: iconAssetPath is IconData
                    ? Icon(iconAssetPath)
                    : iconAssetPath is String
                        ? iconAssetPath.endsWith('.svg')
                            ? SvgPicture.asset(iconAssetPath)
                            : Image.asset(iconAssetPath)
                        : Container(),
              ),
              Gap(9.w),
              Text(
                title,
                style: TextStyle(
                  color: outlined ? Colors.black : Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  DrawerHeader _buildHeader(BuildContext context) {
    final String userRole = 'Animateur';
    // final String firstName = Prefs.getUserData()?.firstName ?? "";
    // final String lastName = Prefs.getUserData()?.lastName ?? "";
    final String userName = Prefs.getUserData()?.fullName ?? "";
    final String? passcode = Prefs.getPassCode();
    final String userProfileImage = Prefs.getUserData()?.profileImage ?? "";
    MyLogger.info(userProfileImage);
    print(userProfileImage);
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.05)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              userProfileImage.isEmpty
                  ? Container(
                      width: 35.h,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.7200000286102295),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    )
                  : CustomImage(
                      imageUrl: userProfileImage,
                      height: 35.h,
                      width: 35.h,
                      circular: true,
                    ),
              Gap(5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userRole,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.7200000286102295),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Theme.of(context).primaryColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          PasscodeChip(passcode: passcode ?? ''),
        ],
      ),
    );
  }
}

class PasscodeChip extends StatefulWidget {
  final String passcode;

  const PasscodeChip({super.key, required this.passcode});
  @override
  _PasscodeChipState createState() => _PasscodeChipState();
}

class _PasscodeChipState extends State<PasscodeChip> {
  bool _isPasscodeVisible = false;

  @override
  void initState() {
    super.initState();
  }

  void _togglePasscodeVisibility() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPasscodeVisible = !_isPasscodeVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (passcode == null) {
    //   return Container();
    // }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10.w),
          height: 30.h,
          decoration: BoxDecoration(
            // color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(999),
            // border: Border.all(
            //   color: Theme.of(context).primaryColor,
            // ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _isPasscodeVisible
                    ? widget.passcode
                    : ("•" * widget.passcode.length),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              Container(
                height: 25.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Theme.of(context).primaryColor,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: _togglePasscodeVisibility,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Icon(
                        _isPasscodeVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: black2FColor,
        title: Text(
          getTranslation(context, 'profile.profile'),
          style: bold20BlackText,
        ),
        elevation: 0,
        backgroundColor: whiteColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: fixPadding * 9.0),
        physics: const BouncingScrollPhysics(),
        children: [
          userprofileAndEdit(),
          // rideDetails(),
          heightSpace,
          heightSpace,
          Container(
            color: f4Color,
            child: Column(
              children: [
                height5Space,
                listTileWidget(Icons.directions_bike,
                    getTranslation(context, 'profile.ride_history'), () {
                  Navigator.pushNamed(context, '/ridehistory');
                }),
                listTileWidget(CupertinoIcons.person_3,
                    getTranslation(context, 'profile.refer_earn'), () {
                  Navigator.pushNamed(context, '/referAndEarn');
                }),
                listTileWidget(CupertinoIcons.globe,
                    getTranslation(context, 'profile.language'), () {
                  Navigator.pushNamed(context, '/language');
                }),
                listTileWidget(CupertinoIcons.gear_alt,
                    getTranslation(context, 'profile.app_settings'), () {
                  Navigator.pushNamed(context, '/appSettings');
                }),
                listTileWidget(CupertinoIcons.chat_bubble_2,
                    getTranslation(context, 'profile.FAQs'), () {
                  Navigator.pushNamed(context, '/FAQs');
                }),
                listTileWidget(Icons.privacy_tip_outlined,
                    getTranslation(context, 'profile.privacy_policy'), () {
                  Navigator.pushNamed(context, '/privacyPolicy');
                }),
                listTileWidget(Icons.list_alt,
                    getTranslation(context, 'profile.terms_condition'), () {
                  Navigator.pushNamed(context, '/termsAndCondition');
                }),
                listTileWidget(Icons.help_outline,
                    getTranslation(context, 'profile.help_support'), () {
                  Navigator.pushNamed(context, '/help');
                }),
                logoutTile(),
                height5Space,
              ],
            ),
          ),
        ],
      ),
    );
  }

  logoutTile() {
    return ListTile(
      onTap: () {
        logoutDialog();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFCFCFC),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.logout,
          color: redColor,
          size: 20,
        ),
      ),
      minLeadingWidth: 0,
      title: Text(
        getTranslation(context, 'profile.logout'),
        style: bold16Red,
      ),
    );
  }

  logoutDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(fixPadding * 2.0),
          contentPadding: const EdgeInsets.all(fixPadding * 2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0XFFE9E9E9),
                ),
                child: const Icon(
                  Icons.logout,
                  color: redColor,
                ),
              ),
              heightSpace,
              heightSpace,
              Text(
                getTranslation(context, 'profile.logout_text'),
                textAlign: TextAlign.center,
                style: semibold16BlackText,
              ),
              heightSpace,
              heightSpace,
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(fixPadding * 1.4),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.15),
                              blurRadius: 6,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: primaryColor),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          getTranslation(context, 'profile.cancel'),
                          style: bold16Primary,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  widthSpace,
                  widthSpace,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(fixPadding * 1.4),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.15),
                              blurRadius: 6,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          getTranslation(context, 'profile.logout'),
                          style: bold16White,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  listTileWidget(IconData icon, String title, Function() onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFCFCFC),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: primaryColor,
          size: 20,
        ),
      ),
      minLeadingWidth: 0,
      title: Text(
        title,
        style: bold16BlackText,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: black2FColor,
        size: 18,
      ),
    );
  }

  rideDetails() {
    return Container(
      color: f4Color,
      padding: const EdgeInsets.symmetric(
          vertical: fixPadding * 1.5, horizontal: fixPadding),
      child: Row(
        children: [
          rideDetailWidget(
            "assets/profile/bicycle.png",
            getTranslation(context, 'profile.ride_taken'),
            "40 ${getTranslation(context, 'profile.ride')}",
          ),
          verticalDivider(),
          rideDetailWidget(
            "assets/profile/location-current.png",
            getTranslation(context, 'profile.distance'),
            "90.45 km",
          ),
          verticalDivider(),
          rideDetailWidget(
            "assets/profile/calories.png",
            getTranslation(context, 'profile.calories'),
            "1050 Kcal",
          ),
        ],
      ),
    );
  }

  verticalDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: fixPadding),
      height: 80,
      width: 1,
      color: greyB4Color,
    );
  }

  rideDetailWidget(image, title, text) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
            image,
            height: 35,
          ),
          height5Space,
          Text(
            title,
            style: bold16Primary,
            overflow: TextOverflow.ellipsis,
          ),
          heightBox(3),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: bold16BlackText,
          ),
        ],
      ),
    );
  }

  userprofileAndEdit() {
    return Container(
      padding: const EdgeInsets.only(
          left: fixPadding * 2.0,
          right: fixPadding * 2.0,
          bottom: fixPadding * 2.0,
          top: fixPadding / 2),
      width: double.maxFinite,
      color: whiteColor,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: whiteColor,
              border: Border.all(color: whiteColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.25),
                  blurRadius: 6,
                )
              ],
              image: const DecorationImage(
                image: AssetImage("assets/home/userImage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          widthSpace,
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Leslie Alexander",
                  style: bold16BlackText,
                ),
                Text(
                  'lesliealexander@mail.com',
                  style: semibold14Grey,
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editProfile');
            },
            icon: const Icon(
              LineIcons.edit,
              color: black2FColor,
            ),
          ),
        ],
      ),
    );
  }
}

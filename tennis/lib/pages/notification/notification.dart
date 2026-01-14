import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationList = [
    {
      "title": "Ride ended",
      "description": "You successfully parked Bk2564 at city rider zone.",
      "time": "2 min",
      "type": "RideEnd"
    },
    {
      "title": "Security deposit",
      "description": "Your security deposits amount \$50.00 successfully paid",
      "time": "4 min",
      "type": "Deposit"
    },
    {
      "title": "Rewards",
      "description":
          "Your referral amount \$50.00 successfully added in your wallet.",
      "time": "10 min",
      "type": "Rewards"
    },
    {
      "title": "Ride ended",
      "description": "You successfully parked Bk2564 at city rider zone.",
      "time": "12 min",
      "type": "RideEnd"
    },
    {
      "title": "Security deposit",
      "description": "Your security deposits amount \$50.00 successfully paid",
      "time": "14 min",
      "type": "Deposit"
    },
    {
      "title": "Rewards",
      "description":
          "Your referral amount \$50.00 successfully added in your wallet.",
      "time": "15 min",
      "type": "Rewards"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Notification",
          style: bold20BlackText,
        ),
      ),
      body: notificationList.isEmpty
          ? emptyNotificationContent()
          : notificationListContent(),
    );
  }

  emptyNotificationContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE9E9E9),
            ),
            child: const Icon(
              LineIcons.bellSlash,
              size: 28,
              color: greyColor,
            ),
          ),
          heightSpace,
          Text(
            getTranslation(context, 'notification.no_notification'),
            style: bold18Grey,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
        ],
      ),
    );
  }

  notificationListContent() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: fixPadding * 9.0),
      physics: const BouncingScrollPhysics(),
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            setState(() {
              notificationList.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 1500),
                behavior: SnackBarBehavior.floating,
                backgroundColor: blackColor,
                content: Text(
                  getTranslation(context, 'notification.removed_notification'),
                  style: semibold16White,
                ),
              ),
            );
          },
          background: Container(
            color: redColor,
            margin: const EdgeInsets.symmetric(vertical: fixPadding),
          ),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(fixPadding),
            margin: const EdgeInsets.symmetric(
                vertical: fixPadding, horizontal: fixPadding * 2.0),
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.25),
                    blurRadius: 6,
                  )
                ]),
            child: Row(
              children: [
                notificationList[index]['type'] == "RideEnd"
                    ? iconBox(redColor, Icons.directions_bike)
                    : (notificationList[index]['type'] == "Deposit"
                        ? iconBox(primaryColor, Icons.lock_outline)
                        : iconBox(
                            greenColor, Icons.account_balance_wallet_outlined)),
                widthSpace,
                widthSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationList[index]['title'].toString(),
                        style: bold16BlackText,
                      ),
                      heightBox(3),
                      Text(
                        notificationList[index]['description'].toString(),
                        style: bold15Grey,
                      ),
                      heightBox(3),
                      Text(
                        "${notificationList[index]['time']} ${getTranslation(context, 'notification.ago')}",
                        style: semibold14Grey,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  iconBox(Color color, IconData icon) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        icon,
        color: whiteColor,
        size: 28,
      ),
    );
  }
}

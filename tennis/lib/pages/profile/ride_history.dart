import 'package:dotted_border/dotted_border.dart';
import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/pages/profile/language.dart';
import 'package:tennis/theme/theme.dart';
import 'package:flutter/material.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  int selectedIndex = 3;

  final rideList = [
    {
      "image": "assets/home/cycle1.png",
      "name": "City ride BK2545",
      "date": "5 aug 2022",
      "time": "05 : 49 pm",
      "km": "2.5 km",
      "distance": "8.36 min",
      "price": 12.50
    },
    {
      "image": "assets/home/cycle3.png",
      "name": "City ride KG5689",
      "date": "6 aug 2022",
      "time": "04 : 49 pm",
      "km": "3.5 km",
      "distance": "10.36 min",
      "price": 15.50
    },
    {
      "image": "assets/home/cycle2.png",
      "name": "City ride BK2545",
      "date": "8 aug 2022",
      "time": "05 : 49 pm",
      "km": "1.5 km",
      "distance": "4.36 min",
      "price": 09.45
    },
    {
      "image": "assets/home/cycle4.png",
      "name": "City ride BK1245",
      "date": "10 aug 2022",
      "time": "05 : 49 pm",
      "km": "3.2 km",
      "distance": "9.36 min",
      "price": 15.45
    },
    {
      "image": "assets/home/cycle1.png",
      "name": "City ride KG5648",
      "date": "12 aug 2022",
      "time": "02 : 15 pm",
      "km": "4.5 km",
      "distance": "60.00 min",
      "price": 50.10
    },
    {
      "image": "assets/home/cycle2.png",
      "name": "City ride BK2545",
      "date": "14 aug 2022",
      "time": "05 : 49 pm",
      "km": "2.5 km",
      "distance": "8.36 min",
      "price": 12.50
    }
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        foregroundColor: black2FColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Text(
          getTranslation(context, 'ride_history.ride_history'),
          style: bold18BlackText,
        ),
      ),
      body: rideHistoryListContent(size),
    );
  }

  rideHistoryListContent(Size size) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
          left: fixPadding * 2.0, right: fixPadding * 2.0, bottom: fixPadding),
      itemCount: rideList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/confirm');
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: fixPadding),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.25),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Image.asset(
                        rideList[index]['image'].toString(),
                        width: size.width * 0.32,
                      ),
                      widthSpace,
                      widthSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rideList[index]['name'].toString(),
                              style: bold16BlackText,
                            ),
                            Text.rich(
                              TextSpan(
                                text: rideList[index]['date'].toString(),
                                style: bold14Grey,
                                children: [
                                  const TextSpan(text: ", "),
                                  TextSpan(
                                    text: rideList[index]['time'].toString(),
                                  )
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DottedBorder(
                  padding: EdgeInsets.zero,
                  dashPattern: const [2.5],
                  color: greyColor,
                  child: Container(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: fixPadding * 2.0),
                        child: Row(
                          children: [
                            Text(
                              rideList[index]['km'].toString(),
                              style: semibold14BlackText,
                            ),
                            verticalDivider(),
                            Text(
                              rideList[index]['distance'].toString(),
                              style: semibold14BlackText,
                            ),
                            verticalDivider(),
                            Expanded(
                              child: Text(
                                "\$${rideList[index]['price']}",
                                style: semibold14BlackText,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        giveRateBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(fixPadding),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: languageValue == 4
                              ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                )
                              : const BorderRadius.only(
                                  bottomRight: Radius.circular(10.0),
                                ),
                        ),
                        child: Text(
                          getTranslation(context, 'ride_history.give_rate'),
                          style: bold14White,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  verticalDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: fixPadding),
      height: 19,
      width: 1,
      color: black2FColor,
    );
  }

  giveRateBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.only(
                left: fixPadding * 2.0,
                right: fixPadding * 2.0,
                top: fixPadding * 2.0,
                bottom: fixPadding,
              ),
              decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    getTranslation(context, 'ride_history.give_rate'),
                    style: bold20Primary,
                    textAlign: TextAlign.center,
                  ),
                  heightSpace,
                  Text(
                    getTranslation(context, 'ride_history.please_text'),
                    style: bold16BlackText,
                    textAlign: TextAlign.center,
                  ),
                  heightSpace,
                  heightSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => _buildStar(index, state),
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/bottombar');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: fixPadding * 1.4, horizontal: fixPadding),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.25),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        getTranslation(context, 'ride_history.submit'),
                        style: bold18White,
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        getTranslation(context, 'ride_history.cancel'),
                        style: bold18Primary,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  _buildStar(index, state) {
    return InkWell(
      onTap: () {
        state(() {
          setState(() {
            selectedIndex = index;
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: fixPadding / 4),
        child: Icon(
          Icons.star_purple500_sharp,
          color: selectedIndex >= index ? primaryColor : greyB4Color,
          size: 40,
        ),
      ),
    );
  }
}

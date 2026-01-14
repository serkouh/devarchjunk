import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/theme/theme.dart';
import 'package:tennis/widget/column_builder.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final recentTranscationList = [
    {
      "title": "Paid for ride",
      "date": "6 April 2022",
      "time": "5.50 pm",
      "amount": "\$12.20",
      "paid": true,
    },
    {
      "title": "Paid for ride",
      "date": "8 April 2022",
      "time": "4.50 pm",
      "amount": "\$10.20",
      "paid": true,
    },
    {
      "title": "Security deposited",
      "date": "10 April 2022",
      "time": "9.50 am",
      "amount": "\$50.00",
      "paid": false,
    },
    {
      "title": "Paid for ride",
      "date": "11 April 2022",
      "time": "3.50 pm",
      "amount": "\$15.10",
      "paid": true,
    },
    {
      "title": "Paid for ride",
      "date": "12 April 2022",
      "time": "3.10 pm",
      "amount": "\$16.30",
      "paid": true,
    },
    {
      "title": "Paid for ride",
      "date": "13 April 2022",
      "time": "8.15 am",
      "amount": "\$12.20",
      "paid": true,
    },
    {
      "title": "Security deposited",
      "date": "14 April 2022",
      "time": "5.00 pm",
      "amount": "\$50.00",
      "paid": false,
    },
    {
      "title": "Paid for ride",
      "date": "14 April 2022",
      "time": "8.15 am",
      "amount": "\$10.20",
      "paid": true,
    },
    {
      "title": "Paid for ride",
      "date": "18 April 2022",
      "time": "3.50 pm",
      "amount": "\$19.20",
      "paid": true,
    },
    {
      "title": "Security deposited",
      "date": "20 April 2022",
      "time": "9.50 am",
      "amount": "\$50.00",
      "paid": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        title: Text(
          getTranslation(context, 'wallet.wallet'),
          style: bold20BlackText,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: fixPadding * 9.0),
        children: [
          availableBalanceDetail(),
          recentTransactionTitle(),
          recentTransactionListContent(),
        ],
      ),
    );
  }

  recentTransactionListContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      width: double.maxFinite,
      color: const Color(0xFFFAFAFA),
      child: ColumnBuilder(
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/receipt');
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: fixPadding * 2.0),
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Icon(
                        recentTranscationList[index]['paid'] == true
                            ? Icons.directions_bike
                            : Icons.lock_outline_rounded,
                        color: primaryColor,
                        size: 22,
                      ),
                    ),
                    widthSpace,
                    width5Space,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recentTranscationList[index]['title'].toString(),
                            style: bold16BlackText,
                          ),
                          Text.rich(
                            TextSpan(
                              text: recentTranscationList[index]['date']
                                  .toString(),
                              style: bold14Grey,
                              children: [
                                const TextSpan(text: ', '),
                                TextSpan(
                                  text: recentTranscationList[index]['time']
                                      .toString(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      recentTranscationList[index]['amount'].toString(),
                      style: recentTranscationList[index]['paid'] == true
                          ? bold16Red
                          : bold16Green,
                    ),
                  ],
                ),
              ),
              recentTranscationList.length == index + 1
                  ? const SizedBox()
                  : Container(
                      height: 1,
                      width: double.maxFinite,
                      color: const Color(0xFFCDD8DD),
                    ),
            ],
          );
        },
        itemCount: recentTranscationList.length,
      ),
    );
  }

  recentTransactionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: fixPadding * 1.5, horizontal: fixPadding * 2.0),
      child: Text(
        getTranslation(context, 'wallet.recent_transaction'),
        style: bold16Grey,
      ),
    );
  }

  availableBalanceDetail() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 2.5),
      color: const Color(0xFFD4E7F2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslation(context, 'wallet.available_balance'),
                  style: semibold15Grey.copyWith(
                    color: const Color(0xFF777676),
                  ),
                ),
                height5Space,
                const Text(
                  "\$120.50",
                  style: bold24Primary,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/addmoney');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: fixPadding * 1.4, horizontal: fixPadding * 2.5),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                getTranslation(context, 'wallet.add_money'),
                style: bold18White,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

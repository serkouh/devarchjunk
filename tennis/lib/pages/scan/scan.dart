import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/theme/theme.dart';
import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        extendBody: true,
        body: ListView(
          padding: const EdgeInsets.all(fixPadding * 2.0),
          physics: const BouncingScrollPhysics(),
          children: [
            scanTitle(context),
            heightBox(3.0),
            contentText(context),
            heightSpace,
            heightSpace,
            scanImage(size, context),
            heightSpace,
            heightSpace,
            havingIssueText(context),
            heightSpace,
            heightSpace,
            Row(
              children: [
                codeField(context),
                widthSpace,
                width5Space,
                highlightButton()
              ],
            ),
            heightSpace,
            heightSpace,
          ],
        ),
      ),
    );
  }

  codeField(context) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: whiteColor,
          boxShadow: [
            BoxShadow(color: blackColor.withOpacity(0.25), blurRadius: 6),
          ],
        ),
        child: TextField(
          cursorColor: primaryColor,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0,
            ),
            border: InputBorder.none,
            hintText: getTranslation(context, 'scan.enter_code_manually'),
            hintStyle: bold16Grey,
          ),
        ),
      ),
    );
  }

  highlightButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.25),
            blurRadius: 6,
          )
        ],
      ),
      child: const Icon(
        Icons.highlight_outlined,
        color: primaryColor,
        size: 28,
      ),
    );
  }

  havingIssueText(context) {
    return Text(
      getTranslation(context, 'scan.having_issue'),
      style: bold16BlackText,
      textAlign: TextAlign.center,
    );
  }

  scanTitle(context) {
    return Text(
      getTranslation(context, 'scan.scan_unlock'),
      style: bold22BlackText,
      textAlign: TextAlign.center,
    );
  }

  contentText(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 3.0),
      child: Text(
        getTranslation(context, 'scan.scan_code_text'),
        style: bold16Grey,
        textAlign: TextAlign.center,
      ),
    );
  }

  scanImage(Size size, context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/securityDeposit');
      },
      child: Container(
        height: size.height * 0.5,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          image: const DecorationImage(
            image: AssetImage('assets/scan/scan.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

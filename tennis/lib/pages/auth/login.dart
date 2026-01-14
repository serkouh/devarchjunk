import 'dart:io';

import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/pages/profile/language.dart';
import 'package:tennis/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAgree = true;
  bool _obscurePassword = true;

  DateTime? backPressTime;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        } else {
          return false;
        }
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(fixPadding * 2.0),
              children: [
                heightSpace,
                heightSpace,
                heightSpace,
                topImage(size),
                heightSpace,
                rideText(),
                heightSpace,
                heightSpace,
                heightSpace,
                height5Space,
                loginText(),
                height5Space,
                welcomeText(),
                heightSpace,
                heightSpace,
                heightSpace,
                nameField(context),
                heightSpace,
                heightSpace,
                passwordField(context),
                heightSpace,
                heightSpace,
                heightSpace,
                agreeConditionsText(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(fixPadding * 1.4),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.25),
              blurRadius: 6,
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          getTranslation(context, 'login.login'),
          style: bold18White,
        ),
      ),
    );
  }

  agreeConditionsText() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isAgree = !isAgree;
            });
          },
          child: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: isAgree ? blueTextColor : whiteColor,
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.25),
                  blurRadius: 6,
                ),
              ],
              border: Border.all(color: blueTextColor),
            ),
            child: isAgree
                ? const Icon(
                    Icons.done,
                    color: whiteColor,
                    size: 12,
                  )
                : null,
          ),
        ),
        widthSpace,
        Expanded(
          child: Text.rich(
            TextSpan(
              text: getTranslation(context, 'login.text1'),
              style: bold12Grey,
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                  text: getTranslation(context, 'login.text2'),
                  style: bold12Primary.copyWith(
                    decoration: TextDecoration.underline,
                    decorationThickness: 1.5,
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: getTranslation(context, 'login.text3'),
                  style: bold12Grey,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  rideText() {
    return Text(
      getTranslation(context, 'login.ride_text'),
      style: bold22BlueText,
      textAlign: TextAlign.center,
    );
  }

  topImage(Size size) {
    return Center(
      child: Image.asset(
        "assets/auth/Logo (4).png",
        height: size.height * 0.18,
      ),
    );
  }

  loginText() {
    return Text(
      getTranslation(context, 'login.ride_text'),
      style: bold22BlackText,
      textAlign: TextAlign.center,
    );
  }

  welcomeText() {
    return Text(
      getTranslation(context, 'login.welcome_text'),
      style: bold15Grey,
      textAlign: TextAlign.center,
    );
  }

  mobileNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslation(context, 'login.mobile_number'),
          style: semibold16BlackText,
        ),
        heightSpace,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.25),
                blurRadius: 6,
              )
            ],
          ),
          child: IntlPhoneField(
            textAlign: languageValue == 4 ? TextAlign.right : TextAlign.left,
            disableLengthCheck: true,
            cursorColor: primaryColor,
            dropdownIcon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: black23Color,
            ),
            initialCountryCode: "IN",
            dropdownIconPosition: IconPosition.trailing,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: getTranslation(context, 'login.enter_number'),
              hintStyle: semibold16Grey,
            ),
          ),
        )
      ],
    );
  }

  nameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslation(context, 'register.name'),
          style: semibold16BlackText,
        ),
        heightSpace,
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.25),
                blurRadius: 6,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: primaryColor),
            ),
            child: TextField(
              keyboardType: TextInputType.name,
              cursorColor: primaryColor,
              style: const TextStyle(height: 1.4),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  size: 18,
                ),
                hintText: getTranslation(context, 'register.enter_name'),
                hintStyle: semibold16Grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  passwordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslation(context, 'register.password'),
          style: semibold16BlackText,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.25),
                blurRadius: 6,
              ),
            ],
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(primary: primaryColor),
                ),
                child: TextField(
                  obscureText: _obscurePassword,
                  cursorColor: primaryColor,
                  style: const TextStyle(height: 1.4),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 18,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    hintText:
                        getTranslation(context, 'register.enter_password'),
                    hintStyle: semibold16Grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (backPressTime == null ||
        now.difference(backPressTime!) > const Duration(seconds: 2)) {
      backPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: blackColor,
          content: Text(
            getTranslation(context, 'app_exit.exit_text'),
            style: semibold16White,
          ),
        ),
      );
      return false;
    } else {
      return true;
    }
  }
}

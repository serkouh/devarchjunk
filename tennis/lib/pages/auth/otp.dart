import 'dart:async';

import 'package:tennis/localization/localization_const.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../theme/theme.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: medium22Primary,
    margin: const EdgeInsets.symmetric(horizontal: fixPadding / 1.5),
    decoration: BoxDecoration(
      color: whiteColor,
      boxShadow: [
        BoxShadow(color: blackColor.withOpacity(0.25), blurRadius: 6)
      ],
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: medium22Primary,
    margin: const EdgeInsets.symmetric(horizontal: fixPadding / 1.5),
    decoration: BoxDecoration(
      color: whiteColor,
      boxShadow: [
        BoxShadow(color: primaryColor.withOpacity(0.25), blurRadius: 6)
      ],
      border: Border.all(color: primaryColor),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(minutes: 1));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(
        () {
          final seconds = myDuration.inSeconds - reduceSecondsBy;
          if (seconds < 0) {
            countdownTimer!.cancel();
          } else {
            myDuration = Duration(seconds: seconds);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            backButton(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(fixPadding * 2.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  vertificationText(),
                  height5Space,
                  heightSpace,
                  confirmText(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  otpField(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  timer(minutes, seconds),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  verifyButton(),
                  heightSpace,
                  height5Space,
                  resendText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  resendText() {
    return Text.rich(
      TextSpan(
        text: getTranslation(context, "otp.didn't_text"),
        style: semibold14BlackText,
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            text: getTranslation(context, 'otp.resend_OTP'),
            style: bold16Primary,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (myDuration == const Duration(seconds: 0)) {
                  resetTimer();
                  startTimer();
                }
              },
          )
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  verifyButton() {
    return InkWell(
      onTap: () {
        Timer(const Duration(seconds: 3), () {
          Navigator.pushNamed(context, '/bottombar');
        });
        pleasewaitDialog();
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
          getTranslation(context, 'otp.verify'),
          style: bold18White,
        ),
      ),
    );
  }

  pleasewaitDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(fixPadding * 2.0),
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              heightSpace,
              const CircularProgressIndicator(
                color: primaryColor,
              ),
              heightSpace,
              height5Space,
              Text(
                getTranslation(context, "otp.please_wait"),
                style: semibold16Primary,
              ),
            ],
          ),
        );
      },
    );
  }

  vertificationText() {
    return Text(
      getTranslation(context, 'otp.OTP_verification'),
      style: bold22BlackText,
      textAlign: TextAlign.center,
    );
  }

  confirmText() {
    return Text(
      getTranslation(context, 'otp.confirm_text'),
      style: semibold15Grey,
      textAlign: TextAlign.center,
    );
  }

  timer(String minutes, String seconds) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: fixPadding / 2, horizontal: fixPadding * 2.5),
        decoration: BoxDecoration(
          color: const Color(0xFFDCE0E5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          "$minutes : $seconds",
          textAlign: TextAlign.center,
          style: semibold14Primary,
        ),
      ),
    );
  }

  otpField() {
    return Form(
      key: formKey,
      child: Pinput(
        controller: pinController,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: focusedPinTheme,
        onCompleted: (value) {
          Timer(const Duration(seconds: 3), () {
            Navigator.pushNamed(context, '/bottombar');
          });
          pleasewaitDialog();
        },
        cursor: Container(
          width: 2,
          height: 20,
          color: primaryColor,
        ),
      ),
    );
  }

  backButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ],
    );
  }
}

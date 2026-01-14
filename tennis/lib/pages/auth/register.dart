import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/theme/theme.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(context),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: fixPadding * 2.0,
                  right: fixPadding * 2.0,
                  bottom: fixPadding * 2.0,
                ),
                children: [
                  topImage(size),
                  heightSpace,
                  rideText(context),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  registerText(context),
                  height5Space,
                  welcomeText(context),
                  heightSpace,
                  heightSpace,
                  nameField(context),
                  heightSpace,
                  heightSpace,
                  emailField(context),
                  heightSpace,
                  heightSpace,
                  mobileField(context),
                  heightSpace,
                  heightSpace,
                  passwordField(context),
                  heightSpace,
                  heightSpace,
                  confirmPasswordField(context),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  registerButton(context),
                ],
              ),
            ),
          ],
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

  registerButton(context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/otp');
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
          getTranslation(context, 'register.register'),
          style: bold18White,
        ),
      ),
    );
  }

  mobileField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslation(context, 'register.mobile_number'),
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
              keyboardType: TextInputType.phone,
              cursorColor: primaryColor,
              style: const TextStyle(height: 1.4),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.phone_android,
                  size: 18,
                ),
                hintText: getTranslation(context, 'register.enter_number'),
                hintStyle: semibold16Grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  emailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslation(context, 'register.email_address'),
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
              keyboardType: TextInputType.emailAddress,
              cursorColor: primaryColor,
              style: const TextStyle(height: 1.4),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  size: 18,
                ),
                hintText: getTranslation(context, 'register.enter_email'),
                hintStyle: semibold16Grey,
              ),
            ),
          ),
        ),
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

  confirmPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslation(context, 'register.confirm_password'),
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
                  //  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
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
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    hintText: getTranslation(
                        context, 'register.confirm_password_hint'),
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

  welcomeText(context) {
    return Text(
      getTranslation(context, 'register.welcome_text'),
      style: bold15Grey,
      textAlign: TextAlign.center,
    );
  }

  registerText(context) {
    return Text(
      getTranslation(context, 'register.register'),
      style: bold22BlackText,
      textAlign: TextAlign.center,
    );
  }

  rideText(context) {
    return Text(
      getTranslation(context, 'register.ride_text'),
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
}

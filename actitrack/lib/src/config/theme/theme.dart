import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:actitrack/src/config/constants/constants.dart';
import 'package:actitrack/src/config/constants/palette.dart';

abstract class AppTheme {
  static ThemeData defaultThemeData() {
    return ThemeData(
      applyElevationOverlayColor: false,
      brightness: Brightness.light,
      fontFamily: mainFontFam,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              fontSize: 25.sp,
              color: Colors.white,
              fontFamily: mainFontFam,
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return kDisabledColor;
              }
              return kPrimaryColor;
            },
          ),
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        alignedDropdown: false,
        colorScheme: ColorScheme(
          background: Color(0xFFFFFBFF),
          brightness: Brightness.light,
          error: Color(0xFFBA1A1A),
          errorContainer: Color(0xFFFFDAD6),
          inversePrimary: Color(0xFFFFB1C8),
          inverseSurface: Color(0xFF352F30),
          onBackground: Color(0xFF201A1B),
          onError: Color(0xFFFFFFFF),
          onErrorContainer: Color(0xFF410002),
          onInverseSurface: Color(0xFFFAEEEF),
          onPrimary: Color(0xFFFFFFFF),
          onPrimaryContainer: Color(0xFF001F24),
          onSecondary: Color(0xFFFFFFFF),
          onSecondaryContainer: Color(0xFF000A64),
          onSurface: Color(0xFF201A1B),
          onSurfaceVariant: const Color(0xFFD9D9D9),
          onTertiary: Color(0xFFFFFFFF),
          onTertiaryContainer: Color(0xFF001F24),
          outline: Color(0xFF837377),
          outlineVariant: Color(0xFFD5C2C6),
          primary: kPrimaryColor,
          primaryContainer: Color(0xFF2F2F2F),
          scrim: Color(0xFF000000),
          secondary: kSecondaryColor,
          secondaryContainer: Color(0xFFDFE0FF),
          shadow: Color(0xFF000000),
          surface: Color(0xFFFFFBFF),
          surfaceTint: Color(0xFF984061),
          surfaceVariant: Color(0xFFF2DDE1),
          tertiary: Color(0xFF8F8F8F),
          tertiaryContainer: Color(0xFF97F0FF),
        ),
        height: 36,
        layoutBehavior: ButtonBarLayoutBehavior.padded,
        minWidth: 88,
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(2, 2),
            topRight: Radius.elliptical(2, 2),
            bottomLeft: Radius.elliptical(2, 2),
            bottomRight: Radius.elliptical(2, 2),
          ),
          side: BorderSide.none,
        ),
        textTheme: ButtonTextTheme.normal,
      ),
      canvasColor: const Color(0xFFFFFBFF),
      cardColor: const Color(0xFFFFFFFF),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        secondary: kSecondaryColor,
        error: kErrorColor,
        primary: kPrimaryColor,
        surface: kBackgroundColor,
        background: kBackgroundColor,
        brightness: Brightness.light,
      ),
      dialogBackgroundColor: Color(0xFFFFFBFF),
      disabledColor: Color(0xFFA2A2A2),
      dividerColor: Color(0x1F201A1B),
      focusColor: Color(0x1F000000),
      highlightColor: Color(0x66BCBCBC),
      hintColor: Color.fromRGBO(0, 0, 0, 0.6),
      hoverColor: Color(0x0A000000),
      iconTheme: IconThemeData(color: Color(0xDD000000)),
      indicatorColor: Color(0xFFFFFFFF),
      inputDecorationTheme: InputDecorationTheme(
        alignLabelWithHint: false,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
          ),
        ),
        filled: false,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        isCollapsed: false,
        isDense: false,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      platform: TargetPlatform.windows,
      primaryColor: kPrimaryColor,
      primaryColorDark: Color(0xFF1976D2),
      primaryColorLight: Color(0xFFBBDEFB),
      primaryIconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      primaryTextTheme: TextTheme(),
      scaffoldBackgroundColor: kBackgroundColor,
      secondaryHeaderColor: Color(0xFFE3F2FD),
      shadowColor: Color(0xFF000000),
      splashColor: Color(0x66C8C8C8),
      splashFactory: InkSplash.splashFactory,
      textTheme: TextTheme(
        titleMedium: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: mainFontFam,
          fontWeight: FontWeight.w800,
          height: 0,
        ),
      ),
      unselectedWidgetColor: const Color(0xFF0029FF).withOpacity(0.12),
      useMaterial3: false,
      visualDensity: VisualDensity.compact,
      // chipTheme: ChipThemeData(
      //   backgroundColor:  Colors.transparent ,
      //   disabledColor: kDisabledColor,
      //   labelPadding: EdgeInsets.all(8),
      //   labelStyle: TextStyle(
      //     color: kSecondaryColor,
      //     fontSize: 20.sp,
      //     fontFamily: mainFontFam,
      //   ),
      //   padding: EdgeInsets.all(8),
      //   secondaryLabelStyle: TextStyle(
      //     color: Colors.white,
      //     fontSize: 20.sp,
      //     fontFamily: mainFontFam,
      //   ),
      //   secondarySelectedColor: kPrimaryColor,
      //   selectedColor: const Color(0xFF0029FF).withOpacity(0.12),,
      // ),
    );
  }
}

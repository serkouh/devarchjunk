import 'package:tennis/localization/localization_const.dart';
import 'package:tennis/pages/profile/app_settings.dart';

import 'package:tennis/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'localization/localization.dart';
import 'pages/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: whiteColor,
        fontFamily: "Mulish",
      ),
      home: const LoginScreen(),
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('id'),
        Locale('zh'),
        Locale('ar'),
      ],
      localizationsDelegates: [
        Localization.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocale) {
        for (var locale in supportedLocale) {
          if (locale.languageCode != deviceLocale?.languageCode) {
            return deviceLocale;
          }
        }
        return supportedLocale.first;
      },
      onGenerateRoute: routes,
    );
  }

  Route<dynamic>? routes(settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.fade,
          settings: settings,
        );
      case '/onboarding':
        return PageTransition(
          child: const OnboardingScreen(),
          type: PageTransitionType.fade,
          settings: settings,
        );
      case '/login':
        return PageTransition(
          child: const LoginScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/register':
        return PageTransition(
          child: RegisterScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/otp':
        return PageTransition(
          child: const OTPScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/bottombar':
        return PageTransition(
          child: const BottomNavigationScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/home':
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/search':
        return PageTransition(
          child: const SearchScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/searchResult':
        return PageTransition(
          child: const SearchResultScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/direction':
        return PageTransition(
          child: const DirectionScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/detail':
        return PageTransition(
          child: const DetailScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/scan':
        return PageTransition(
          child: const ScanScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/securityDeposit':
        return PageTransition(
          child: const SecurityDeposit(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/creditcard':
        return PageTransition(
          child: const CreditCardScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/success':
        return PageTransition(
          child: const SuccessScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/startRide':
        return PageTransition(
          child: const StartRideScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/endRide':
        return PageTransition(
          child: const EndRideScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/confirm':
        return PageTransition(
          child: const ConfirmScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/wallet':
        return PageTransition(
          child: const WalletScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/addmoney':
        return PageTransition(
          child: const AddMoneyScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/walletSuccess':
        return PageTransition(
          child: const WalletSuccessScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/receipt':
        return PageTransition(
          child: const ReceiptScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/notification':
        return PageTransition(
          child: const NotificationScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/profile':
        return PageTransition(
          child: const ProfileScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/editProfile':
        return PageTransition(
          child: const EditProfileScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/ridehistory':
        return PageTransition(
          child: const RideHistoryScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/referAndEarn':
        return PageTransition(
          child: const ReferAndEarnScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/language':
        return PageTransition(
          child: const LanguageScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/appSettings':
        return PageTransition(
          child: const AppSettingScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/FAQs':
        return PageTransition(
          child: const FAQsScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/termsAndCondition':
        return PageTransition(
          child: const TermsAndConditionScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/privacyPolicy':
        return PageTransition(
          child: const PrivacyPolicyScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case '/help':
        return PageTransition(
          child: const HelpScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      default:
        return null;
    }
  }
}

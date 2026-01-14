import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:actitrack/src/config/constants/constants.dart';
import 'package:actitrack/src/config/theme/theme.dart';
import 'package:actitrack/src/root.dart';
import 'package:actitrack/src/services/api/tasks_service.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/state/providers/auth_provider.dart';
import 'package:actitrack/src/state/providers/map/map_state_provider.dart';
import 'package:actitrack/src/state/providers/tasks/ongoing_task_provider.dart';
import 'package:actitrack/src/state/providers/tasks/tasks_provider.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:actitrack/src/view/screens/main/auth/auth_screen.dart';
import 'package:actitrack/src/view/screens/main/home/home_screen.dart';
import 'package:actitrack/src/view/screens/main/map/map_screen.dart';
import 'package:toastification/toastification.dart';
import 'package:provider/provider.dart';

class FlyersApp extends StatelessWidget {
  const FlyersApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        MyLogger.error(details.exception);
        MyLogger.trace(details.stack);
      }
    };
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
            create: (context) => TasksProvider(serviceLocator<TasksService>())),
        ChangeNotifierProvider(create: (context) => OngoingTaskProvider()),
        ChangeNotifierProvider(create: (context) => MapViewStateProvider()),
      ],
      builder: (inContext, _) {
        // String? token = Prefs.getUserAccessToken();
        return ToastificationWrapper(
          child: ScreenUtilInit(
            designSize: const Size(350, 640),
            builder: (BuildContext context, Widget? child) {
              return MaterialApp(
                title: 'ActiTrack',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.defaultThemeData(),
                // initialRoute: inContext.read<AuthProvider>().isAuthenticated ? kHomeRoute : kAuthRoute,
                // initialRoute: kAuthRoute,
                home: Root(),
                routes: {
                  kAuthRoute: (context) => const AuthScreen(),
                  kHomeRoute: (context) => HomeScreen(),
                  kMapRoute: (context) => MapScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}

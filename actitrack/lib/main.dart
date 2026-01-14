import 'dart:async';

import 'package:flutter/material.dart';
import 'package:actitrack/src/app.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/utils/logging/logger.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      setupServiceLocator();
      await Future.wait([
        Prefs.init(),
      ]);
      runApp(const FlyersApp());
    },
    (error, stackTrace) {
      MyLogger.error('runZonedGuarded: Uncaught error: $error');
      MyLogger.trace(stackTrace.toString());
    },
  );
}

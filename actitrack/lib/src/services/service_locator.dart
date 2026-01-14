import 'package:actitrack/src/services/api/task/ongoing_task_service.dart';
import 'package:actitrack/src/services/api/tasks_service.dart';
import 'package:actitrack/src/services/http_client.dart';
import 'package:actitrack/src/services/location/location_service.dart';
import 'package:actitrack/src/services/permissions/permissions_service.dart';
import 'package:get_it/get_it.dart';

import 'api/auth/auth.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator
    ..registerSingleton<AppHttpClient>(AppHttpClient())
    ..registerLazySingleton<AuthService>(
        () => AuthService(appHttpClient: serviceLocator<AppHttpClient>()))
    ..registerLazySingleton<TasksService>(() => TasksService())
    ..registerLazySingleton<OngoingTaskService>(() => OngoingTaskService())
    ..registerLazySingleton<PermissionsService>(() => PermissionsService())
    ..registerLazySingleton<LocationService>(() => LocationService());
}

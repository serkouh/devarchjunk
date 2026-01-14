import 'dart:convert';

import 'package:actitrack/src/config/constants/fake_data.dart';
import 'package:actitrack/src/models/target_location.dart';
import 'package:actitrack/src/models/task.dart';
import 'package:actitrack/src/models/zone.dart';
import 'package:actitrack/src/services/http_client.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://actitrack.nuancestraiteur.com/api';

class TasksService {
  Future<Task?> fetchTaskTargetLocationsAndZone(taskId) async {
    // Load tasks from the API
    final response = await serviceLocator<AppHttpClient>()
        .getRequest("/animateur/tasks/${taskId['id']}");
    MyLogger.info(response.body);
    if (response.statusCode == 200) {
      List<TargetLocation> locs = [];
      Task temp = Task.fromJson(jsonDecode(response.body));
      final data =
          List.from(jsonDecode(response.body)['task']['taskLocations']);
      for (var loc in data) {
        MyLogger.info("---------------");

        locs.add(TargetLocation.fromJson(loc));
      }
      temp.locations = locs;
      temp.zone = Zone.fromJson(jsonDecode(response.body)['task']['zone']);
      return temp;
    }
    return null;
    // return dummyTasksData;
  }

  Future<List<Task>> loadTasks() async {
    // Load tasks from the API
    final response =
        await serviceLocator<AppHttpClient>().getRequest("/animateur/tasks");
    // final response = await http.get(Uri.parse("https://actitrack.nuancestraiteur.com/api/animateur/tasks"), headers: {
    //   'Content-Type': 'application/json',
    // });

    if (response.statusCode == 200) {
      List<Task> tasks = [];

      final data = List.from(jsonDecode(response.body)['data']);
      MyLogger.info(data);
      for (var task in data) {
        // Task _task = Task.fromJson(task);
        Task? _task = await fetchTaskTargetLocationsAndZone(task);
        /* if (otherData != null) {
          _task.locations = otherData.$1;
          _task.zone = otherData.$2;
        }*/
        if (_task != null) {
          tasks.add(_task);
        }
      }
      MyLogger.info('Tasks loaded successfully $tasks');
      return tasks;
    }
    return <Task>[];
    // return dummyTasksData;
  }

  Future<List<Task>> loadTodayTasks() async {
    // Load tasks from the API
    final response = await serviceLocator<AppHttpClient>()
        .getRequest("/animateur/tasks?date=today");
    // final response = await http.get(Uri.parse("https://actitrack.nuancestraiteur.com/api/animateur/tasks"), headers: {
    //   'Content-Type': 'application/json',
    // });
    MyLogger.info(response.body);
    if (response.statusCode == 200) {
      List<Task> tasks = [];

      final data = jsonDecode(response.body)["data"];
      for (var task in data) {
        tasks.add(Task.fromJson(task));
      }
      MyLogger.info('Tasks loaded successfully $tasks');
      return tasks;
    }
    return <Task>[];
    // return dummyTasksData;
  }
}

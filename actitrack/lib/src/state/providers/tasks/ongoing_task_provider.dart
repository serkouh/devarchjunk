import 'package:flutter/material.dart';
import 'package:actitrack/src/models/target_location.dart';
import 'package:actitrack/src/models/task.dart';
import 'package:actitrack/src/services/api/task/ongoing_task_service.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/utils/logging/logger.dart';

class OngoingTaskProvider with ChangeNotifier {
  final OngoingTaskService _taskService = serviceLocator<OngoingTaskService>();

  Task? _currentTask;
  Task? get currentTask => _currentTask;
  bool get taskInProgress => currentTask != null;

  void startTask(Task task) {
    _currentTask = task;
    print("mmmmmmmmmmmmmmmmmmmmmmmmm");
    print(_currentTask!.flyersDistributed);
    notifyListeners();
  }

  void cancelTask() {
    _currentTask = null;
    notifyListeners();
  }

  void changedistribution(int distribution) {
    print("aaaaaaaaaaaaaabbbbbbbbbbbbbbbbbb" + distribution.toString());
    print(_currentTask);
    print(_currentTask!.flyersDistributed);
    if (_currentTask == null) {
      print("Error: Current task is null");
      return;
    } else {
      print("sucess: Current task is not null");
    }
    _currentTask!.flyersDistributed =
        _currentTask!.flyersDistributed + distribution;

    notifyListeners();
    if (_currentTask!.flyersDistributed >= _currentTask!.flyersCount!) {
      print("compelted sucessfully");

      completeTask();
    }
  }

  Future<void> completeTask({bool notify = true}) async {
    if (_currentTask != null) {
      // this line might not be needed
      bool res =
          await _taskService.updateTaskStatus(_currentTask!.id!, 'completed');

      if (res) {
        _currentTask!.status = 'completed';
      }

      // _currentTask = null;
      if (notify) notifyListeners();
    }
  }

  markDeliveryAsDone(TargetLocation deliveryLocation,
      Map<String, dynamic> deliveryData) async {
    // try {
    //   if (_currentTask != null) {
    //     if (_currentTask!.locations == null) return;
    //     await _taskService.markDeliveryLocationAsDone(_currentTask!.id, deliveryLocation.id, deliveryData);
    //     int index = _currentTask!.locations.indexOf(deliveryLocation); //= deliveryLocation;
    //     if (_currentTask!.locations[index].deliveryCompleted == false) {
    //       _currentTask!.locations[index] = deliveryLocation.copyWith(deliveryCompleted: true);
    //       if (_currentTask!.flyersDistributed < _currentTask!.flyersCount) {
    //         _currentTask!.flyersDistributed++;
    //       }
    //       if (_currentTask!.flyersLeft > 0) {
    //         _currentTask!.flyersLeft--;
    //       }
    //       completeTask(notify: false);
    //     }
    //     notifyListeners();
    //     return true;
    //   }
    // } catch (e) {
    //   MyLogger.error('Error marking delivery as done: $e');
    // }
    return false;
  }

  // Additional methods can be added here
}

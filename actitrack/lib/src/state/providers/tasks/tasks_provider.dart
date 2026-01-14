import 'package:flutter/material.dart';
import 'package:actitrack/src/config/constants/enums.dart';
import 'package:actitrack/src/models/target_location.dart';
import 'package:actitrack/src/models/task.dart';
import 'package:actitrack/src/services/api/tasks_service.dart';
import 'package:actitrack/src/utils/logging/logger.dart';

class TasksProvider extends ChangeNotifier {
  final TasksService _tasksService;

  TasksProvider(this._tasksService) {
    fetchTasks();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks.where((Task task) {
        switch (currentStatus) {
          case TaskStatus.completed:
            return task.isCompleted;
          case TaskStatus.cancelled:
            return task.isCancelled;
          case TaskStatus.today:
            return task.isToday;
          case TaskStatus.tomorrow:
            return task.isTomorrow;
          default:
            return false;
        }
      }).toList();

  bool _loading = true;
  bool get loading => _loading;

  TaskStatus _currentStatus = TaskStatus.today;
  TaskStatus get currentStatus => _currentStatus;
  set currentStatus(TaskStatus status) {
    if (status != _currentStatus) {
      _currentStatus = status;
      notifyListeners();
    }
  }

  //mark the a location of a task as done
  void markDeliveryLocationOfTaskAsDone(Task task, TargetLocation location) {
    if (task.locations == null) return;
    int index = task.locations!.indexOf(location);
    task.locations![index] = location.copyWith(deliveryCompleted: true);
    if (task.locations![index].deliveryCompleted) {
      int taskIndex = tasks.indexWhere((element) => element.id == task.id);
      _tasks[taskIndex] = task;
      // _tasksService.markDeliveryLocationAsDone(task.id, task.locations[index].id);
    }
    notifyListeners();
  }

  markTaskAsCompleted(Task task) {
    final int index = _tasks.indexWhere((tsk) => tsk.id == task.id);
    _tasks[index].status = 'completed';
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    try {
      if (!_loading) _loading = true;
      _tasks = await _tasksService.loadTasks();
    } catch (e) {
      MyLogger.info('Error fetching tasks: $e');
    } finally {
      _loading = false;
    }
    notifyListeners();
  }
}

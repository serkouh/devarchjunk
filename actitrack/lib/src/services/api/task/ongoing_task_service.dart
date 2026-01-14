import 'package:actitrack/src/utils/logging/logger.dart';

class OngoingTaskService {
  Future<bool> updateTaskStatus(int taskId, String newStatus) async {
    // Code to update task status on the backend goes here
    /* await Future.delayed(
        const Duration(seconds: 1)); */
    MyLogger.info('Task $taskId status updated to $newStatus on the backend');
    return true;
  }

  // Additional service methods can be added here
  markTaskAsCompleted(int taskId) async {
    // Code to mark task as done on the backend goes here
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network delay
    MyLogger.info('Task $taskId marked as done on the backend');
  }

  Future markDeliveryLocationAsDone(
      int taskId, int locationId, Map<String, dynamic> deliveryData) async {
    // Code to mark delivery location as done on the backend goes here
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network delay
    MyLogger.info(
        'Task $taskId location $locationId marked as done on the backend');
  }
}

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/Modal/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _deletedTasks = [];
  late Box<Task> tasksBox;

  List<Task> get tasks => _tasks.where((task) => !task.isDeleted).toList();
  List<Task> get deletedTasks => _deletedTasks;

  TaskProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    if (!Hive.isBoxOpen('tasksBox')) {
      tasksBox = await Hive.openBox<Task>('tasksBox');
    } else {
      tasksBox = Hive.box<Task>('tasksBox');
    }
    fetchTasks();
  }

  void fetchTasks() {
    _tasks = tasksBox.values.toList();
    _deletedTasks = _tasks.where((task) => task.isDeleted).toList();
    notifyListeners();
  }

  void addTask(String title, DateTime endDate) {
    final newTask = Task(
      title: title,
      startDate: DateTime.now(),
      endDate: endDate,
    );
    tasksBox.add(newTask);
    _tasks.add(newTask);
    notifyListeners();
  }

  void toggleTaskStatus(int index) {
    final task = tasksBox.getAt(index)!;
    task.isDone = !task.isDone;
    task.save();
    notifyListeners();
  }

  void removeTask(int index) {
    final task = tasksBox.getAt(index)!;
    task.isDeleted = true;
    task.save();
    _deletedTasks.add(task);
    _tasks.removeAt(index);
    notifyListeners();
  }

  void undoRemoveTask(Task task, int index) {
    task.isDeleted = false;
    task.save();
    _deletedTasks.remove(task);
    _tasks.insert(index, task);
    notifyListeners();
  }

  void clearDeletedTasks() {
    final twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
    _deletedTasks.removeWhere((task) {
      if (task.endDate.isBefore(twoDaysAgo)) {
        task.delete();
        return true;
      }
      return false;
    });
    notifyListeners();
  }
}

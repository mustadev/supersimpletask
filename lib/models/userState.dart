import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:supersimpletask/helpers/fileHelper.dart';
import 'package:supersimpletask/models/task.dart';

class UserState extends ChangeNotifier {
  final List<Task> _tasks = [];
  bool _hasPassword;
  int _lastDeletedTaskIndex;

  UserState(){
    FileHelper.hasPassword().then((value) => this._hasPassword = value);
  }

  UnmodifiableListView<Task> get allTasks => UnmodifiableListView(_tasks);
  UnmodifiableListView<Task> get incompleteTasks =>
      UnmodifiableListView(_tasks.where((todo) => !todo.done));
  UnmodifiableListView<Task> get completedTasks =>
      UnmodifiableListView(_tasks.where((todo) => todo.done));
  
  set hasPassword(bool hasPassword) => this._hasPassword = hasPassword;

  bool get hasPassword => this._hasPassword;
  
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void addAllTasks(List<Task> tasks){
    _tasks.addAll(tasks);
  }

  void toggleDone(Task task) {
    final taskIndex = _tasks.indexOf(task);
    _tasks[taskIndex].toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _lastDeletedTaskIndex = _tasks.indexOf(task);
    _tasks.remove(task);
    notifyListeners();
  }

  void undoDeleteTask(Task task){
    if (_lastDeletedTaskIndex == null) return;
    _tasks.insert(_lastDeletedTaskIndex, task);
    notifyListeners();
  }

  void updateTask(Task task){
    final index = _tasks.indexWhere((t){
       print("task ${task.key.toString()}");
       print("t ${t.key.toString()}");
       return t.key == task.key;
    });
    assert(index >= 0, "unvalid index $index of task ${task.title} !!!");
    _tasks.removeAt(index);
    _tasks.insert(index, task);
    notifyListeners();
  }
  
  void markAsNotified(Task task){
    final index = _tasks.indexOf(task);
    _tasks[index].markAsNotified();
    notifyListeners();
  }

}
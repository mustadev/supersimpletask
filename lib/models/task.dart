import 'package:flutter/material.dart';
import './attachFile.dart';
import './attachLink.dart';

class Task {
  final Key key ;
  String title;
  String details;
  Set<AttachFile> attachFiles;
  Set<AttachLink> attachLinks;
  bool notified;
  bool done;
  DateTime date;
  List<String> tags;

  Task({
    @required this.key,
    @required this.title,
    this.details,
    this.attachFiles,
    this.attachLinks,
    this.notified = false,
    this.done = false,
    this.date,
    this.tags,
  }) {
    assert(key != null, "key can not be null! use UniqueKey");
    print("${key.toString()}");
    assert(this.title != null);
  }

  void toggleDone() {
    this.done = !this.done;
  }

  markAsNotified() {
    this.notified = true;
  }

  Task copyWith({
    String title,
    String details,
    Set<AttachFile> attachFiles,
    Set<AttachLink> attachLinks,
    bool notified,
    bool done,
    DateTime date,
    List<String> tags,
  }) {
    return Task(
        key: key,
        title: title ?? this.title,
        details: details ?? this.details,
        attachFiles: attachFiles ?? this.attachFiles,
        attachLinks: attachLinks ?? this.attachLinks,
        notified: notified ?? this.notified,
        done: done ?? this.done,
        date: date,
        tags: tags ?? this.tags);
  }

  static Map<String, dynamic> toJson(Task task) {
    var attachFiles = task.attachFiles
        .map((attachFile) => AttachFile.toJson(attachFile))
        .toList();
    var attachLinks = task.attachLinks
        .map((attachLink) => AttachLink.toJson(attachLink))
        .toList();
    var date = task.date?.millisecondsSinceEpoch;
    return {
      "title": task.title,
      "details": task.details,
      "attachFiles": attachFiles,
      "attachLinks": attachLinks,
      "notified": task.notified,
      "done": task.done,
      "date": date,
      "tags": task.tags,
    };
  }

  static Task fromJson(Map<String, dynamic> task) {
    String title = task["title"];
    String details = task["details"];
    Set<AttachFile> attachFiles = Set.from(task["attachFiles"]
        .map((attachFile) => AttachFile.fromJson(attachFile))
        .toList());
    Set<AttachLink> attachLinks = Set.from(task["attachLinks"]
        .map((attachLink) => AttachLink.fromJson(attachLink))
        .toList());
    bool notified = task["notified"];
    bool done = task["done"];
    var dateInMilliSecond = task["date"];
    DateTime date = dateInMilliSecond == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond);
    List<String> tags = task["tags"];

    return Task(
      key: UniqueKey(),
      title: title,
      details: details,
      attachFiles: attachFiles,
      attachLinks: attachLinks,
      notified: notified,
      done: done,
      date: date,
      tags: tags,
    );
  }
}

class TaskList {
  final List<Task> tasks;

  TaskList({this.tasks});

  static TaskList fromJson(Map<String, dynamic> map) {
    var tasks = map["tasks"] as List;
    if (tasks == null) {
      return TaskList(tasks: []);
    }
    tasks = tasks.map((task) {
      return Task.fromJson(task);
    }).toList();
    return TaskList(tasks: tasks);
  }

  static Map<String, dynamic> toJson(TaskList taskList) {
    var tasks = taskList.tasks.map((task) {
      return Task.toJson(task);
    }).toList();
    return {
      "tasks": tasks,
    };
  }
}

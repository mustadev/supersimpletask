import 'package:flutter/material.dart';
import 'package:supersimpletask/models/task.dart';
import 'package:supersimpletask/screens/taskEditor.dart';

class TaskDisplay extends StatelessWidget {
  static const String routeName = "/display";
  final Task task;

  TaskDisplay({this.task});

  @override
  Widget build(BuildContext context) {
    final dateWidget = task.date != null
        ? Row(
            children: <Widget>[
              Text("Date: ", style: Theme.of(context).textTheme.subtitle),
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "${task.date.day}/${task.date.month} ${task.date.hour}:${task.date.minute}",
                  style: Theme.of(context).textTheme.subtitle,
                ),
              )
            ],
          )
        : Container(
            width: 0,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed(TaskEditor.routeName, arguments: task),
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              dateWidget,
              SizedBox(height: 20.0),
              Text(
                "Details:",
                style: Theme.of(context).textTheme.subtitle,
              ),
              SizedBox(height: 5.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Color.lerp(
                      Theme.of(context).primaryColorLight.withAlpha(50),
                      Colors.grey.withAlpha(50),
                      0.5),
                ),
                child: Text(task.details,
                    style: Theme.of(context).textTheme.body2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

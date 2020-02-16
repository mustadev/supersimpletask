import 'package:flutter/material.dart';
import 'package:supersimpletask/models/task.dart';
import 'package:provider/provider.dart';
import 'package:supersimpletask/models/userState.dart';
import 'package:supersimpletask/screens/taskDisplay.dart';
import 'package:supersimpletask/screens/taskEditor.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem({@required this.task});

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: PhysicalShape(
        clipBehavior: Clip.antiAlias,
        elevation: 5.0,
        color: Colors.white,
        clipper: ShapeBorderClipper(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
            ),
          ),
        ),
        child: Material(
          child: Container(
            color: Colors.transparent,
            constraints: BoxConstraints(maxHeight: 200.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                taskDisplay(context),
                showButtons(userState, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget taskDisplay(BuildContext context) {
    final dateWidget = task.date != null
        ? Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: Text(
              "${task.date.day}/${task.date.month} ${task.date.hour}:${task.date.minute}",
              style: Theme.of(context).textTheme.subtitle,
            ),
          )
        : Container(
            width: 0,
          );
    final attachedFilesWidget = task.attachFiles.length != 0
        ? Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.image),
          )
        : Container(
            width: 0,
          );
    final attachedLinksWidget = task.attachLinks.length != 0
        ? Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.link),
          )
        : Container(
            width: 0,
          );
    return Expanded(
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        onTap: () {
          //display itemScreen.
          Navigator.pushNamed(context, TaskDisplay.routeName, arguments: task);
          print('tap');
        },
        onLongPress: () {
          print("${task.key.toString()}");
          Navigator.pushNamed(context, TaskEditor.routeName, arguments: task);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                task.title,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                task.details,
                style: Theme.of(context).textTheme.subtitle,
                maxLines: 4,
              ),
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  attachedFilesWidget,
                  attachedLinksWidget,
                  dateWidget,
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            )
          ],
        ),
      ),
    );
  }

  Widget showButtons(UserState userState, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.redAccent,
          ),
          onPressed: () {
            userState.deleteTask(task);

            Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Task Removed!"),
              action: SnackBarAction(
                label: "Undo",
                onPressed: () {
                  print("undo remove!");
                  userState.undoDeleteTask(task);
                },
              ),
            ));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.check,
            color: task.done ? Colors.red : Colors.grey,
          ),
          onPressed: () => userState.toggleDone(task),
        ),
      ],
    );
  }
}

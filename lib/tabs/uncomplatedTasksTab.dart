import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supersimpletask/models/userState.dart';
import 'package:supersimpletask/widgets/tasksList.dart';

class IncompleteTasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<UserState>(
        builder: (context, userState, child) => TaskList(
          tasks: userState.incompleteTasks,
        ),
      ),
    );
  }
}

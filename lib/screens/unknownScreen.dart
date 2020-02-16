import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Not Found!"),
        centerTitle: true,
      ),
      body: Container(
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: Text(
              "404",
              style: Theme.of(context).textTheme.display4,
            ),
          )),
    );
  }
}

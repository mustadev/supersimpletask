import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = "/about";

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text("Super Simple Text", style: textTheme.subhead),
              Text("Version: 1.0.0", style: textTheme.caption,),
              Text("Copyrigh 2019", style: textTheme.caption,),
              SizedBox(height: 20.0,),
              Text("app that manage your task"),
            ],
          ),
        ),
      ),
    );
  }
}

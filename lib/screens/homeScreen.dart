import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supersimpletask/screens/aboutScreen.dart';
import 'package:supersimpletask/screens/passwordScreen.dart';
import 'package:supersimpletask/screens/taskEditor.dart';
import 'package:supersimpletask/tabs/allTasksTab.dart';
import 'package:supersimpletask/tabs/complatedTasks.dart';
import 'package:supersimpletask/tabs/uncomplatedTasksTab.dart';
import 'package:android_intent/android_intent.dart';
import 'package:rate_my_app/rate_my_app.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  final RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateSuperSimpleTaskApp_',
    minDays: 5,
    minLaunches: 5,
    remindDays: 3,
    remindLaunches: 7,
    googlePlayIdentifier: "", // APP LINK HERE.
  );
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        return;
      }
      requestRating();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        title: Text(
          'TASKS',
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            Tab(text: 'All'),
            Tab(text: 'Incomplete'),
            Tab(text: 'Complete'),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: TabBarView(
          controller: controller,
          children: <Widget>[
            AllTasksTab(),
            IncompleteTasksTab(),
            CompletedTasksTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, TaskEditor.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xff8b6db6),
        height: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  
                  decoration: BoxDecoration(
                  ),
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  child: Image.asset(
                    "assets/icon.png",
                    fit: BoxFit.scaleDown,
                  ),
                ),
                InkWell(
                  splashColor: Colors.accents[0],
                  child: Container(
                    child: Center(
                      child: Text("PASSWORD",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.white70)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onTap: () {
                    Navigator.popAndPushNamed(
                        context, PasswordScreen.routeName);
                  },
                ),
                InkWell(
                  child: Container(
                    child: Center(
                      child: Text("MORE APPS",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.white70)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    if (Platform.isAndroid) {
                      AndroidIntent intent = AndroidIntent(
                        action: 'action_view',
                        data:
                            '', //TODO PUT STORE HERE
                      );
                      await intent.launch();
                    }
                  },
                ),
                InkWell(
                  child: Container(
                    child: Center(
                      child: Text("FEEDBACK",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.white70)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onTap: () async {
                    print("feedback tapped");
                    Navigator.pop(context);
                    _rateMyApp.init().then((_) {
                      requestRating();
                    });
                  },
                ),
                Spacer(),
                InkWell(
                  child: Container(
                    child: Center(
                      child: Text("ABOUT",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.white70)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onTap: () {
                    Navigator.popAndPushNamed(context, AboutScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void requestRating() {
    _rateMyApp.showStarRateDialog(
      context,
      title: 'Rate this app',
      message:
          'You like this app ? Then take a little bit of your time to leave a rating :',
      onRatingChanged: (stars) {
        return [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              if (stars == null){
                Navigator.pop(context);
                return;
              }
              if (stars < 4.0) {
                Navigator.pop(context);
                return;
              }
              _rateMyApp.doNotOpenAgain = true;
              _rateMyApp.save().then((v) async {
                Navigator.pop(context);
                // if (Platform.isAndroid) {
                //   AndroidIntent intent = AndroidIntent(
                //     action: 'action_view',
                //     data:
                //         'https://play.google.com/store/apps/details?id=com.redjacket.supersimpletask.supersimpletask',
                //   );
                //   await intent.launch();
                // }
                _rateMyApp.launchStore();
              });
            },
          ),
        ];
      },
      ignoreIOS: false,
      dialogStyle: DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: StarRatingOptions(),
    );
  }
}

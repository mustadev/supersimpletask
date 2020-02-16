import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supersimpletask/models/userState.dart';
import 'package:supersimpletask/screens/aboutScreen.dart';
import 'package:supersimpletask/screens/homeScreen.dart';
import 'package:supersimpletask/screens/loginScreen.dart';
import 'package:supersimpletask/screens/passwordScreen.dart';
import 'package:supersimpletask/screens/splashScreen.dart';
import 'package:supersimpletask/screens/taskDisplay.dart';
import 'package:supersimpletask/screens/taskEditor.dart';
import 'package:supersimpletask/screens/unknownScreen.dart';

void main() {
  runApp(SuperSimpleTask());
}

class SuperSimpleTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserState(),
      child: MaterialApp(
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: _generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Super Simple Task',
        theme: ThemeData(
          backgroundColor: Color.lerp(Colors.white, Color(0xff8b6db6), 0.2),
          primaryColor: Color(0xff5c4186),
          primaryColorLight: Color(0xff8b6db6),
          primaryColorDark: Color(0xff2f1959),
          accentColor: Color(0xffa7c776),
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
              brightness: Brightness.dark,
              color: Color(0xff5c4186),
              elevation: 0.0,
              iconTheme: IconThemeData(color: Color(0xffffffff), opacity: 0.6),
              textTheme: TextTheme(
                  title: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                textBaseline: TextBaseline.alphabetic,
                fontSize: 24.0,
              ))),
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 36, color: Colors.white60),
            subhead: TextStyle(
              fontSize: 20.0,
              color: Colors.black87,
              letterSpacing: 2.0,
            ),
            title: TextStyle(
              color: Colors.black38,
              fontSize: 24,
            ),
            subtitle: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            body1: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              letterSpacing: 1.0,
            ),
            body2: TextStyle(
              color: Colors.black54,
              fontSize: 20.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              wordSpacing: 1.0,
            ),
          ),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(),
            buttonColor: Color(0xff779649),
            splashColor: Color(0xffa7c776),
            highlightColor: Color(0xff49681d),
            disabledColor: Color(0xffa7c776),
          ),
          tabBarTheme: TabBarTheme(
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            unselectedLabelStyle: TextStyle(color: Colors.white70),
            indicator: BoxDecoration(
              color: Color(0xff5c4186),
              border: Border(
                bottom: BorderSide(
                  style: BorderStyle.solid,
                  color: Color(0xff779649),
                  width: 4.0,
                ),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            highlightElevation: 10.0,
            splashColor: Color(0xffa7c776),
            backgroundColor: Color(0xff779649),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(fontSize: 16.0, fontStyle: FontStyle.normal),
            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff49681d)),
            ),
          ),
        ),
      ),
    );
  }

  Route _generateRoute(RouteSettings settings){
    switch(settings.name){
      case SplashScreen.routeName:
      return MaterialPageRoute(builder: (_) => SplashScreen());
      case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => LoginScreen());
      case HomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => HomeScreen());
      case PasswordScreen.routeName:
      return MaterialPageRoute(builder: (_) => PasswordScreen());
      case TaskEditor.routeName:
      return MaterialPageRoute(builder: (_) => TaskEditor(task: settings.arguments,));
      case TaskDisplay.routeName:
      return MaterialPageRoute(builder: (_) => TaskDisplay(task: settings.arguments,));
      case AboutScreen.routeName:
      return MaterialPageRoute(builder: (_) => AboutScreen());
      default:
      return MaterialPageRoute(builder: (_) => UnknownScreen());
    }
  }

  //TODOS:
  //TODO make channel for the div content.
  //TODO Make app open source.
  //TODO use /assets for psfile and data file for more securety.
  //TODO edit Manifest 
  //TODO make About Screen.
  //TODO make Privicy.
  //TODO permession dynamic.
  //TODO test app on new phones or emilator.
  //TODO change the link of feedback button in drawer.
  //TODO make screenshots and video 
  //TODO publish app video in youtube steephDev.
  //TODO make app webpage using Github.
  //TODO Publish App.
  //TODO impliment Store.
  //TODO Add ChangeLog.
  //TODO add firebase Analytics.
  //TODO Make pro version.
}

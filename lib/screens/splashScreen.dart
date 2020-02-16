import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supersimpletask/helpers/fileHelper.dart';
import 'package:supersimpletask/models/userState.dart';
import 'package:supersimpletask/models/task.dart';
import 'package:supersimpletask/screens/homeScreen.dart';
import 'package:supersimpletask/screens/loginScreen.dart';

class SplashScreen extends StatefulWidget {
static const String routeName = "/";

  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    
    super.initState(); 
    //TODO check if from notification
    
    // Future.delayed(Duration(milliseconds: 500), check);
    
    
    
  }

  void check(){
    final UserState userState = Provider.of<UserState>(context);
    FileHelper.hasPassword().then((hasPassword) async {
      print("has Password : $hasPassword !!!!!!!");
      userState.hasPassword = hasPassword;
      if (hasPassword){
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        return;
      }else{
        final List<Task> tasks = await FileHelper.readTasksFromStorage();
        Provider.of<UserState>(context).addAllTasks(tasks);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
      
    });
    
    userState.addListener((){
      FileHelper.writeToStorageAsync(userState.allTasks);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    print("from build");
    check();
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Image.asset("assets/icon.png"),
          ),
          SizedBox(height: 100.0,),
          LinearProgressIndicator(value: null,),
          SizedBox(height: 20.0,)
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supersimpletask/helpers/fileHelper.dart';
import 'package:supersimpletask/models/userState.dart';
import 'package:supersimpletask/models/task.dart';
import 'package:supersimpletask/screens/homeScreen.dart';

class LoginScreen extends StatefulWidget {

  static const String routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  bool _showError = false;
  bool _isLoading = false;

  void _passwordValidator(BuildContext context) async {
    setState(() => this._isLoading = true);
    if (await FileHelper.isRealPassword(_passwordController.text)) {
      setState(() => this._isLoading = false); //TODO PUT indicator for
      final List<Task> tasks = await FileHelper.readTasksFromStorage();
      Provider.of<UserState>(context).addAllTasks(tasks);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      setState(() {
        this._showError = true;
        this._passwordController.clear();
        this._isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    this._passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ],
          stops: [0.1, 0.6],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        // color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              flex: 2,
              child: Center(
                  child: FlutterLogo(
                size: 100,
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 5.0, left: 20.0, right: 20.0),
              child: TextFormField(
                obscureText: true,
                keyboardType: TextInputType.text,
                controller: _passwordController,
                style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: " Enter Password",
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle.copyWith(color: Colors.white70),
                ),
               
                onTap: () {
                  print("tap");
                  setState(
                    () => this._showError = false,
                  );
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  this._passwordValidator(context);
                },
              ),
            ), //TODO Localization
            Opacity(
              opacity: this._showError ? 1.0 : 0,
              child: Container(
                child: Center(
                  child: Text(
                    "Wrong Password", //TODO Localization
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: Colors.redAccent),
                  ),
                ),
              ),
            ),
            this._isLoading
                ? CircularProgressIndicator()
                : RaisedButton(
                    child: Text(
                      "LOGIN",
                      style: Theme.of(context)
                          .textTheme
                          .button, 
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      this._passwordValidator(context);
                    },
                  ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supersimpletask/helpers/fileHelper.dart';
import 'package:supersimpletask/models/userState.dart';

class PasswordScreen extends StatefulWidget {
  static const String routeName = "/password";

  PasswordScreen();
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _createFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  final _createFirstController = TextEditingController();
  final _createSecondController = TextEditingController();
  final _editOldPasswordController = TextEditingController();
  final _editFirstController = TextEditingController();
  final _editSecondController = TextEditingController();
  FocusNode _createFormFocusNode;
  FocusNode _editFirstFormFocusNode;
  FocusNode _editSecondFormFocusNode;

  @override
  Widget build(BuildContext context) {
    final hasPassword = Provider.of<UserState>(context).hasPassword;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: hasPassword
            ? Text(
                "Change Password",
                style: Theme.of(context).textTheme.title,
              )
            : Text(
                "Create Password",
                style: Theme.of(context).textTheme.title,
              ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: hasPassword ? editPasswordForm() : createPasswordForm(),
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._createFormFocusNode = FocusNode();
    this._editFirstFormFocusNode = FocusNode();
    this._editSecondFormFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //this._hasPassword = await FileHelper.hasPassword();
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    this._createFirstController.dispose();
    this._createSecondController.dispose();
    this._editOldPasswordController.dispose();
    this._editFirstController.dispose();
    this._editSecondController.dispose();
    this._createFormFocusNode.dispose();
    this._editFirstFormFocusNode.dispose();
    this._editSecondFormFocusNode.dispose();
    super.dispose();
  }

  void _createPassword(BuildContext context) async {
    if (!_createFormKey.currentState.validate()) return;
    final password = this._createFirstController.text;
    final repassword = this._createSecondController.text;
    if (password != repassword) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Password Does Not Match"),
      ));
      return;
    }
    await FileHelper.writePassword(password);
    print("password written");
    Navigator.pop(context);
  }

  void _editPassword() async {
    if (!_editFormKey.currentState.validate()) return;
    if (!await FileHelper.isRealPassword(
        this._editOldPasswordController.text)) {
      this._scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Wrong Password!"),
          ));
      return; //TODO test is this is nessesary.
    }

    final password = this._editFirstController.text;
    final repassword = this._editSecondController.text;
    if (password != repassword) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Password Does Not Match"),
      ));
      return;
    }
    await FileHelper.writePassword(password);
    Navigator.pop(context);
  }

  Widget createPasswordForm() {
    return Form(
      key: _createFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            obscureText: true,
            autofocus: true,
            autocorrect: false,
            keyboardType: TextInputType.text,
            controller: this._createFirstController,
            decoration: InputDecoration(
              hintText: "Enter Password",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Password Can NOT be Empty!"; //TODO Localization
              }
              if (value.trim().isEmpty) {
                return "White spaces NOT allowed!";
              }
              return null;
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(this._createFormFocusNode);
            },
          ),
          TextFormField(
              focusNode: this._createFormFocusNode,
              obscureText: true,
              autocorrect: false,
              keyboardType: TextInputType.text,
              controller: this._createSecondController,
              decoration: InputDecoration(
                hintText: "Re-Enter Password",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Password Can NOT be Empty!"; //TODO Localization
                }
                if (value.trim().isEmpty) {
                  return "White spaces NOT allowed!";
                }
                return null;
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                this._createPassword(context);
              }),
          RaisedButton(
            child: Text("CREATE"),
            onPressed: () {
              FocusScope.of(context).unfocus();
              this._createPassword(context);
            },
          ),
        ],
      ),
    );
  }

  Widget editPasswordForm() {
    return Form(
      key: _editFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            obscureText: true,
            autofocus: true,
            autocorrect: false,
            keyboardType: TextInputType.text,
            controller: this._editOldPasswordController,
            decoration: InputDecoration(
              hintText: " Enter Old Password",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Password Can NOT be Empty!"; //TODO Localization
              }
              if (value.trim().isEmpty) {
                return "White spaces NOT allowed!";
              }
              return null;
            },
            onEditingComplete: () {
              FileHelper.isRealPassword(this._editOldPasswordController.text)
                  .then((isRealPassword) {
                if (isRealPassword) {
                  FocusScope.of(context)
                      .requestFocus(this._editFirstFormFocusNode);
                } else {
                  this._scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Wrong Password!"),
                      ));
                }
              });
            },
          ),
          TextFormField(
            obscureText: true,
            autofocus: true,
            autocorrect: false,
            focusNode: this._editFirstFormFocusNode,
            keyboardType: TextInputType.text,
            controller: this._createFirstController,
            decoration: InputDecoration(
              hintText: " Enter Password",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Password Can NOT be Empty!"; //TODO Localization
              }
              if (value.trim().isEmpty) {
                return "White spaces NOT allowed!";
              }
              return null;
            },
            onEditingComplete: () {
              FocusScope.of(context)
                  .requestFocus(this._editSecondFormFocusNode);
            },
          ),
          TextFormField(
            focusNode: this._editSecondFormFocusNode,
            obscureText: true,
            autocorrect: false,
            keyboardType: TextInputType.text,
            controller: this._createSecondController,
            decoration: InputDecoration(
              hintText: " Re-Enter Password",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Password Can NOT be Empty!"; //TODO Localization
              }
              if (value.trim().isEmpty) {
                return "White spaces NOT allowed!";
              }
              return null;
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              this._editPassword();
            },
          ),
          RaisedButton(
            child: Text("CREATE"),
            onPressed: () {
              FocusScope.of(context).unfocus();
              this._editPassword();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:supersimpletask/models/attachFile.dart';
import 'package:supersimpletask/models/attachLink.dart';
import 'package:supersimpletask/models/userState.dart';
import 'package:supersimpletask/models/task.dart';

class TaskEditor extends StatefulWidget {
  static const String routeName = "/edit";
  final Task task;

  TaskEditor({
    this.task,
  });

  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _durationHourController = TextEditingController();
  final TextEditingController _durationMinuteController =
      TextEditingController();
  Set<AttachFile> _attachFiles = Set();
  Set<AttachLink> _attachLinks = Set();
  DateTime _date;

  bool _showDatePicker = false;

  void _save(BuildContext context) {
    if (_formKey.currentState.validate()) {
      print("Valid");
      final userState = Provider.of<UserState>(context);
      var task;
      if (widget.task == null) {
        task = Task(
          key: UniqueKey(),
          title: _titleController.text,
          details: _detailsController.text,
          attachFiles: _attachFiles,
          attachLinks: _attachLinks,
          date: this._date,
        );
        userState.addTask(task);
      } else{
        print("show datepicker ${this._showDatePicker}");
        task = widget.task.copyWith(
          title: _titleController.text,
          details: _detailsController.text,
          attachFiles: _attachFiles,
          attachLinks: _attachLinks,
          date: this._showDatePicker ? this._date : null,
        );

        userState.updateTask(task);
    }
      

      // NotificationHelper.sendAlarmNotification(task);
      // FileHelper.writeToStorageAsync(listChangeNotifier.tasks);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task == null) {
      return;
    }
    _titleController.text = widget.task.title;
    _detailsController.text = widget.task.details;
    _attachFiles = widget.task.attachFiles;
    _attachLinks = widget.task.attachLinks;
    _date = widget.task.date;
    _showDatePicker = _date != null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _durationHourController.dispose();
    _durationMinuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.task != null ? "Edit Task" : "New Task",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: () {
              print("DONE");
              _save(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                BaseForm(
                  maxLength: 50,
                  maxLines: 1,
                  minLines: 1,
                  keyboardType: TextInputType.text,
                  hint: "title",
                  controller: _titleController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter Something";
                    }
                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
                SizedBox(
                  height: 15,
                ),
                BaseForm(
                  maxLength: null,
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  hint: "details",
                  controller: _detailsController,
                  validator: null,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
                SizedBox(
                  height: 15,
                ),
                addDate(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addDate(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: this._showDatePicker,
          onChanged: (bool checked) {
            setState(() {
              print("checked $checked");
              this._showDatePicker = checked;
            });
          },
        ),
        Expanded(
          child: RaisedButton(
            onPressed: this._showDatePicker
                ? () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true, onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() => this._date = date);
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  }
                : null,
            child: Center(
              child: Text(
                _datetext(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  String _datetext() {
    if (this._date == null || !this._showDatePicker) {
      return "DATE";
    }
    var eventDate = this._date;
    int day = eventDate.day;
    int month = eventDate.month;
    int year = eventDate.year;
    int hour = eventDate.hour;
    int minute = eventDate.minute;
    var text = "$day/$month/$year at $hour:$minute";
    return text;
  }

  Widget durationForm() {
    return Container(
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10), child: Text("Duration")),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: BaseForm(
                minLines: 1,
                maxLines: 1,
                maxLength: 2,
                keyboardType: TextInputType.number,
                controller: _durationHourController,
                hint: "HH",
                validator: null,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: BaseForm(
                maxLength: 2,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: _durationMinuteController,
                hint: "MM",
                validator: null,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BaseForm extends StatelessWidget {
  final TextEditingController _controller;
  final String _hint;
  final FormFieldValidator<String> _validator;
  final VoidCallback _onEditingComplete;
  final TextInputType _keyboardType;
  final int _maxLength;
  final int _maxLines;
  final int _minLines;

  BaseForm({
    @required int maxLength,
    @required int maxLines,
    @required int minLines,
    @required TextEditingController controller,
    @required String hint,
    @required FormFieldValidator validator,
    @required VoidCallback onEditingComplete,
    @required TextInputType keyboardType,
  })  : _maxLength = maxLength,
        _maxLines = maxLines,
        _minLines = minLines,
        _controller = controller,
        _hint = hint,
        _validator = validator,
        _onEditingComplete = onEditingComplete,
        _keyboardType = keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        style: Theme.of(context).textTheme.body1,
        maxLines: _maxLines,
        minLines: _minLines,
        maxLength: _maxLength,
        keyboardType: _keyboardType,
        textInputAction: TextInputAction.done,
        controller: _controller,
        validator: _validator,
        onEditingComplete: _onEditingComplete,
        decoration: InputDecoration(
          hintText: _hint,
        ),
      ),
    );
  }
}

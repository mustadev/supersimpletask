import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:supersimpletask/models/task.dart';

writeToStorageIsolate(List<Task> tasks) async {
  await FileHelper.writeToStorageAsync(tasks);
  print("writen ${tasks.length} tasks to storage");
}

Future<List<Task>> readTasksFromStorageIsolate(File file) async {
  var map = await FileHelper.readTasks(file);
  var taskList = TaskList.fromJson(map);
  return taskList.tasks;
}

Future<bool> verifyPassword(Map<String, String> credentials) async {
  // return Password.verify(
  //     credentials["password"], credentials["encryptedPassword"]);
  // print("using the new mothed");
  // var hashedPassword = Password.hash(credentials["password"], PBKDF2());
  // return hashedPassword == credentials["encryptedPassword"];
  // final key = enc.Key.fromUtf8("BAEEAwIICwcSDBEKAw8cBw4IIAEMHCETABYNGwcFERk=");
  // final iv = enc.IV.fromLength(16);

  // final encrypter = enc.Encrypter(enc.AES(key));
  // final encrypted = enc.Encrypted.fromBase16(credentials["encryptedPassword"]);
  // final decrypted = encrypter.decrypt(encrypted, iv: iv);
  // return decrypted == credentials["password"];


  return await encryptPassword(credentials["password"]) == credentials["encryptedPassword"];
  // return true;
  
}

Future<String> encryptPassword(String password) async {
  final bytes = utf8.encode(password);
   final base64Str = base64.encode(bytes);
   final rotted = FileHelper.rot13(base64Str);
  return rotted; 
}

class FileHelper {
  static const String FILENAME = "tasks.json";
  static const String PASSWORDFILENAME = "psfile";

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path + " path to store file");

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$FILENAME');
  }

  static Future<File> get _passwordFile async {
    final path = await _localPath;
    return File('$path/$PASSWORDFILENAME');
  }

  static Future<String> readPasswordFile() async {
    try {
      final file = await _passwordFile;
      if (!file.existsSync()) {
        file.createSync();
        print("File Created ${file.path}");
      }
      final content = file.readAsStringSync();
      return content.isEmpty ? "" : content;
    } catch (e) {
      // If encountering an error, return 0
      print("WARNING ERROR READING PASSWORD !!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print(e.toString());
      print("Returning empty map");
      return "ERROR";
    }
  }

  static Future<bool> hasPassword() async {
    String content = await readPasswordFile();
    // if (content.isEmpty) return false;
    // if (content == "ERROR")
    return content.isNotEmpty;
  }

  static Future<bool> isRealPassword(String password) async {
    print("checking password " + password);
    String encryptedPassword = await FileHelper.readPasswordFile();
    final credentials = {
      "password": password,
      "encryptedPassword": encryptedPassword
    };
    final isPassword = await compute(verifyPassword, credentials);
    print("finished checking");
    isPassword ? print("correct password") : print("incorrect password");
    return isPassword;
  }

  static writePassword(String password) async {
    final file = await _passwordFile;
    print("Writing password to ${file.path}");
    //var encryptedPassword = Password.hash(password, PBKDF2());
    var encryptedPassword = await compute(encryptPassword, password);
    print("finished encrypting the password");
    return file.writeAsString(encryptedPassword);
  }

  static Future<Map<String, dynamic>> readTasks(File file) async {
    if (!file.existsSync()) {
      file.createSync();
      print("File Created ${file.path}");
    }
    final content = file.readAsStringSync();
    //TODO Dectrypt before reading.
    if (content.isEmpty) {
      print("NO TASKS");
      return {};
    }
    return json.decode(content);
  }

  static Future<File> writeTasksJson(Map<String, dynamic> map) async {
    final file = await _localFile;
    print("Writing tasks to ${file.path}");
    //TODO Encrypt before writing.
    return file.writeAsString(json.encode(map));
  }

  static Future<File> writeToStorageAsync(List<Task> tasks) async {
    var taskList = TaskList(tasks: tasks);
    var map = TaskList.toJson(taskList);
    //print("write to storage $tasks");
    return await writeTasksJson(map);
  }

  static void writeToStorage(List<Task> tasks) async {
    //await writeToStorageAsync(tasks);
    return compute(writeToStorageIsolate, tasks);
  }

  static Future<List<Task>> readTasksFromStorage() async {
    try {
      final file = await _localFile;
      return compute(readTasksFromStorageIsolate, file);
    } catch (e) {
      // If encountering an error, return 0
      print(e.toString());
      print("Returning empty map");
      return [];
    }
  }

  static String rot13(String s){
        final a = "a".codeUnitAt(0);
        final z = a + 26;
        final A = "A".codeUnitAt(0);
        final Z = A + 26;
        final List<int> rotted = [];
        s.codeUnits.forEach((c){
                if ( c > z || c < A || c > Z && c < a){
                        rotted.add(c);
                }else{
                        if (c >= a + 13 || c >= A + 13 && c <= Z){
                                rotted.add(c -13);
                        }else {
                                rotted.add(c +13);
                        }
                }
        });
        return new String.fromCharCodes(rotted);
        
}

}
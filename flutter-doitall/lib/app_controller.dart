import 'package:flutter/cupertino.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDarkTheme = false;
  changeTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}

class Todo {
  final int status;
  final String message;

  Todo({required this.status, required this.message});

  factory Todo.fromJson(Map json) {
    return Todo(
      status: json['status'],
      message: json['message'],
    );
  }
}

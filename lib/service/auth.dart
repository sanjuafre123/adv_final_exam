import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AuthService {
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

const String tableTodo = 'todo';
const String columnId = '_id';
const String columnTitle = 'title';
const String columnDone = 'done';
const String columnAuthor = 'author';

class Todo {
  int? id;
  String? title, book;
  bool done = false;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class TodoProvider {
  Database? db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
CREATE TABLE $tableTodo ( 
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
  $columnTitle TEXT NOT NULL,
  $columnDone INTEGER NOT NULL,
  $columnAuthor TEXT NOT NULL)
''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db!.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Object> getTodo(int id) async {
    List maps = await db!.query(tableTodo,
        columns: [
          columnId,
          columnDone,
          columnTitle,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return [];
  }

  Future<int> delete(int id) async {
    return await db!.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db!.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db!.close();
}


class AuthServices {
  AuthServices._();

  static AuthServices userServices = AuthServices._();

  final _auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/views/todos_list_view.dart';

import 'helpers/database_helper.dart';
import 'screens/todos_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().database;
  runApp(const ProviderScope(child: MyApp()));
}

//My app to learn Riverpod's StateNotifierProvider

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodosListScreen(),
    );
  }
}

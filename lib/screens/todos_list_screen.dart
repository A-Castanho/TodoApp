import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/helpers/todos_service.dart';
import 'package:todos/views/todos_list_view.dart';

class TodosListScreen extends ConsumerWidget {
  const TodosListScreen({super.key});

  Future<String?> getNewTodo(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('TextField in Dialog'),
          content: TextField(
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: (() async {
              print("CLICK");
              final newTodo = await getNewTodo(context);
              print(newTodo);
              if (newTodo != null) {
                ref.read(todosProvider.notifier).addTodo(Todo(
                    id: UniqueKey().toString(),
                    description: newTodo,
                    completed: false));
              }
            }),
            icon: const Icon(Icons.add)),
      ]),
      body: FutureBuilder(
        future: ref.read(todosProvider.notifier).setTodosFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const TodosListView();
          }
        },
      ),
    );
  }
}

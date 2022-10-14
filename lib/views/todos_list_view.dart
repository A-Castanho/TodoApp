import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../helpers/todos_service.dart';

class TodosListView extends ConsumerWidget {
  const TodosListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild the widget when the todo list changes
    List<Todo> todos = ref.watch(todosProvider);

    // Let's render the todos in a scrollable list view
    return ListView(
      children: [
        for (final todo in todos)
          GestureDetector(
            onLongPress: () =>
                ref.read(todosProvider.notifier).removeTodo(todo.id),
            child: CheckboxListTile(
              value: todo.completed,
              // When tapping on the todo, change its completed status
              onChanged: (value) =>
                  ref.read(todosProvider.notifier).toggle(todo.id),
              title: Text(todo.description),
            ),
          ),
      ],
    );
  }
}

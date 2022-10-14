import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/helpers/database_helper.dart';

import '../models/todo.dart';

// The StateNotifier class that will be passed to our StateNotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.

class TodosNotifier extends StateNotifier<List<Todo>> {
  final dbHelper = DBHelper();
  // We initialize the list of todos to an empty list
  TodosNotifier() : super([]);

  Future<void> setTodosFromDatabase() async {
    final dbRows = await dbHelper.queryAllRows();
    final todosList = dbRows
        .map((e) => Todo(
            id: e['id'],
            description: e['description'],
            completed: (e['completed'] as int) == 1))
        .toList();
    state = todosList;
  }

  // Let's allow the UI to add todos.
  void addTodo(Todo todo) async {
    final originalState = state;
    // Since our state is immutable, we are not allowed to do `state.add(todo)`.
    // Instead, we should create a new list of todos which contains the previous
    // items and the new one.
    // Using Dart's spread operator here is helpful!
    state = [...state, todo];

    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.

    try {
      dbHelper.insertTodo(todo);
    } catch (e) {
      //Using optimistic updates:
      state = originalState;
      rethrow;
    }
  }

  // Let's allow removing todos
  void removeTodo(String todoId) {
    final originalState = state;
    // Again, our state is immutable. So we're making a new list instead of
    // changing the existing list.
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];

    try {
      dbHelper.delete(todoId);
    } catch (e) {
      //Using optimistic updates:
      state = originalState;
      rethrow;
    }
  }

  void toggle(String todoId) {
    final originalState = state;
    state = [
      for (final todo in state)
        if (todo.id == todoId)
          // since our state is immutable, we need to make a copy of the todo.
          // We're using our `copyWith` method implemented before to help with that.
          todo.copyWith(completed: !todo.completed)
        else
          // other todos are not modified
          todo,
    ];

    try {
      dbHelper.update(
          todoId, state.singleWhere((element) => element.id == todoId));
    } catch (e) {
      //Using optimistic updates:
      state = originalState;
      rethrow;
    }
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

import 'package:flutter/material.dart';

// The state of our StateNotifier should be immutable.
// We could also use packages like Freezed to help with the implementation.

@immutable
class Todo {
  // All properties should be `final` on our class.
  final String id;
  final String description;
  final bool completed;

  const Todo(
      {required this.id, required this.description, required this.completed});

  // Since Todo is immutable, we implement a method that allows cloning the
  // Todo with slightly different content.
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }

  Map<String, Object> toMap() {
    return {
      'id': this.id,
      'description': this.description,
      'completed': this.completed ? 1 : 0,
    };
  }
}

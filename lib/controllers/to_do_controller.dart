import 'package:get/get.dart';

import '../database/database_helper.dart';

class TodoController extends GetxController {
  var todos = <Map<String, dynamic>>[].obs;
  var filteredTodos = <Map<String, dynamic>>[].obs;
  var selectedPriority = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  void fetchTodos() async {
    var result = await DatabaseHelper().getTodos();
    if (result != null) {
      todos.value = result;
      filterTodosByPriority(selectedPriority.value);
    }
  }

  void addTodo(Map<String, dynamic> todo) async {
    await DatabaseHelper().insertTodo(todo);
    fetchTodos();
  }

  void updateTodo(Map<String, dynamic> todo, int id) async {
    await DatabaseHelper().updateTodo(todo, id);
    fetchTodos();
  }

  void deleteTodo(int id) async {
    await DatabaseHelper().deleteTodo(id);
    fetchTodos();
  }

  void searchTodos(String query) {
    if (query.isEmpty) {
      filteredTodos.assignAll(todos);
    } else {
      filteredTodos.assignAll(
        todos.where((todo) =>
            todo['title'].toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  void filterTodosByPriority(String priority) {
    if (priority == 'All' || priority.isEmpty) {
      filteredTodos.assignAll(todos);
    } else {
      filteredTodos.assignAll(
        todos.where((todo) => todo['priority'] == priority).toList(),
      );
    }
  }

}
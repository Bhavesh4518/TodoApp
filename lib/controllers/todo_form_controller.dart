import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoo/controllers/to_do_controller.dart';

// For adding and updating Todos

class TodoFormController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  var selectedDate = Rxn<DateTime>();
  var selectedPriority = 'Medium'.obs;

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void addTodo() {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a title');
      return;
    }

    var newTodo = {
      'title': titleController.text,
      'description': descriptionController.text,
      'dueDate': selectedDate.value?.toIso8601String() ?? '',
      'priority': selectedPriority.value,
    };

    Get.find<TodoController>().addTodo(newTodo);
    Get.back();
  }

  void updateTodo(int id) {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a title');
      return;
    }

    var updatedTodo = {
      'title': titleController.text,
      'description': descriptionController.text,
      'dueDate': selectedDate.value?.toIso8601String() ?? '',
      'priority': selectedPriority.value,
    };

    Get.find<TodoController>().updateTodo(updatedTodo, id);
    Get.back();
  }

  void clearForm(){
    titleController.text = '';
    descriptionController.text = '';
    selectedDate.value = null;
    selectedPriority.value = 'Medium';
  }

}

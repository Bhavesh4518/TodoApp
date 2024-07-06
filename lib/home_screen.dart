import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoo/common/widgets/detailed_todo.dart';
import 'package:todoo/common/widgets/todo_container.dart';
import 'package:todoo/controllers/to_do_controller.dart';
import 'controllers/todo_form_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showTodoBottomSheet(BuildContext context, {Map<String, dynamic>? todo}) {
    final TodoFormController formController = Get.put(TodoFormController());
    if (todo == null) {
      formController.clearForm();
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddTodos(todo: todo,);
      },
    );
  }
  void showDetailedTodoBottomSheet(BuildContext context, {required Map<String, dynamic> todo}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DetailedTodo(todo: todo);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TodoController());
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showTodoBottomSheet(context);
        },
        shape: const CircleBorder(),
        elevation: 2,
        backgroundColor: Colors.cyan.shade300,
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 1.2), // Increase the height as needed
        child: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0), // Add space from the top and sides
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32.0), // Add space from the top within the column
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search...',
                      fillColor: Colors.cyan.shade50,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0), // Adjust vertical padding
                    ),
                    onChanged: (value) {
                      controller.searchTodos(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ToDos',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.cyan),),
                  Obx(
                      () => DropdownButton<String>(
                        dropdownColor: Colors.cyan.shade50,
                      hint: const Text('Priority'),
                      value: controller.selectedPriority.value.isEmpty
                          ? 'All'
                          : controller.selectedPriority.value,
                      onChanged: (value) {
                        controller.selectedPriority.value = value!;
                        controller.filterTodosByPriority(value);
                      },
                      items: <String>['All' , 'High', 'Medium', 'Low']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Obx(() {
                if (controller.todos.isEmpty) {
                  return const Center(
                    child: Text('Wait, You don\'t have anything to do !',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = controller.filteredTodos[index];
                    return GestureDetector(
                      onTap: () => showDetailedTodoBottomSheet(context, todo: todo),
                      child: ToDoContainer(
                          todo: todo,
                          title: todo['title'],
                          des: todo['description'],
                          onDelete: () =>  controller.deleteTodo(todo['id']),
                          onEdit: () =>  showTodoBottomSheet(context, todo: todo),
                      ),
                    );
                  }, separatorBuilder: (_ ,__) => const SizedBox(height: 8,),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTodos extends StatelessWidget {
  final Map<String, dynamic>? todo;

  const AddTodos({super.key, this.todo});

  @override
  Widget build(BuildContext context) {
    final TodoFormController formController = Get.put(TodoFormController());

    if (todo != null) {
      formController.titleController.text = todo!['title'];
      formController.descriptionController.text = todo!['description'];
      formController.selectedDate.value = DateTime.tryParse(todo!['dueDate']);
      formController.selectedPriority.value = todo!['priority'];
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.shade50 , Colors.cyan.shade100],
        )
      ),
      padding: const EdgeInsets.fromLTRB(18, kToolbarHeight * 1.2 , 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                todo == null ? 'Add Your Todo' : 'Edit Your Todo',
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 12,),
          TextFormField(
            controller: formController.titleController,
            decoration: const InputDecoration(
                hintText: 'Title',
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 9,),
          TextFormField(
            controller: formController.descriptionController,
            decoration: const InputDecoration(
                hintText: 'Description',
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12,),
          Obx(() {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan.shade300,
                  side: BorderSide(color: Colors.cyan.shade300),
                padding: EdgeInsets.symmetric(horizontal: 24)
              ),
              onPressed: () => formController.pickDate(context),
              child: Text(formController.selectedDate.value == null
                  ? 'Pick a Date'
                  : DateFormat.yMd().format(formController.selectedDate.value!)),
            );
          }),
          Obx(() {
            return SizedBox(
              width: 130,
              child: DropdownButton<String>(
                isExpanded: true,
                padding: const EdgeInsets.all(4),
                value: formController.selectedPriority.value,
                onChanged: (newValue) {
                  formController.selectedPriority.value = newValue!;
                },
                items: <String>['High', 'Medium', 'Low']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            );
          }),
          const SizedBox(height: 24,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed : () {
                  if (todo == null) {
                    formController.addTodo();
                  } else {
                    formController.updateTodo(todo!['id']);
                  }
                  formController.clearForm();
                }, child: Text(todo == null ? 'Add Todo' : 'Update Todo')),
          )
        ],
      ),
    );
  }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/to_do_controller.dart';
import '../../home_screen.dart';

class DetailedTodo extends StatelessWidget {
  const DetailedTodo({super.key, required this.todo});

  final Map<String, dynamic> todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.cyan.shade50 , Colors.cyan.shade100]
          ),
          borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todo['title'],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                const SizedBox(height: 8,),
                Text(todo['description'],style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold ,color: Colors.blueGrey)),
                const SizedBox(height: 24,),
                const Text('Due Date: ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold ,color: Colors.grey)),
                Text('${todo['dueDate']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,color: Colors.blueGrey)),
                const SizedBox(height: 24,),
                const Text('Priority: ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold ,color: Colors.grey)),
                Text('${todo['priority']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,color: Colors.blueGrey))
              ],
            ),
          ),
          const SizedBox(width: 8,),
          IconButton( onPressed: (){
            Get.put(HomeScreen());
            Navigator.pop(context);
            Get.find<HomeScreen>().showTodoBottomSheet(context, todo: todo);
          }, icon: const Icon(Icons.edit)),
          IconButton( onPressed: (){
            Navigator.pop(context);
            Get.find<TodoController>().deleteTodo(todo['id']);
          }, icon: const Icon(Icons.delete_outline)),
        ],
      ),
    );
  }
}

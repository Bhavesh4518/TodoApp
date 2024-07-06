import 'package:flutter/material.dart';

class ToDoContainer extends StatelessWidget {
  const ToDoContainer({super.key, required this.title, required this.des, this.date, required this.onDelete, required this.onEdit, required this.todo});

  final String title;
  final String des;
  final String? date;
  final void Function() onDelete;
  final void Function() onEdit;
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,),
                const SizedBox(height: 4,),
                Text(des,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold ,color: Colors.grey),maxLines: 2,overflow: TextOverflow.ellipsis,)
              ],
            ),
          ),
          const SizedBox(width: 12,),
          IconButton( onPressed: onEdit, icon: const Icon(Icons.edit)),
          IconButton( onPressed: onDelete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
    );
  }
}

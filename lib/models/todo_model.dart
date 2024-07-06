class Todo {
  int? id;
  String title;
  String description;
  String dueDate;
  int priority;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
    };
  }
}

enum TaskStatus { newTask, inProgress, completed }

class Task {
  String title;
  String description;
  TaskStatus status;
  String? imageUrl; //добавляем картинку для 5 задач онли

  Task({
    required this.title,
    required this.description,
    this.status = TaskStatus.newTask,
    this.imageUrl,
  });
}

String statusToString(TaskStatus status) {
  switch (status) {
    case TaskStatus.newTask:
      return 'Новая';
    case TaskStatus.inProgress:
      return 'В работе';
    case TaskStatus.completed:
      return 'Завершена';
  }
}

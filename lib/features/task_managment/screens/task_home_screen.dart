import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_list_screen.dart';
import 'task_create_screen.dart';

class TaskHomeScreen extends StatefulWidget {
  @override
  _TaskHomeScreenState createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  List<Task> _tasks = [];
  int _selectedIndex = 0;

  final List<String> _titles = ['Все задачи', 'Новые', 'В работе', 'Завершенные',];

  void _onItemTapped(int index) {
    setState(() {_selectedIndex = index;});
  }

  void _addTask(Task task) {
    setState(() {_tasks.add(task);});
  }

  List<Task> _filteredTasks() {
    if (_selectedIndex == 0) {return _tasks;}
    TaskStatus status = TaskStatus.newTask;
    if (_selectedIndex == 1) status = TaskStatus.newTask;
    if (_selectedIndex == 2) status = TaskStatus.inProgress;
    if (_selectedIndex == 3) status = TaskStatus.completed;
    return _tasks.where((task) => task.status == status).toList();
  }

  void _updateTaskStatus(int index, TaskStatus status) {
    setState(() {_tasks[index].status = status;});
  }

  void _deleteTask(int index) {
    setState(() {_tasks.removeAt(index);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: TaskListScreen(
        tasks: _filteredTasks(),
        onStatusChange: (task, newStatus) {
          int taskIndex = _tasks.indexOf(task);
          if (taskIndex != -1) {
            _updateTaskStatus(taskIndex, newStatus);
          }
        },
        onDelete: (task) {
          int taskIndex = _tasks.indexOf(task);
          if (taskIndex != -1) {
            _deleteTask(taskIndex);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Все',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_new),
            label: 'Новые',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'В работе',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Завершено',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (context) => TaskCreateScreen()),
          );

          if (newTask != null) {
            _addTask(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

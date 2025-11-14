import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_list_screen.dart';
import 'task_create_screen.dart';

class TaskHomeScreen extends StatefulWidget {
  final List<Task>? initialTasks;
  final int? initialIndex;

  TaskHomeScreen({this.initialTasks, this.initialIndex});

  @override
  _TaskHomeScreenState createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  late List<Task> _tasks;
  late int _selectedIndex;

  final List<String> _titles = [
    'Все задачи',
    'Новые',
    'В работе',
    'Завершенные',
  ];

  @override
  void initState() {
    super.initState();
    _tasks = widget.initialTasks ?? [];
    _selectedIndex = widget.initialIndex ?? 0;
  }

  // Вертикальная навигация — переход на создание задачи (push)
  void _navigateToCreateTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskCreateScreen(),
      ),
    );

    if (result != null && result is Task) {
      setState(() {
        _tasks.add(result);
      });
    }
  }

  // Горизонтальная навигация — переключение фильтров
  void _onFilterChanged(int index) {
    if (_selectedIndex != index) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskHomeScreen(
            initialTasks: _tasks,
            initialIndex: index,
          ),
        ),
      );
    }
  }

  // Фильтрация задач по статусу
  List<Task> _filteredTasks() {
    if (_selectedIndex == 0) {
      return _tasks;
    }

    TaskStatus? status;
    if (_selectedIndex == 1) status = TaskStatus.newTask;
    if (_selectedIndex == 2) status = TaskStatus.inProgress;
    if (_selectedIndex == 3) status = TaskStatus.completed;

    return _tasks.where((task) => task.status == status).toList();
  }

  void _updateTaskStatus(Task task, TaskStatus status) {
    setState(() {
      task.status = status;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      // Drawer для горизонтальной навигации между фильтрами
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.task_alt, size: 48, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Task Tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Все задачи'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pop(context);
                _onFilterChanged(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.new_label),
              title: Text('Новые'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pop(context);
                _onFilterChanged(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('В работе'),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.pop(context);
                _onFilterChanged(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Завершенные'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.pop(context);
                _onFilterChanged(3);
              },
            ),
          ],
        ),
      ),
      body: filteredTasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Задачи не найдены',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : TaskListScreen(
        tasks: filteredTasks,
        onStatusChange: _updateTaskStatus,
        onDelete: _deleteTask,
      ),
      // Вертикальная навигация — кнопка для создания задачи
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateTask,
        child: Icon(Icons.add),
        tooltip: 'Создать задачу',
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCreateScreen extends StatefulWidget {
  @override
  _TaskCreateScreenState createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  TaskStatus _status = TaskStatus.newTask;
  String? _imageUrl;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTask = Task(
        title: _title,
        description: _description,
        status: _status,
        imageUrl: _imageUrl,
      );

      // Вертикальный навигационный возврат (pop)
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать задачу'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название задачи';
                  }
                  return null;
                },
                onSaved: (value) => _title = value ?? '',
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: 'Описание'),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ссылка на изображение'),
                onSaved: (value) => _imageUrl = value,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: InputDecoration(labelText: 'Статус'),
                items: TaskStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(statusToString(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value ?? TaskStatus.newTask;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('Создать'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Provider/task_provider.dart';
import 'bin_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BinScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return const Center(child: Text('No tasks available'));
          } else {
            return ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    final removedTask = task;
                    final removedIndex = index;
                    taskProvider.removeTask(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${task.title} dismissed'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            taskProvider.undoRemoveTask(removedTask, removedIndex);
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (value) {
                        taskProvider.toggleTaskStatus(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${task.title} completed'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    title: Text(task.title),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Start Date: ${task.startDate.toLocal().toString().split(' ')[0]}'),
                        Text('End Date: ${task.endDate.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        String newTaskTitle = '';
        DateTime selectedEndDate = DateTime.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      newTaskTitle = value;
                    },
                    decoration: const InputDecoration(labelText: 'Task Title'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedEndDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedEndDate) {
                        setState(() {
                          selectedEndDate = picked;
                        });
                      }
                    },
                    child: const Text('Select End Date'),
                  ),
                  Text('Selected date: ${selectedEndDate.toLocal().toString().split(' ')[0]}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (newTaskTitle.isNotEmpty) {
                      taskProvider.addTask(newTaskTitle, selectedEndDate);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Provider/task_provider.dart';

class BinScreen extends StatelessWidget {
  const BinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deleted Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).clearDeletedTasks();
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.deletedTasks.isEmpty) {
            return const Center(child: Text('No deleted tasks'));
          } else {
            return ListView.builder(
              itemCount: taskProvider.deletedTasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.deletedTasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('End Date: ${task.endDate.toLocal().toString().split(' ')[0]}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

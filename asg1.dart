import 'dart:convert';
import 'dart:io';

class Task {
  String title;
  String description;
  bool isCompleted;

  Task({required this.title, required this.description, this.isCompleted = false});

  @override
  String toString() {
    return 'Title: $title, Description: $description, Completed: $isCompleted';
  }
}

class TaskManager {
  List<Task> tasks = [];

  // Task operations
  void addTask(Task task) {
    tasks.add(task);
    print("Task added: ${task.title}");
  }

  void updateTask(int index, Task task) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = task;
      print("Task updated at index $index.");
    } else {
      print("Invalid index.");
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      print("Task deleted at index $index.");
    } else {
      print("Invalid index.");
    }
  }

  List<Task> getTasks() => tasks;
  List<Task> getCompletedTasks() => tasks.where((task) => task.isCompleted).toList();
  List<Task> getIncompleteTasks() => tasks.where((task) => !task.isCompleted).toList();

  void toggleTaskCompletion(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      print("Task completion toggled at index $index.");
    } else {
      print("Invalid index.");
    }
  }

  void saveTasksToFile(String fileName) {
    final file = File(fileName);
    final taskJson = tasks.map((task) => {
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted
    }).toList();
    file.writeAsStringSync(jsonEncode(taskJson));
    print("Tasks saved to $fileName.");
  }

  void loadTasksFromFile(String fileName) {
    final file = File(fileName);
    if (file.existsSync()) {
      final jsonData = jsonDecode(file.readAsStringSync()) as List;
      tasks = jsonData.map((taskData) => Task(
        title: taskData['title'],
        description: taskData['description'],
        isCompleted: taskData['isCompleted']
      )).toList();
      print("Tasks loaded from $fileName.");
    } else {
      print("File not found.");
    }
  }

  List<Task> searchTasks(String title) {
    return tasks.where((task) => task.title.contains(title)).toList();
  }
}

void showMenu() {
  print("\nTask Manager Menu:");
  print("1. Add a new task");
  print("2. Update a task");
  print("3. Delete a task");
  print("4. List all tasks");
  print("5. List completed tasks");
  print("6. List incomplete tasks");
  print("7. Toggle task completion");
  print("8. Search tasks by title");
  print("9. Exit");
}

void handleUserInput(TaskManager manager) {
  while (true) {
    showMenu();
    print("Enter an option:");
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        print("Enter task title:");
        String title = stdin.readLineSync()!;
        print("Enter task description:");
        String description = stdin.readLineSync()!;
        manager.addTask(Task(title: title, description: description));
        break;
      case '2':
        print("Enter task index to update:");
        int index = int.parse(stdin.readLineSync()!);
        print("Enter new task title:");
        String title = stdin.readLineSync()!;
        print("Enter new task description:");
        String description = stdin.readLineSync()!;
        manager.updateTask(index, Task(title: title, description: description));
        break;
      case '3':
        print("Enter task index to delete:");
        int index = int.parse(stdin.readLineSync()!);
        manager.deleteTask(index);
        break;
      case '4':
        manager.getTasks().forEach((task) => print(task));
        break;
      case '5':
        manager.getCompletedTasks().forEach((task) => print(task));
        break;
      case '6':
        manager.getIncompleteTasks().forEach((task) => print(task));
        break;
      case '7':
        print("Enter task index to toggle completion:");
        int index = int.parse(stdin.readLineSync()!);
        manager.toggleTaskCompletion(index);
        break;
      case '8':
        print("Enter title to search:");
        String title = stdin.readLineSync()!;
        manager.searchTasks(title).forEach((task) => print(task));
        break;
      case '9':
        print("Exiting...");
        manager.saveTasksToFile('tasks.json');
        return;
      default:
        print("Invalid option. Try again.");
    }
  }
}

void main() {
  TaskManager manager = TaskManager();
  manager.loadTasksFromFile('tasks.json');
  handleUserInput(manager);
}

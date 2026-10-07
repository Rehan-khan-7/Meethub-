class TaskRepository {
  static const bool useBackend = false;

  static final List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> getTasks() {
    return _tasks;
  }

  void addTask(Map<String, dynamic> task) {
    _tasks.add(task);
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking_app/data/model/task.dart';

class TaskRepository {
  static TaskRepository instance = TaskRepository._init();

  factory TaskRepository() {
    return instance;
  }

  TaskRepository._init();

  final _collection = FirebaseFirestore.instance.collection("tasks");

  Stream<List<Task>> getTasksStream() {
    return _collection.snapshots().map((event) => event.docs
        .map((doc) => Task.fromMap(doc.data()).copy(id: doc.id))
        .toList());
  }

  Future<List<Task>> getAllTasks() async {
    final res = await _collection.get();
    final List<Task> tasks = [];

    for (var doc in res.docs) {
      final Task task = Task.fromMap(doc.data()).copy(id: doc.id);
      tasks.add(task);
    }

    return tasks;
  }

  Future<Task?> getTaskById(String id) async {
    final res = await _collection.doc(id).get();
    if (res.data() == null) {
      return null;
    }

    return Task.fromMap(res.data()!).copy(id: res.id);
  }

  Future<void> addTask(Task task) async {
    await _collection.add(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await _collection.doc(task.id!).set(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _collection.doc(id).delete();
  }

  Future<String> greet() {
    Future.delayed(const Duration(seconds: 2));
    return Future.value("Hello Future");
  }
}

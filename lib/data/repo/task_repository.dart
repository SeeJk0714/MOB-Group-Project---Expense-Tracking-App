import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking_app/data/model/task.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskRepository {
  static TaskRepository instance = TaskRepository._init();

  factory TaskRepository() {
    return instance;
  }

  TaskRepository._init();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference getCollection() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User ID doesn't exist");
    }
    return _firestore.collection('root_db/${user.uid}/tasks');
  }

  Stream<List<Task>> getTasksStream() {
    return getCollection().snapshots().map((event) => event.docs
        .map((doc) =>
            Task.fromMap(doc.data() as Map<String, dynamic>).copy(id: doc.id))
        .toList());
  }

  Future<List<Task>> getAllTasks() async {
    final res = await getCollection().get();
    final List<Task> tasks = [];

    for (var doc in res.docs) {
      final Task task =
          Task.fromMap(doc.data() as Map<String, dynamic>).copy(id: doc.id);
      tasks.add(task);
    }

    return tasks;
  }

  Future<Task?> getTaskById(String id) async {
    final res = await getCollection().doc(id).get();
    if (res.data() == null) {
      return null;
    }

    return Task.fromMap(res.data() as Map<String, dynamic>).copy(id: res.id);
  }

  Future<void> addTask(Task task) async {
    await getCollection().add(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await getCollection().doc(task.id!).set(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await getCollection().doc(id).delete();
  }

  Future<String> greet() {
    Future.delayed(const Duration(seconds: 2));
    return Future.value("Hello Future");
  }
}

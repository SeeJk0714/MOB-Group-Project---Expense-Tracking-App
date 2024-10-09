import 'package:expense_tracking_app/data/model/task.dart';
import 'package:expense_tracking_app/data/repo/user_repository.dart';
import 'package:expense_tracking_app/screens/detail_screen.dart';
import 'package:expense_tracking_app/nav/navigation.dart';
import 'package:expense_tracking_app/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracking_app/data/model/user.dart'
    as app_model; // Use an alias for your custom User class
import 'package:firebase_auth/firebase_auth.dart'
    as firebase_auth; // Use an alias for the FirebaseAuth User class

import '../data/repo/task_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserRepository _userrepository = UserRepository();
  // ignore: unused_field
  app_model.User? _currentUser;
  String? _profileImageUrl;

  double todayBalance = 0; // Today's balance
  double previousDayBalance = 0; // Previous day's balance
  double totalIncomeToday = 0; // Total income for today
  double totalExpensesToday = 0; // Total expenses for today
  double totalIncomePreviousDay = 0; // Total income for the previous day
  double totalExpensesPreviousDay = 0; // Total expenses for the previous day

  double totalIncome = 0; // Total income for all tasks
  double totalExpenses = 0; // Total expenses for all tasks
  double totalBalance = 0; // Total balance based on all tasks

  List<Task> tasks = [];
  List<Task> todayTasks = [];
  List<Task> previousDayTasks = [];

  // Calculate the total income for a list of tasks
  double calculateTotalIncome(List<Task> tasks) {
    return tasks
        .where((task) => task.status.toLowerCase() == 'income')
        .fold(0.0, (sum, task) => sum + task.amount);
  }

  // Calculate the total expenses for a list of tasks
  double calculateTotalExpenses(List<Task> tasks) {
    return tasks
        .where((task) => task.status.toLowerCase() != 'income')
        .fold(0.0, (sum, task) => sum + task.amount);
  }

  List<Task> _filterTasksForCurrentDay(List<Task> tasks) {
    final DateTime now = DateTime.now();
    return tasks.where((task) {
      final taskDate = task.date;
      return taskDate.year == now.year &&
          taskDate.month == now.month &&
          taskDate.day == now.day;
    }).toList();
  }

  List<Task> _filterTasksForPreviousDay(List<Task> tasks) {
    final DateTime now = DateTime.now();
    final DateTime previousDay = now.subtract(const Duration(days: 1));
    return tasks.where((task) {
      final taskDate = task.date;
      return taskDate.year == previousDay.year &&
          taskDate.month == previousDay.month &&
          taskDate.day == previousDay.day;
    }).toList();
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.fastfood;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_cart;
      case 'salary':
        return Icons.attach_money;
      case 'bonus':
        return Icons.card_giftcard;
      case 'financial income':
        return Icons.trending_up_outlined;
      default:
        return Icons.more_horiz;
    }
  }

  // Click this go to edit page
  void _navigateToEdit(String id) async {
    await context.pushNamed(Screen.edit.name,
        pathParameters: {"id": id} // Indicate return to home
        );
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      final userId = firebaseUser.uid;

      // Use your app's custom User class to get the user details
      final user = await _userrepository.getUserById(userId);

      setState(() {
        _currentUser = user;
        _profileImageUrl = user?.profileImageUrl;
      });
    }
  }

  Widget buildExpenseItem(String title, String subtitle, String amount,
      IconData icon, String status,
      {VoidCallback? onTap}) {
    final backgroundColor = status.trim().toLowerCase() == 'income'
        ? const Color(0xffCAA6A6)
        : const Color(0xfff8d7da);

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 16), // Adjusted padding
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16), // Adjusted padding inside ListTile
            leading: Icon(icon, size: 30, color: Colors.black),
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(subtitle),
            trailing: Text(
              'RM $amount',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList(
      List<Task> tasks, String title, double balance, String date) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0), // Adjusted padding for entire list block
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tasks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            if (tasks.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal:
                        16), // Adjusted padding for Net Balance container
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Balance:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "RM ${balance.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: balance >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            if (tasks.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return buildExpenseItem(
                    task.note,
                    task.account,
                    task.amount.toStringAsFixed(2),
                    _getIconForCategory(task.category),
                    task.status,
                    onTap: () {
                      _navigateToEdit(task.id!);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String userId = 'someUserId';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            // Navigate to profile screen or show profile options
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserProfileScreen(userId: userId),
              ),
            );
          },
          child: Column(
            children: [
              if (_profileImageUrl != null &&
                  _profileImageUrl!.startsWith('http'))
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(_profileImageUrl!),
                )
              else
                const CircleAvatar(
                  radius: 20,
                  child: Icon(
                    Icons.person_2,
                    color: Colors.black,
                    size: 35.0,
                  ),
                ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<Task>>(
        stream: TaskRepository.instance.getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Firestore error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses or income available'));
          }

          tasks = snapshot.data!;

          // Filter tasks for today and previous day
          todayTasks = _filterTasksForCurrentDay(tasks);
          previousDayTasks = _filterTasksForPreviousDay(tasks);

          // Calculate income and expenses for today
          totalIncomeToday = calculateTotalIncome(todayTasks);
          totalExpensesToday = calculateTotalExpenses(todayTasks);
          todayBalance = totalIncomeToday - totalExpensesToday;

          // Calculate income and expenses for previous day
          totalIncomePreviousDay = calculateTotalIncome(previousDayTasks);
          totalExpensesPreviousDay = calculateTotalExpenses(previousDayTasks);
          previousDayBalance =
              totalIncomePreviousDay - totalExpensesPreviousDay;

          // Calculate total income, expenses, and balance for all tasks
          totalIncome =
              calculateTotalIncome(tasks); // Total income from all tasks
          totalExpenses =
              calculateTotalExpenses(tasks); // Total expenses from all tasks
          totalBalance = totalIncome - totalExpenses; // Total balance

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20),
                  child: Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      tasks: tasks,
                                      totalBalance: totalBalance)));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xffb5838d),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Total Saving:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                'RM ${totalBalance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),

              // Display today's tasks
              _buildTasksList(
                todayTasks,
                'Today\'s Tasks',
                todayBalance,
                DateFormat.yMMMMd().format(DateTime.now()),
              ),

              // Display previous day's tasks if today's tasks are less than 3
              if (todayTasks.length < 6)
                _buildTasksList(
                  previousDayTasks,
                  'Previous Day\'s Tasks',
                  previousDayBalance,
                  DateFormat.yMMMMd()
                      .format(DateTime.now().subtract(const Duration(days: 1))),
                ),
            ],
          );
        },
      ),
    );
  }
}

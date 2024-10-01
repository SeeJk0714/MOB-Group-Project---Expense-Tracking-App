import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/model/task.dart'; // Import Task model

class DetailScreen extends StatefulWidget {
  final List<Task> tasks; // Pass the list of tasks
  final double totalBalance;

  const DetailScreen(
      {super.key, required this.tasks, required this.totalBalance});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Helper function to group tasks by date
  Map<String, List<Task>> _groupTasksByDate(List<Task> tasks) {
    Map<String, List<Task>> groupedTasks = {};

    for (var task in tasks) {
      String formattedDate =
          DateFormat.yMMMMd().format(task.date); // Format the date
      if (groupedTasks.containsKey(formattedDate)) {
        groupedTasks[formattedDate]!.add(task);
      } else {
        groupedTasks[formattedDate] = [task];
      }
    }
    return groupedTasks;
  }

  // Helper function to get icon based on category
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
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group tasks by date
    final groupedTasks = _groupTasksByDate(widget.tasks);

    // Sort dates in descending order
    List<String> sortedDates = groupedTasks.keys.toList()
      ..sort((a, b) =>
          DateFormat.yMMMMd().parse(b).compareTo(DateFormat.yMMMMd().parse(a)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  String date = sortedDates[index]; // Use sorted dates
                  List<Task> tasksForDate = groupedTasks[date]!;

                  // Calculate balance for the day
                  double income = tasksForDate
                      .where((task) => task.status.toLowerCase() == 'income')
                      .fold(0.0, (sum, task) => sum + task.amount);
                  double expenses = tasksForDate
                      .where((task) => task.status.toLowerCase() != 'income')
                      .fold(0.0, (sum, task) => sum + task.amount);
                  double balance = income - expenses;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tasksForDate.length,
                              itemBuilder: (context, index) {
                                final task = tasksForDate[index];

                                // Determine the background color based on the task status
                                final backgroundColor =
                                    task.status.trim().toLowerCase() == 'income'
                                        ? const Color(0xffCAA6A6)
                                        : const Color(0xfff8d7da);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            backgroundColor, // Apply the background color here
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ListTile(
                                      leading: Icon(
                                          _getIconForCategory(task.category)),
                                      title: Text(task.category),
                                      subtitle: Text(
                                          'RM ${task.amount.toStringAsFixed(2)} - ${task.status}'),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "BALANCE:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "RM ${balance.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: balance >= 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

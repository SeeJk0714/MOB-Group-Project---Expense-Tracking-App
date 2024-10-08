import 'package:expense_tracking_app/nav/navigation.dart';
import 'package:expense_tracking_app/screens/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  DateTime selectedDate = DateTime.now(); // Initialize with the current date

  // Helper function to group tasks by date
  Map<String, List<Task>> _groupTasksByDate(List<Task> tasks) {
    Map<String, List<Task>> groupedTasks = {};

    for (var task in tasks) {
      String formattedDate = DateFormat.yMMMMd().format(task.date);
      if (groupedTasks.containsKey(formattedDate)) {
        groupedTasks[formattedDate]!.add(task);
      } else {
        groupedTasks[formattedDate] = [task];
      }
    }
    return groupedTasks;
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate; // Update the selected date
    });
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
        return Icons.more_horiz;
    }
  }

  // Click this go to edit page
  void _navigateToEdit(String id) async {
    await context.pushNamed(
      Screen.edit.name,
      pathParameters: {"id": id},
    );
  }

  Widget _buildNoDataMessage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300.0,
          ),
          Icon(
            Icons.hourglass_empty_outlined,
            size: 50.0,
          ),
          Text(
            "No data avalible",
            style: TextStyle(fontSize: 30.0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter tasks by the selected month and year
    final filteredTasks = widget.tasks.where((task) {
      final taskDate = task.date;
      return taskDate.year == selectedDate.year &&
          taskDate.month == selectedDate.month;
    }).toList();

    final groupedTasks = _groupTasksByDate(filteredTasks);

    // Sort dates in descending order
    List<String> sortedDates = groupedTasks.keys.toList()
      ..sort((a, b) =>
          DateFormat.yMMMMd().parse(b).compareTo(DateFormat.yMMMMd().parse(a)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            MonthYearPicker(
              selectedDate: selectedDate,
              onDateChanged: _onDateChanged,
            ),
            const SizedBox(height: 20),
            sortedDates.isEmpty
                ? _buildNoDataMessage()
                : Expanded(
                    child: ListView.builder(
                      itemCount: sortedDates.length,
                      itemBuilder: (context, index) {
                        String date = sortedDates[index];
                        List<Task> tasksForDate = groupedTasks[date]!;

                        double income = tasksForDate
                            .where(
                                (task) => task.status.toLowerCase() == 'income')
                            .fold(0.0, (sum, task) => sum + task.amount);
                        double expenses = tasksForDate
                            .where(
                                (task) => task.status.toLowerCase() != 'income')
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
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: tasksForDate.length,
                                    itemBuilder: (context, index) {
                                      final task = tasksForDate[index];

                                      final backgroundColor =
                                          task.status.trim().toLowerCase() ==
                                                  'income'
                                              ? const Color(0xffCAA6A6)
                                              : const Color(0xfff8d7da);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 16),
                                        child: GestureDetector(
                                          onTap: () {
                                            _navigateToEdit(task.id!);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    backgroundColor, // Apply the background color here
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: ListTile(
                                              leading: Icon(_getIconForCategory(
                                                  task.category)),
                                              title: Text(task.note),
                                              subtitle: Text(
                                                  'RM ${task.amount.toStringAsFixed(2)} - ${task.status}'),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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

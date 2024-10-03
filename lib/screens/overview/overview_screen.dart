import 'package:expense_tracking_app/data/model/task.dart';
import 'package:expense_tracking_app/data/repo/task_repository.dart';
import 'package:expense_tracking_app/screens/overview/pie_chart_icon.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  DateTime selectedDate = DateTime.now();
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  Map<String, double> categoryIncome =
      {}; // Stores the income for each category
  Map<String, double> categoryExpenses =
      {}; // Stores the expenses for each category
  bool showIncome =
      true; // State to toggle between showing income and expense categories

  @override
  void initState() {
    super.initState();
    _loadMonthlyData(); // Fetch initial data when the screen loads
  }

  // Fetch tasks for the selected month and categorize them
  Future<void> _loadMonthlyData() async {
    setState(() {
      totalIncome = 0.0;
      totalExpense = 0.0;
      categoryIncome = {};
      categoryExpenses = {};
    });

    // Fetch all tasks from the repository
    final List<Task> tasks = await TaskRepository().getAllTasks();

    // Filter tasks for the selected month and calculate totals
    for (var task in tasks) {
      if (task.date.year == selectedDate.year &&
          task.date.month == selectedDate.month) {
        if (task.status == "Expense") {
          totalExpense += task.amount;
          categoryExpenses[task.category] =
              (categoryExpenses[task.category] ?? 0) + task.amount;
        } else if (task.status == "Income") {
          totalIncome += task.amount;
          categoryIncome[task.category] =
              (categoryIncome[task.category] ?? 0) + task.amount;
        }
      }
    }

    setState(() {}); // Trigger a UI update with the new data
  }

  // Method to select a new month and reload data
  Future<void> _pickMonthYear(BuildContext context) async {
    final picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadMonthlyData(); // Reload data for the new selected month
    }
  }

  // Method to get the color for a category
  Color _getCategoryColor(String category) {
    switch (category) {
      case "Salary":
        return const Color(0xFF001F3F);
      case "Bonus":
        return const Color(0xFF3A6D8C);
      case "Financial Income":
        return const Color(0xFF6A9AB0);
      case "Food":
        return const Color(0xFFDBB5B5);
      case "Shopping":
        return const Color(0xFFC39898);
      case "Transport":
        return const Color(0xFF987070);
      default:
        return Colors.grey;
    }
  }

  // Method to get the icon for a category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Salary":
        return Icons.attach_money;
      case "Bonus":
        return Icons.card_giftcard;
      case "Financial Income":
        return Icons.trending_up_outlined;
      case "Food":
        return Icons.fastfood;
      case "Shopping":
        return Icons.shopping_cart_outlined;
      case "Transport":
        return Icons.directions_car;
      default:
        return Icons.more_horiz;
    }
  }

  // Helper widget to build the Income and Expense buttons
  Widget _buildInfoButton(
      IconData icon, String title, double amount, bool isIncome) {
    // If isIncome matches showIncome, it means the button is currently selected.
    bool isSelected = (isIncome == showIncome);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showIncome =
                isIncome; // Set to show either income or expense categories
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            // Change color based on whether this button is selected
            color:
                isSelected ? const Color(0xFFCAA6A6) : const Color(0xFFFFE7E7),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  Text(
                    "RM$amount", // Display amount with currency
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build the category info
  Widget _buildCategoryInfo(IconData icon, String title, double amount) {
    // Use the correct total (either totalIncome or totalExpense) based on the current view
    final total = showIncome ? totalIncome : totalExpense;

    // Calculate percentage relative to the correct total
    double percentage = (amount / total) * 100;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE7E7),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          Text(
              "RM$amount (${percentage.toStringAsFixed(1)}%)"), // Display amount and percentage
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format the month as a full name, like "January"
    String formattedMonth =
        DateFormat.yMMMM().format(selectedDate); // Format month for display

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Overview")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Month-Year Picker
            GestureDetector(
              onTap: () => _pickMonthYear(context),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB47B84),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    formattedMonth, // Display the full month name
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Total Income and Total Expense Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoButton(Icons.arrow_circle_up_outlined, "Total Income",
                    totalIncome, true),
                const SizedBox(width: 20.0),
                _buildInfoButton(Icons.arrow_circle_down_outlined,
                    "Total Expense", totalExpense, false),
              ],
            ),
            const SizedBox(height: 20.0),
            // Pie chart displaying the breakdown of expenses by category
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: (showIncome ? categoryIncome : categoryExpenses)
                      .entries
                      .map((entry) {
                    final category = entry.key;
                    final amount = entry.value;
                    final total = showIncome ? totalIncome : totalExpense;
                    return PieChartSectionData(
                      color: _getCategoryColor(category),
                      value: amount,
                      radius: 100.0,
                      title:
                          "${(amount / total * 100).toStringAsFixed(1)}%", // Percentage
                      titleStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      badgeWidget: PieChartIcon(
                          icon: _getCategoryIcon(category),
                          size: 40.0,
                          borderColor: Colors.black),
                      badgePositionPercentageOffset: 1.1,
                    );
                  }).toList(),
                  borderData: FlBorderData(show: true),
                  centerSpaceRadius: 0,
                  sectionsSpace: 0,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // List of income or expense categories based on the current view (Income/Expense)
            ...(showIncome ? categoryIncome : categoryExpenses)
                .entries
                .map((entry) {
              return _buildCategoryInfo(
                  _getCategoryIcon(entry.key), entry.key, entry.value);
            }).toList(),
          ],
        ),
      ),
    );
  }
}

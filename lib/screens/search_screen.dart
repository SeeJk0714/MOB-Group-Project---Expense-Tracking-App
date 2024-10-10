import 'package:expense_tracking_app/data/repo/task_repository.dart';
import 'package:expense_tracking_app/nav/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracking_app/data/model/task.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TaskRepository repo = TaskRepository();
  final TextEditingController _searchController = TextEditingController();
  List<Task> tasks = [];
  Map<String, List<Task>> groupedTasks = {}; // To store grouped tasks by date
  List<Task> filteredTasks = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    try {
      List<Task> allTasks = await repo.getAllTasks();
      setState(() {
        tasks = allTasks;
        filteredTasks = allTasks; // Initialize filteredTasks with all tasks
        _groupTasksByDate(); // Group tasks by date
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // handle errors (e.g., show a message)
    }
  }

  // Group tasks by date
  void _groupTasksByDate() {
    groupedTasks.clear();
    for (var task in filteredTasks) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(task.date);
      if (!groupedTasks.containsKey(formattedDate)) {
        groupedTasks[formattedDate] = [];
      }
      groupedTasks[formattedDate]!.add(task);
    }
  }

  // Filter tasks by note and re-group by date
  void _filterTasks(String query) {
    setState(() {
      searchQuery = query.toLowerCase();

      if (searchQuery.isEmpty) {
        // If the search query is empty, reset the filtered tasks to all tasks
        filteredTasks = tasks;
      } else {
        // Filter the tasks based on the search query
        filteredTasks = tasks.where((task) {
          return task.note.toLowerCase().contains(searchQuery);
        }).toList();
      }

      _groupTasksByDate(); // Group the filtered tasks by date again
    });
  }

  IconData _getIconForCategory(String category) {
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

  // Build a grouped list by date
  Widget _buildTaskGroup(String date, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...tasks.map((task) => GestureDetector(
              onTap: () {
                _navigateToEdit(task.id!);
              },
              child: Card(
                color: task.status == "Expense"
                    ? const Color(0xFFFFE7E7)
                    : const Color(0xFFCAA6A6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ListTile(
                  leading: Icon(
                    _getIconForCategory(task.category),
                    color: Colors.black,
                  ),
                  title: Text(
                    task.note,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${task.account} - ${task.status}"),
                  trailing: Text(
                    "RM${task.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  // Click this go to edit page
  void _navigateToEdit(String id) async {
    await context.pushNamed(
      Screen.edit.name,
      pathParameters: {"id": id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFCAA6A6)),
              textAlign: TextAlign.center, // Center the input text
              onChanged: _filterTasks,
            ),

            const SizedBox(height: 20.0),
            // Task List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : groupedTasks.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hourglass_empty_outlined,
                              size: 50.0,
                            ),
                            Text(
                              "No data found",
                              style: TextStyle(fontSize: 30.0),
                            )
                          ],
                        )
                      : ListView.builder(
                          itemCount: groupedTasks.length,
                          itemBuilder: (context, index) {
                            // Sort the date keys (descending) and display in order
                            List<String> sortedKeys = groupedTasks.keys.toList()
                              ..sort((a, b) => b.compareTo(a)); // Descending

                            String dateKey = sortedKeys[index];
                            List<Task> tasksForDate = groupedTasks[dateKey]!;
                            return _buildTaskGroup(dateKey, tasksForDate);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

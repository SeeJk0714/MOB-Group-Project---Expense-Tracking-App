import 'package:expense_tracking_app/screens/add_edit/add/add_expense_screen.dart';
import 'package:expense_tracking_app/screens/add_edit/add/add_income_screen.dart';
import 'package:flutter/material.dart';

class AddTabBarScreen extends StatefulWidget {
  const AddTabBarScreen({super.key});

  @override
  State<AddTabBarScreen> createState() => _AddTabBarScreenState();
}

class _AddTabBarScreenState extends State<AddTabBarScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Expense"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Container(
                height: 40.0,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Color(0xFFFFE7E7),
                ),
                child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Color(0xFFB47B84),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      // TabItem(title: "Expenses"),
                      // TabItem(title: "Income")
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Expense",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Income",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            AddExpenseScreen(),
            AddIncomeScreen(),
          ],
        ),
      ),
    );
  }
}

import 'package:expense_tracking_app/data/model/task.dart';
import 'package:expense_tracking_app/data/repo/task_repository.dart';
import 'package:expense_tracking_app/screens/add_edit/item/account_item.dart';
import 'package:expense_tracking_app/screens/add_edit/item/income_item.dart';
import 'package:expense_tracking_app/screens/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final repo = TaskRepository();
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _dropDownAccount = "Cash";
  String _dropDownCategory = "Salary";
  bool _isLoading = false; // State variable for loading
  String? _dateError;
  String? _amountError;
  String? _noteError;

  //create show datepicker function
  Future<void> selectDate() async {
    DateTime? _selected = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
        initialDate: DateTime.now());

    if (_selected != null) {
      setState(() {
        _dateController.text = _selected.toString().split(" ")[0];
      });
    }
  }

  Future<void> _toastMessage() async {
    await showToastMessage(
      context,
      title: "Add Income Successfully",
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    );
  }

  Future<void> _clearTextFields() async {
    setState(() {
      _dateController.clear();
      _amountController.clear();
      _noteController.clear();
      _dropDownAccount = "Cash";
      _dropDownCategory = "Salary";
    });
  }

  // This is click the save button
  Future<void> _saveIncome() async {
    // Clear errors
    setState(() {
      _dateError = null;
      _amountError = null;
      _noteError = null;
    });

    if (_dateController.text.isEmpty) {
      setState(() {
        _dateError = "Please enter your date";
      });
      return;
    }
    if (_amountController.text.isEmpty) {
      setState(() {
        _amountError = "Please enter your amount";
      });
      return;
    }
    if (_noteController.text.isEmpty) {
      setState(() {
        _amountError = "Please enter your note";
      });
      return;
    }

    final task = Task(
        date: DateTime.parse(_dateController.text),
        account: _dropDownAccount,
        category: _dropDownCategory,
        amount: double.parse(_amountController.text),
        note: _noteController.text,
        status: "Income");

    // Set loading to true
    setState(() {
      _isLoading = true;
    });

    try {
      await repo.addTask(task);

      // Simulate a network call or processing delay
      await Future.delayed(const Duration(seconds: 2));
      _clearTextFields();
      _toastMessage();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    // context.go("/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: _isLoading
          ? Center(
              child: SpinKitThreeInOut(
                size: 50.0,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: index.isEven
                            ? const Color(0xFF944E63)
                            : const Color(0xFFB47B84)),
                  );
                },
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                      labelText: "Date",
                      labelStyle: const TextStyle(
                          fontSize: 22.0, color: Colors.black54),
                      errorText: _dateError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      filled: true,
                      fillColor: const Color(0xFFCAA6A6)),
                  onTap: () {
                    selectDate();
                  },
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFCAA6A6),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: DropdownButton<String>(
                    items: accountDropdownMenuItems(),
                    onChanged: (value) {
                      setState(() {
                        _dropDownAccount = value!;
                      });
                    },
                    value: _dropDownAccount,
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined,
                        color: Colors.black),
                    dropdownColor: const Color(0xFFCAA6A6),
                    borderRadius: BorderRadius.circular(20.0),
                    isExpanded:
                        true, // This ensures the text and icon are spaced out
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFCAA6A6),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: DropdownButton<String>(
                    items: incomeDropdownMenuItems(),
                    onChanged: (value) {
                      setState(() {
                        _dropDownCategory = value!;
                      });
                    },
                    value: _dropDownCategory,
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined,
                        color: Colors.black),
                    dropdownColor: const Color(0xFFCAA6A6),
                    borderRadius: BorderRadius.circular(20.0),
                    isExpanded:
                        true, // This ensures the text and icon are spaced out
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _amountController,
                  style: const TextStyle(fontSize: 22.0, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Amount",
                      labelStyle: const TextStyle(
                          fontSize: 22.0, color: Colors.black54),
                      errorText: _amountError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFCAA6A6)),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    // Allow Decimal Number With Precision of 2 Only
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _noteController,
                  style: const TextStyle(fontSize: 22.0, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Note",
                      labelStyle: const TextStyle(
                          fontSize: 22.0, color: Colors.black54),
                      errorText: _noteError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFCAA6A6)),
                ),
                const SizedBox(height: 80.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      backgroundColor: const Color(0xFFB47B84),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: const Size(200, 50),
                    ),
                    onPressed: _saveIncome,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 22.0, // Font size
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    ));
  }
}

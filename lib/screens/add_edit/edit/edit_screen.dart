import 'package:expense_tracking_app/data/model/task.dart';
import 'package:expense_tracking_app/data/repo/task_repository.dart';
import 'package:expense_tracking_app/screens/add_edit/item/account_item.dart';
import 'package:expense_tracking_app/screens/add_edit/item/expense_item.dart';
import 'package:expense_tracking_app/screens/add_edit/item/income_item.dart';
import 'package:expense_tracking_app/screens/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.id});

  final String id;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Task? task;
  final repo = TaskRepository();
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _dropDownAccount = "Cash";
  String _dropDownCategory = "Other";
  bool _isLoading = false; // State variable for loading
  String? _dateError;
  String? _amountError;
  String? _noteError;

  void _init() async {
    task = await repo.getTaskById(widget.id);
    if (task != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(task!.date);
        _amountController.text = task!.amount.toString();
        _noteController.text = task!.note;
        _dropDownAccount = task!.account;

        // Ensure that the loaded category is valid
        if (task!.status == "Expense") {
          if (expenseDropdownMenuItems()
              .any((item) => item.value == task!.category)) {
            _dropDownCategory = task!.category;
          } else {
            _dropDownCategory = expenseDropdownMenuItems().first.value!;
          }
        } else {
          if (incomeDropdownMenuItems()
              .any((item) => item.value == task!.category)) {
            _dropDownCategory = task!.category;
          } else {
            _dropDownCategory = incomeDropdownMenuItems().first.value!;
          }
        }
      });
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

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

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("Are you sure you want to delete?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge),
                child: const Text("NO"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteExpense(widget.id);
                },
                child: const Text("YES"),
              ),
            ],
          );
        });
  }

  Future<void> _editToastMessage() async {
    await showToastMessage(
      context,
      title: "Edit Successfully",
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    );
  }

  Future<void> _deleteToastMessage() async {
    await showToastMessage(
      context,
      title: "Delete Successfully",
      icon: Icons.delete_outline_outlined,
      iconColor: Colors.red,
    );
  }

  Future<void> editExpense() async {
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

    // Set loading to true
    setState(() {
      _isLoading = true;
    });

    try {
      if (task != null) {
        repo.updateTask(task!.copy(
          date: DateTime.parse(_dateController.text),
          amount: double.parse(_amountController.text),
          note: _noteController.text,
          account: _dropDownAccount,
          category: _dropDownCategory,
        ));
      }
      // Simulate a network call or processing delay
      await Future.delayed(const Duration(seconds: 2));
      _editToastMessage();
      context.pop("true");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteExpense(String id) async {
    // Set loading to true
    setState(() {
      _isLoading = true;
    });

    try {
      repo.deleteTask(id);

      // Simulate a network call or processing delay
      await Future.delayed(const Duration(seconds: 2));
      _deleteToastMessage();
      context.pop("true");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Edit Expense"), centerTitle: true),
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
                      onChanged: (value) => {},
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
                        items: task?.status == "Expense"
                            ? expenseDropdownMenuItems()
                            : incomeDropdownMenuItems(),
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
                      style:
                          const TextStyle(fontSize: 22.0, color: Colors.black),
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _noteController,
                      style:
                          const TextStyle(fontSize: 22.0, color: Colors.black),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => _dialogBuilder(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFB47B84)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 22.0, color: Color(0xFFB47B84)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 20.0),
                            backgroundColor: const Color(0xFFB47B84),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(150, 50),
                          ),
                          onPressed: editExpense,
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ));
  }
}

import 'package:expense_tracking_app/data/model/task.dart';
import 'package:expense_tracking_app/data/repo/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final repo = TaskRepository();

  String _dropDownAccount = "Cash";
  String _dropDownCategory = "Salary";
  String? _dateError;
  String? _amountError;
  String? _noteError;

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
    repo.addTask(task);

    context.go("/");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
                labelText: "Date",
                labelStyle:
                    const TextStyle(fontSize: 22.0, color: Colors.black54),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: DropdownButton<String>(
              items: const [
                DropdownMenuItem(
                  value: "Cash",
                  child: Row(
                    children: [
                      Icon(Icons.money_outlined, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("Cash")
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "TNG",
                  child: Row(
                    children: [
                      Icon(Icons.phone_iphone_outlined, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("TNG")
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "Bank",
                  child: Row(
                    children: [
                      Icon(Icons.account_balance, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("Bank")
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "Credit Card",
                  child: Row(
                    children: [
                      Icon(Icons.credit_card_outlined, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("Credit Card")
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "Other",
                  child: Row(
                    children: [
                      Icon(Icons.more_horiz, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("Other")
                    ],
                  ),
                ),
              ],
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
              isExpanded: true, // This ensures the text and icon are spaced out
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFCAA6A6),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: DropdownButton<String>(
              items: const [
                DropdownMenuItem(
                  value: "Salary",
                  child: Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("Salary")
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "Bonus",
                  child: Row(
                    children: [
                      Icon(Icons.card_giftcard, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("Bonus")
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "Financial Income",
                  child: Row(
                    children: [
                      Icon(Icons.trending_up_outlined, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("Financial Income")
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "Other",
                  child: Row(
                    children: [
                      Icon(Icons.more_horiz, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text("Other")
                    ],
                  ),
                ),
              ],
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
              isExpanded: true, // This ensures the text and icon are spaced out
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _amountController,
            style: const TextStyle(fontSize: 22.0, color: Colors.black),
            decoration: InputDecoration(
                labelText: "Amount",
                labelStyle:
                    const TextStyle(fontSize: 22.0, color: Colors.black54),
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
            style: const TextStyle(fontSize: 22.0, color: Colors.black),
            decoration: InputDecoration(
                labelText: "Note",
                labelStyle:
                    const TextStyle(fontSize: 22.0, color: Colors.black54),
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class MonthYearPicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const MonthYearPicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  Future<void> _selectMonthYear(BuildContext context) async {
    DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.yMMMM().format(selectedDate),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () => _selectMonthYear(context),
          child: const Row(
            children: [
              Icon(Icons.date_range_outlined),
              SizedBox(
                width: 10.0,
              ),
              Text("Select Month"),
            ],
          ),
        ),
      ],
    );
  }
}

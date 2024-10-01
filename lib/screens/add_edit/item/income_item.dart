import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> incomeDropdownMenuItems() {
  return const [
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
  ];
}

import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> expenseDropdownMenuItems() {
  return const [
    DropdownMenuItem(
      value: "Food",
      child: Row(
        children: [
          Icon(Icons.fastfood_outlined, color: Colors.black),
          SizedBox(width: 10.0),
          Text("Food")
        ],
      ),
    ),
    DropdownMenuItem(
      value: "Transport",
      child: Row(
        children: [
          Icon(Icons.emoji_transportation_outlined, color: Colors.black),
          SizedBox(width: 10.0),
          Text("Transport")
        ],
      ),
    ),
    DropdownMenuItem(
      value: "Shopping",
      child: Row(
        children: [
          Icon(Icons.shopping_cart_outlined, color: Colors.black),
          SizedBox(width: 10.0),
          Text("Shopping")
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

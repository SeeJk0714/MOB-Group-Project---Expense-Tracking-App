import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> accountDropdownMenuItems() {
  return const [
    DropdownMenuItem(
      value: "Cash",
      child: Row(
        children: [
          Icon(Icons.money_outlined, color: Colors.black),
          SizedBox(width: 10.0),
          Text("Cash"),
        ],
      ),
    ),
    DropdownMenuItem(
      value: "TNG",
      child: Row(
        children: [
          Icon(Icons.phone_iphone_outlined, color: Colors.black),
          SizedBox(width: 10.0),
          Text("TNG"),
        ],
      ),
    ),
    DropdownMenuItem(
      value: "Bank",
      child: Row(
        children: [
          Icon(Icons.account_balance, color: Colors.black),
          SizedBox(width: 10.0),
          Text("Bank"),
        ],
      ),
    ),
    DropdownMenuItem(
      value: "Credit Card",
      child: Row(
        children: [
          Icon(Icons.credit_card_outlined, color: Colors.black),
          SizedBox(width: 10.0),
          Text("Credit Card"),
        ],
      ),
    ),
    DropdownMenuItem(
      value: "Other",
      child: Row(
        children: [
          Icon(Icons.more_horiz, color: Colors.black),
          SizedBox(width: 10.0),
          Text("Other"),
        ],
      ),
    ),
  ];
}

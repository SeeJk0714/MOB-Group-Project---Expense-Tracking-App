class Task {
  String? id;
  final DateTime date; //
  final String account; // cash, bank, credit card, other
  final String category; // food, transport, shopping, other
  final double amount; //100.00
  final String note;
  final String status; // expense, income

  Task({
    this.id,
    required this.date,
    required this.account,
    required this.category,
    required this.amount,
    required this.note,
    required this.status,
  });

  Task copy(
      {String? id,
      DateTime? date,
      String? account,
      String? category,
      double? amount,
      String? note,
      String? status}) {
    return Task(
      id: id ?? this.id,
      date: date ?? this.date,
      account: account ?? this.account,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "date": date,
      "account": account,
      "category": category,
      "amount": amount,
      "note": note,
      "status": status,
    };
  }

  static Task fromMap(Map<String, dynamic> mp) {
    return Task(
      id: mp["id"] as String?,
      date: DateTime.parse(mp["date"]),
      account: mp["account"] as String,
      category: mp["category"] as String,
      amount: mp["amount"] as double,
      note: mp["note"] as String,
      status: mp["status"] as String,
    );
  }

  @override
  String toString() {
    return "Task($id, $date, $account, $category, $amount, $note, $status)";
  }
}

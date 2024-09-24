class User {
  int? id;
  final String username;
  final String email;

  User({this.id, required this.username, required this.email});

  User copy({int? id, String? username, String? email, String? psw}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "username": username,
      "email": email,
    };
  }

  User fromMap(Map<String, dynamic> mp) {
    return User(
      id: mp["id"] as int?,
      username: mp["username"] as String,
      email: mp["email"] as String,
    );
  }

  @override
  String toString() {
    return "User($id, $username, $email)";
  }
}

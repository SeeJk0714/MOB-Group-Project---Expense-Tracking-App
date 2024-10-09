class User {
  String? id;
  final String username;
  final String email;
  final String? profileImageUrl; // Add this line for profile image URL

  User({this.id, required this.username, required this.email, this.profileImageUrl}); // Update constructor

  // Copy constructor for creating a modified copy of the user
  User copy({String? id, String? username, String? email, String? profileImageUrl}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl, // Update copy constructor
    );
  }

  // Convert a User object to a Map for storage in Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "profileImageUrl": profileImageUrl, // Include the profile image URL
    };
  }

  // Create a User object from a Map
  static User fromMap(Map<String, dynamic> mp) {
    return User(
      id: mp["id"] as String?,
      username: mp["username"] as String, // Ensure username is not null
      email: mp["email"] as String, // Ensure email is not null
      profileImageUrl: mp["profileImageUrl"] as String?, // Add this line for profile image URL
    );
  }

  @override
  String toString() {
    return "User(id: $id, username: $username, email: $email, profileImageUrl: $profileImageUrl)";
  }
}

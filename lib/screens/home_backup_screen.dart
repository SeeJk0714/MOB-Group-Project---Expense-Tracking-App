// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class HomeBackupScreen extends StatefulWidget {
//   const HomeBackupScreen({super.key});

//   @override
//   State<HomeBackupScreen> createState() => _HomeBackupScreenState();
// }

// class _HomeBackupScreenState extends State<HomeBackupScreen> {
//   void _logout() async {
//     await FirebaseAuth.instance.signOut();
//     // After logout, navigate back to login screen
//     context.go('/login'); // Assuming you have a route for the login screen
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Home Screen",
//               style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20), // Spacing between text and button
//             ElevatedButton(
//               onPressed: _logout, // Call the logout function when pressed
//               style: ElevatedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: const Text("Logout"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// /********************************************** */



// import 'package:expense_tracking_app/data/model/user.dart';
// import 'package:expense_tracking_app/data/repo/user_repository.dart';
// import 'package:expense_tracking_app/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// class UserProfilePage extends StatefulWidget {
//   final String userId;

//   const UserProfilePage({super.key, required this.userId});

//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
//   final UserRepository _userRepository = UserRepository();
//   User? _currentUser;
//   bool _isLoading = true;
//   String? _errorMessage;

//   // Controllers for text fields
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentUser();
//   }

//   Future<void> _fetchCurrentUser() async {
//   try {
//     // Fetch the logged-in user's ID from FirebaseAuth
//     final firebase_auth.User? firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

//     if (firebaseUser != null) {
      
//       // Get user data from Firestore using the user ID
//       final user = await _userRepository.getUserById(firebaseUser.uid);
      
//       if (user != null) {
//         setState(() {
//           _currentUser = user;
//           _usernameController.text = user.username;
//           _emailController.text = user.email;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = "User data not found";
//         });
//       }
//     } else {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = "No user logged in";
//       });
//     }
//   } catch (e) {
//     setState(() {
//       _isLoading = false;
//       _errorMessage = 'Error fetching user: $e';
//     });
//   }
// }

//   Future<void> _updateUserProfile() async {
//     if (_currentUser == null) return;

//     try {
//       // Create a modified copy of the user with updated fields
//       final updatedUser = _currentUser!.copy(
//         username: _usernameController.text,
//         email: _emailController.text,
//       );
//       await _userRepository.updateUser(updatedUser);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile updated successfully!')),
//       );
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating profile: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
//           : _errorMessage != null
//               ? Center(child: Text(_errorMessage!)) // Display error message if there's one
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: _usernameController,
//                           decoration: const InputDecoration(labelText: "Username"),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a username';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: const InputDecoration(labelText: "Email"),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter an email';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 32),
//                         ElevatedButton(
//                           onPressed: _updateUserProfile,
//                           child: const Text("Save Changes"),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
// }




// Future<void> onProfileTapped() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if(image == null) return;

//     final storageRef = FirebaseStorage.instance.ref();
//     final imageRef = storageRef.child("user_1.jpg");
//     final imageBytes = await image.readAsBytes();
//     await imageRef.putData(imageBytes);
//   }
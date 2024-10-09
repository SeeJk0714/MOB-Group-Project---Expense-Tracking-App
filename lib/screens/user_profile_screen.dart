import 'dart:io';

import 'package:expense_tracking_app/nav/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracking_app/data/model/user.dart';
import 'package:expense_tracking_app/data/repo/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required String userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserRepository _userRepository = UserRepository();
  User? _currentUser;
  // ignore: unused_field
  bool _isLoading = true;
  String? _profileImageUrl; // Variable to store the profile image URL

  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _logout() async {
    await firebase_auth.FirebaseAuth.instance.signOut();
    // After logout, navigate back to login screen
    // ignore: use_build_context_synchronously
    context.go('/login'); // Assuming you have a route for the login screen
  }

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    await _uploadProfileImage(image);
  }

  Future<void> _uploadProfileImage(XFile image) async {
  try {
    // Get a reference to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref();
    
    // Create a unique filename for the image using user ID and image name
    String fileName = 'profile_images/${_currentUser!.id}/${image.name}';
    final imageRef = storageRef.child(fileName);


    // Upload the image
    await imageRef.putFile(File(image.path));

    // Get the download URL
    final downloadUrl = await imageRef.getDownloadURL();

    // Verify downloadUrl is not null or empty
    // ignore: unnecessary_null_comparison
    if (downloadUrl == null || downloadUrl.isEmpty) {
      throw Exception('Failed to get download URL');
    }

    // Update the user profile with the new image URL
    final updatedUser = _currentUser!.copy(profileImageUrl: downloadUrl);
    
    await _userRepository.updateUser(updatedUser);

    setState(() {
      _profileImageUrl = downloadUrl; // Update the local variable with the new image URL
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture updated successfully!')),
    );
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error uploading image: $e')),
    );
  }
}


  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      // Fetch the logged-in user's ID from FirebaseAuth
      final firebase_auth.User? firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        // Get user data from Firestore using the user ID
        final user = await _userRepository.getUserById(firebaseUser.uid);

        if (user != null) {
          setState(() {
            _currentUser = user;
            _usernameController.text = user.username;
            _emailController.text = user.email;
            _profileImageUrl = user.profileImageUrl; // Load the existing profile image URL
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (_currentUser == null) return;

    try {
      // Create a modified copy of the user with updated fields
      final updatedUser = _currentUser!.copy(
        username: _usernameController.text,
        email: _emailController.text,
        profileImageUrl: _profileImageUrl
      );
      await _userRepository.updateUser(updatedUser);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
        
      );
      // ignore: use_build_context_synchronously
      await context.pushNamed(Screen.home.name);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: onProfileTapped, // Call the onProfileTapped function when tapped
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 211, 211, 211),
                  shape: BoxShape.circle,
                  image: _profileImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_profileImageUrl!), // Load the profile image
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _profileImageUrl == null
                    ? const Icon(
                        Icons.person_2,
                        color: Colors.black,
                        size: 35.0,
                      )
                    : null, // Show icon only if no image
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: const Text("Save Changes"),
            ),
            const SizedBox(height: 20.0),
            Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 30.0,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

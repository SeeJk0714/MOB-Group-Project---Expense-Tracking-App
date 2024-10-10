import 'package:expense_tracking_app/data/auth/auth_service.dart';
import 'package:expense_tracking_app/nav/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _pswController = TextEditingController();
  final Authservice _authService = Authservice();

  String? _emailError;
  String? _pswError;
  bool _isLoading = false;

  Future<void> _login() async {
    // Clear errors and set loading state
    setState(() {
      _emailError = null;
      _pswError = null;
      _isLoading = true;
    });

    // Basic validation
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = "Please enter your email";
        _isLoading = false;
      });
      return;
    }
    if (_pswController.text.isEmpty) {
      setState(() {
        _pswError = "Please enter your password";
        _isLoading = false;
      });
      return;
    }

    try {
      User? user = await _authService.signInWithEmailPassword(
          _emailController.text, _pswController.text);
      if (user != null) {
        // Navigate to home screen if login is successful
        // ignore: use_build_context_synchronously
        await context.pushNamed(Screen.home.name);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        // Set appropriate error messages based on the FirebaseAuthException code
        if (e.code == 'user-not-found') {
          _emailError = "Email does not exist. Please check or sign up.";
        } else if (e.code == 'wrong-password') {
          _pswError = "Incorrect password. Please try again.";
        } else {
          _emailError = "Login failed. Please try again later.";
        }
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.login_outlined,
                    size: 50.0,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 50.0,
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              Text(
                "Welcome\nBack",
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..color = Colors.white),
              ),
              const SizedBox(height: 120.0),
              TextField(
                controller: _emailController,
                onChanged: (value) => setState(() {
                  _emailError = null; // Clear error on typing
                }),
                style: const TextStyle(fontSize: 22.0, color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle:
                      const TextStyle(fontSize: 22.0, color: Colors.black54),
                  errorText: _emailError, // Display error message here
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFFE7E7),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _pswController,
                onChanged: (value) => setState(() {
                  _pswError = null; // Clear error on typing
                }),
                style: const TextStyle(fontSize: 22.0),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle:
                      const TextStyle(fontSize: 22.0, color: Colors.black54),
                  errorText: _pswError, // Display error message here
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFFE7E7),
                ),
              ),
              const SizedBox(height: 140),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: const Color(0xFFB47B84),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: _login,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
              const SizedBox(height: 10.0),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(Screen.register.name);
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Color(0xFFB47B84),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

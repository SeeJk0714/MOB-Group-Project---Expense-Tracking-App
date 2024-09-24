import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:expense_tracking_app/data/auth/auth_service.dart';
import 'package:expense_tracking_app/nav/Navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pswController = TextEditingController();
  final _confirmPswController = TextEditingController();
  final Authservice _authservice = Authservice();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  String? _usernameError;
  String? _emailError;
  String? _pswError;
  String? _confirmPswError;
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() {
      _usernameError = null;
      _emailError = null;
      _pswError = null;
      _confirmPswError = null;
      _isLoading = true;
    });

    // Input validation
    if (_usernameController.text.isEmpty) {
      setState(() {
        _usernameError = "Please enter your username";
        _isLoading = false;
      });
      return;
    }

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

    if (_pswController.text != _confirmPswController.text) {
      setState(() {
        _confirmPswError = "Passwords do not match";
        _isLoading = false;
      });
      return;
    }

    debugPrint(_emailController.text);

    try {
      User? user = await _authservice.signUpWithEmailPassword(
        _usernameController.text,
        _emailController.text,
        _pswController.text,
      );

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': _usernameController.text,
          'email': _emailController.text,
        }).then((_) {
          context.pushNamed(Screen.login.name);
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _emailError = "Email already in use";
        } else if (e.code == 'invalid-email') {
          _emailError = "Invalid email format";
        } else if (e.code == 'weak-password') {
          _pswError = "Password is too weak";
        } else {
          _emailError = "Registration failed. Please try again";
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
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
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 50.0,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.login_outlined,
                    size: 50.0,
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              Text(
                "Create\nAccount",
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..color = Colors.white),
              ),
              const SizedBox(height: 100.0),
              TextField(
                controller: _usernameController,
                onChanged: (value) => setState(() {
                  _usernameError = null;
                }),
                style: const TextStyle(fontSize: 22.0, color: Colors.black),
                decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle:
                        const TextStyle(fontSize: 22.0, color: Colors.black54),
                    errorText: _usernameError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFE7E7)),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _emailController,
                onChanged: (value) => setState(() {
                  _emailError = null;
                }),
                style: const TextStyle(fontSize: 22.0),
                decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle:
                        const TextStyle(fontSize: 22.0, color: Colors.black54),
                    errorText: _emailError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFE7E7)),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _pswController,
                onChanged: (value) => setState(() {
                  _pswError = null;
                }),
                style: const TextStyle(fontSize: 22.0),
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle:
                        const TextStyle(fontSize: 22.0, color: Colors.black54),
                    errorText: _pswError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFE7E7)),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _confirmPswController,
                onChanged: (value) => setState(() {
                  _confirmPswError = null;
                }),
                style: const TextStyle(fontSize: 22.0),
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle:
                        const TextStyle(fontSize: 22.0, color: Colors.black54),
                    errorText: _confirmPswError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFE7E7)),
              ),
              const SizedBox(height: 10.0),
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: const Color(0xFFB47B84),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Sign Up',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                        )),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: TextButton(
                    onPressed: () {
                      context.pushNamed(Screen.login.name);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Color(0xFFB47B84),
                        decoration: TextDecoration.underline,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

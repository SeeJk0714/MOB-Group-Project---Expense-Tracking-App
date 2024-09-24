import 'package:expense_tracking_app/nav/Navigation.dart';
import 'package:expense_tracking_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // one page
    // return MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //       useMaterial3: true,
    //     ),
    //     home: const LoginScreen());

    // multiple page
    return MaterialApp.router(
      routerConfig: GoRouter(
          initialLocation: Navigation.initial, routes: Navigation.routes),
    );
  }
}

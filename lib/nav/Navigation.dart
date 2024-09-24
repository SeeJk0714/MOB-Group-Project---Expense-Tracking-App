import 'package:expense_tracking_app/screens/bottom_bar_screen.dart';
import 'package:expense_tracking_app/screens/login_screen.dart';
import 'package:expense_tracking_app/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

class Navigation {
  static const initial = "/login";
  static final routes = [
    GoRoute(
      path: "/",
      builder: (context, state) => const BottomBarScreen(),
    ),
    GoRoute(
        path: "/home",
        name: Screen.home.name,
        builder: (context, state) => const BottomBarScreen()),
    GoRoute(
        path: "/add",
        name: Screen.add.name,
        builder: (context, state) => const BottomBarScreen()),
    GoRoute(
        path: "/search",
        name: Screen.search.name,
        builder: (context, state) => const BottomBarScreen()),
    GoRoute(
        path: "/overview",
        name: Screen.overview.name,
        builder: (context, state) => const BottomBarScreen()),
    GoRoute(
        path: "/login",
        name: Screen.login.name,
        builder: (context, state) => const LoginScreen()),
    GoRoute(
        path: "/register",
        name: Screen.register.name,
        builder: (context, state) => const RegisterScreen()),
  ];
}

enum Screen { home, add, search, overview, login, register }

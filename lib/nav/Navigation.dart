import 'package:expense_tracking_app/screens/bottom_bar_screen.dart';
import 'package:go_router/go_router.dart';

class Navigation {
  static const initial = "/";
  static final routes = [
    GoRoute(
      path: "/",
      builder: (context, state) => const BottomBarScreen(),
    ),
    // GoRoute(
    //     path: "/home",
    //     name: Screen.home.name,
    //     builder: (context, state) => const HomeScreen()),
    // GoRoute(
    //     path: "/add",
    //     name: Screen.add.name,
    //     builder: (context, state) => const AddScreen()),
    // GoRoute(
    //     path: "/search",
    //     name: Screen.search.name,
    //     builder: (context, state) => const SearchScreen()),
    // GoRoute(
    //     path: "/overview",
    //     name: Screen.overview.name,
    //     builder: (context, state) => const OverviewScreen()),
    // GoRoute(
    //     path: "/login",
    //     name: Screen.login.name,
    //     builder: (context, state) => const LoginScreen()),
    // GoRoute(
    //     path: "/register",
    //     name: Screen.register.name,
    //     builder: (context, state) => const RegisterScreen()),
  ];
}

enum Screen { home, add, search, overview, login, register }

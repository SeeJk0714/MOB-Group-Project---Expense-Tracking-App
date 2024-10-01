import 'package:expense_tracking_app/screens/add_edit/add/add_expense_screen.dart';
import 'package:expense_tracking_app/screens/add_edit/add/add_income_screen.dart';
import 'package:expense_tracking_app/screens/add_edit/edit/edit_screen.dart';
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
        path: "/add_tab_bar",
        name: Screen.addTabBar.name,
        builder: (context, state) => const BottomBarScreen()),
    GoRoute(
        path: "/add_expense",
        name: Screen.addExpense.name,
        builder: (context, state) => const AddExpenseScreen()),
    GoRoute(
        path: "/add_income",
        name: Screen.addIncome.name,
        builder: (context, state) => const AddIncomeScreen()),
    GoRoute(
        path: "/edit/:id",
        name: Screen.edit.name,
        builder: (context, state) => EditScreen(
              id: state.pathParameters["id"]!,
            )),
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

enum Screen {
  home,
  addTabBar,
  addExpense,
  addIncome,
  edit,
  detail,
  search,
  overview,
  login,
  register
}

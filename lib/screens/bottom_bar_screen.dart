import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0; // Track the selected index

  /*
    This list holds all the screen widgets for each tab in the bottom navigation. 
    When a tab is tapped, the corresponding screen is displayed.
   */
  final List<Widget> _screens = [
    // const HomeScreen(),
    // const AddScreen(),
    // const OverviewScreen(),
    // const SearchScreen(),
  ];

  /*
    The _onTabSelected function updates the selected tab index and refreshes 
    the UI to show the corresponding screen.
  */
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Show the selected screen
      bottomNavigationBar: Container(
        color: const Color(0xFF944E63),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: const Color(0xFF944E63),
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: const Color(0xFFB47B84),
            gap: 8,
            padding: const EdgeInsets.all(16),
            selectedIndex: _selectedIndex, // Set selected index
            onTabChange: _onTabSelected, // Handle tab change
            tabs: const [
              GButton(
                icon: Icons.account_balance_wallet_outlined,
                text: 'Home',
              ),
              GButton(icon: Icons.add_circle_outline, text: 'Add'),
              GButton(icon: Icons.pie_chart_outline, text: 'Overview'),
              GButton(icon: Icons.search, text: 'Search'),
            ],
          ),
        ),
      ),
    );
  }
}

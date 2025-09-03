import 'package:ACE-thetic/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'items/items_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'dashboard/buyer/buyer_profile_screen.dart';
import 'dashboard/seller/seller_profile_screen.dart';
import 'dashboard/admin/admin_dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getProfileScreen(String? role) {
    switch (role) {
      case 'BUYER':
        return BuyerProfileScreen();
      case 'SELLER':
        return SellerProfileScreen();
      case 'ADMIN':
        return AdminDashboardScreen();
      default:
        return const Center(child: Text('Please log in to view your profile'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final authProvider = Provider.of<AuthProvider>(context);

    final screens = [
      ItemsScreen(),
      DashboardScreen(),
      _getProfileScreen(authProvider.user?.role),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      drawer: AppDrawer(),
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: color.surface,
        indicatorColor: color.primary.withOpacity(0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black26,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: const Duration(milliseconds: 500),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined, color: color.onSurface.withOpacity(0.7)),
            selectedIcon: Icon(Icons.shopping_bag, color: color.primary),
            label: 'Items',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
              color: color.onSurface.withOpacity(0.7),
            ),
            selectedIcon: Icon(Icons.dashboard, color: color.primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: color.onSurface.withOpacity(0.7),
            ),
            selectedIcon: Icon(Icons.person, color: color.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

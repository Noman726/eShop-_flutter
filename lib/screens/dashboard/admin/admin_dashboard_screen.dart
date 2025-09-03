import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/app_drawer.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final color = Theme.of(context).colorScheme;

    if (user?.role != 'ADMIN') {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Dashboard')),
        drawer: AppDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
            opacity: 0.15,
            child: Image.asset(
              'assets/images/dashboard_bg.jpg', // Put your image in assets/images/
              fit: BoxFit.cover,
            ),
          ),
            Container(color: Colors.black.withOpacity(0.3)),
            const Center(
              child: Text(
                'Access Denied',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      drawer: AppDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
           Opacity(
            opacity: 0.15,
            child: Image.asset(
              'assets/images/dashboard_bg.jpg', // Put your image in assets/images/
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              padding: const EdgeInsets.all(24),
              childAspectRatio: 1.2,
              children: [
                _DashboardBox(
                  label: 'Manage Categories',
                  icon: Icons.category_outlined,
                  color: color.secondary,
                  onTap: () => Navigator.pushNamed(context, '/dashboard/admin/categories'),
                ),
                _DashboardBox(
                  label: 'Manage Items',
                  icon: Icons.inventory_2_outlined,
                  color: color.tertiary,
                  onTap: () => Navigator.pushNamed(context, '/dashboard/admin/items'),
                ),
                _DashboardBox(
                  label: 'Manage Users',
                  icon: Icons.people_alt_outlined,
                  color: Colors.teal,
                  onTap: () => Navigator.pushNamed(context, '/dashboard/admin/users'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardBox({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

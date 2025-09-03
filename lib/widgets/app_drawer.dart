import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '/theme_provider.dart'; // Import ThemeProvider

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final textTheme = theme.textTheme;
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.user;
    final userRole = user?.role;

    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Drawer(
      child: Container(
        color: color.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: color.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ACE-thetic',
                    style: textTheme.headlineSmall?.copyWith(
                      color: color.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authProvider.isAuthenticated
                        ? '${user?.name} (${userRole ?? "User"})'
                        : 'Guest',
                    style: textTheme.bodyMedium?.copyWith(
                      color: color.onPrimary.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            _buildSectionTitle(context, 'Explore'),
            _buildTile(context, icon: Icons.home_outlined, label: 'Home', route: '/dashboard'),
            _buildTile(context, icon: Icons.info_outline, label: 'About', route: '/about'),
            _buildTile(context, icon: Icons.contact_mail_outlined, label: 'Contact', route: '/contact'),
            _buildTile(context, icon: Icons.question_answer_outlined, label: 'FAQ', route: '/faq'),

            const SizedBox(height: 12),

            if (userRole == 'ADMIN') ...[
              _buildSectionTitle(context, 'Admin'),
              _buildTile(context, icon: Icons.admin_panel_settings_outlined, label: 'Admin Dashboard', route: '/dashboard/admin'),
              _buildTile(context, icon: Icons.category_outlined, label: 'Manage Categories', route: '/dashboard/admin/categories'),
              _buildTile(context, icon: Icons.people_alt_outlined, label: 'Manage Users', route: '/dashboard/admin/users'),
            ],
            if (userRole == 'BUYER') ...[
              _buildSectionTitle(context, 'Buyer'),
              _buildTile(context, icon: Icons.dashboard_customize_outlined, label: 'Buyer Dashboard', route: '/dashboard/buyer'),
            ],
            if (userRole == 'SELLER') ...[
              _buildSectionTitle(context, 'Seller'),
              _buildTile(context, icon: Icons.storefront_outlined, label: 'Seller Dashboard', route: '/dashboard/seller'),
            ],

            const Divider(height: 30, thickness: 1),

            // Theme switcher
            SwitchListTile(
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: color.primary,
              ),
              title: Text('Dark Mode', style: textTheme.bodyMedium),
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: color.primary,
            ),

            const Divider(height: 30, thickness: 1),

            ListTile(
              leading: CircleAvatar(
                backgroundColor: color.primary.withOpacity(0.15),
                child: Icon(
                  authProvider.isAuthenticated ? Icons.logout : Icons.login,
                  color: color.primary,
                ),
              ),
              title: Text(
                authProvider.isAuthenticated ? 'Logout' : 'Login',
                style: textTheme.bodyMedium?.copyWith(color: color.onSurface),
              ),
              onTap: () async {
                Navigator.pop(context);
                if (authProvider.isAuthenticated) {
                  await authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, {required IconData icon, required String label, required String route}) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.primary.withOpacity(0.15),
        child: Icon(icon, color: color.primary),
      ),
      title: Text(label, style: textTheme.bodyMedium),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        title,
        style: textTheme.labelLarge?.copyWith(
          color: color.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

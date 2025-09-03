import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '/theme_provider.dart'; // Import ThemeProvider

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.user;
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // If user is buyer, redirect to items
    if (user?.role == 'BUYER') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/dashboard/buyer');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      extendBodyBehindAppBar: true, // Background image behind app bar
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back arrow
        title: const Text('Dashboard'),
        backgroundColor: color.primary.withOpacity(0.8),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Switch Theme',
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with opacity
          Opacity(
            opacity: 0.15,
            child: Image.asset(
              'assets/images/dashboard_bg.jpg', // Put your image in assets/images/
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: user == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_off_outlined, size: 60, color: color.error),
                        const SizedBox(height: 16),
                        Text('You are not logged in.', style: textTheme.titleMedium),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: const Text('Login'),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.account_circle_outlined, size: 60, color: color.primary),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome ${user.name}',
                          style: textTheme.headlineSmall?.copyWith(color: color.onSurface),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            authProvider.getDashboardRoute(),
                          ),
                          child: Text('Go to ${user.role} Dashboard'),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

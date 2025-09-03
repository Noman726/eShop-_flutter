import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.user != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ACE-thetic'),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLoggedIn) ...[
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Register'),
              ),
              const SizedBox(height: 24),
            ],
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/items'),
              child: const Text('Browse Items'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              child: const Text('About'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/contact'),
              child: const Text('Contact'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/faq'),
              child: const Text('FAQ'),
            ),
            if (isLoggedIn) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  authProvider.getDashboardRoute(),
                ),
                child: const Text('Dashboard'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

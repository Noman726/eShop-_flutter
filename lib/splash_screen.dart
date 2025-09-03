import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _checkAuthStatus();
  }

  void _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // await authProvider.checkAuthStatus(); // Uncomment if you implement session persistence

    if (authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/items');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: color.primary.withOpacity(0.15),
                child: Icon(
                  Icons.shopping_bag_outlined, // Changed icon
                  size: 50,
                  color: color.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ACE-thetic',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.primary,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(color: color.primary),
          ],
        ),
      ),
    );
  }
}

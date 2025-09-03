import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../providers/auth_provider.dart';
import '../../widgets/common.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false; // Add loading state

  Future<void> _login() async {
    // Clear previous errors and show loading
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // Basic validation
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email';
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your password';
        _isLoading = false;
      });
      return;
    }

    try {
      // BYPASS MODE: Skip API call and directly simulate successful login
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

      // Use the new simulateLogin method that properly notifies listeners
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.simulateLogin(_emailController.text.trim());

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/items');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Login failed. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color.surface, // Fixed deprecated background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: size.width > 500 ? 420 : double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // Fixed deprecated withOpacity
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: color.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log in to your account',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color.onSurface.withOpacity(0.7), // Fixed deprecated withOpacity
                  ),
                ),
                const SizedBox(height: 24),
                Common.buildFormField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                Common.buildFormField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: color.error, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _login,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: color.outline.withOpacity(0.3)), // Fixed deprecated withOpacity
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: color.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

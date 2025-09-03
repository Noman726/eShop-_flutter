import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  String _role = 'BUYER';
  String? _errorMessage;
  String? _successMessage;
  bool _isLoading = false;

  final _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
  final _nameRegex = RegExp(r"^[A-Za-z][A-Za-z0-9_]{2,}$");

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _isLoading = true;
    });

    try {
      // BYPASS MODE: Skip API call and directly simulate successful registration
      await Future.delayed(Duration(milliseconds: 1000)); // Simulate network delay

      if (mounted) {
        setState(() {
          _successMessage = 'Registration successful! Redirecting to main page...';
          _isLoading = false;
        });

        // Wait a bit to show success message, then navigate directly to items page
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          // Use the new simulateRegister method that properly notifies listeners
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.simulateRegister(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _role,
          );
          Navigator.pushReplacementNamed(context, '/items');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Registration failed. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool obscure = false,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
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
            width: size.width > 500 ? 500 : double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), // Fixed deprecated withOpacity
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fill in the details below',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color.onSurface.withValues(alpha: 0.7), // Fixed deprecated withOpacity
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Name is required';
                      if (!_nameRegex.hasMatch(value))
                        return 'Invalid name format';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email is required';
                      if (!_emailRegex.hasMatch(value))
                        return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _addressController,
                    label: 'Address (Optional)',
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number (Optional)',
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 10)
                        return 'Enter a valid phone number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio (Optional)',
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _role,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      filled: true,
                      fillColor: color.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: ['BUYER', 'SELLER'].map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                    onChanged: (value) => setState(() => _role = value!),
                  ),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: color.error),
                      ),
                    ),

                  if (_successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _successMessage!,
                        style: TextStyle(color: color.primary),
                      ),
                    ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _register,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: color.outline.withValues(alpha: 0.3)), // Fixed deprecated withOpacity
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        'Already have an account? Login',
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../../providers/auth_provider.dart';

class BuyerProfileScreen extends StatefulWidget {
  @override
  _BuyerProfileScreenState createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) return;

    try {
      final profile = await _apiService.getUserById(user.id);
      setState(() {
        _nameController.text = profile.name;
        _emailController.text = profile.email;
        _addressController.text = profile.address ?? '';
        _phoneController.text = profile.phoneNumber ?? '';
        _bioController.text = profile.bio ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Update'),
        content: const Text('Are you sure you want to update your profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Update'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _updateProfile();
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline,
                  size: 60, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              const Text(
                'Profile Updated!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your profile has been successfully updated.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) return;

    try {
      final userDTO = UpdateUserDTO(
        name: _nameController.text,
        email: _emailController.text,
        address: _addressController.text.isEmpty
            ? null
            : _addressController.text,
        phoneNumber: _phoneController.text.isEmpty
            ? null
            : _phoneController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
      );
      await _apiService.updateUser(user.id, userDTO);
      await Provider.of<AuthProvider>(context, listen: false).refreshToken();
      setState(() => _errorMessage = null);
      await _showSuccessDialog();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final theme = Theme.of(context);

    if (user?.role != 'BUYER') {
      return const Scaffold(
        body: Center(child: Text('Access Denied')),
      );
    }

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Edit Profile',
                                style: theme.textTheme.headlineSmall,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _nameController,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address (Optional)',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number (Optional)',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _bioController,
                              decoration: const InputDecoration(
                                labelText: 'Bio (Optional)',
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 24),
                            if (_errorMessage != null)
                              Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _showConfirmationDialog,
                                icon: const Icon(Icons.save_alt_rounded),
                                label: const Text('Save Changes'),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

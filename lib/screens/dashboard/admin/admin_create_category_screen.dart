import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../services/api_service.dart';

class AdminCreateCategoryScreen extends StatefulWidget {
  @override
  State<AdminCreateCategoryScreen> createState() =>
      _AdminCreateCategoryScreenState();
}

class _AdminCreateCategoryScreenState extends State<AdminCreateCategoryScreen> {
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _createCategory() async {
    setState(() => _isLoading = true);
    try {
      final categoryDTO = CreateCategoryDTO(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        isActive: _isActive,
      );
      await _apiService.createCategory(categoryDTO);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Category')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.category_outlined,
                    size: 64, color: color.primary.withOpacity(0.6)),
                const SizedBox(height: 24),
                Text(
                  'Add a New Category',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'Enter category name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Optional description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val ?? true),
                  title: const Text('Active'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: color.error),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _createCategory,
                  icon: const Icon(Icons.add),
                  label: Text(_isLoading ? 'Creating...' : 'Create Category'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../models/item.dart';
import '../../../models/category.dart';
import '../../../services/api_service.dart';
import '../../../providers/auth_provider.dart';

class SellerCreateItemScreen extends StatefulWidget {
  const SellerCreateItemScreen({super.key});

  @override
  State<SellerCreateItemScreen> createState() => _SellerCreateItemScreenState();
}

class _SellerCreateItemScreenState extends State<SellerCreateItemScreen> {
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startingBidController = TextEditingController();
  final _buyNowPriceController = TextEditingController();
  String? _categoryId;
  List<String> _filePaths = [];
  List<CategoryResponseDTO> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _apiService.getCategories(isActive: true);
      setState(() {
        _categories = categories;
        _categoryId = categories.isNotEmpty ? categories[0].id : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null && result.paths.isNotEmpty) {
      final pickedPaths = result.paths.whereType<String>().toList();
      setState(() => _filePaths = pickedPaths);
    } else {
      setState(() => _filePaths = []);
    }
  }

  Future<void> _createItem() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null || _categoryId == null) return;

    try {
      final itemDTO = CreateItemDTO(
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        startingBid: double.parse(_startingBidController.text),
        buyNowPrice: double.parse(_buyNowPriceController.text),
        userId: user.id,
        categoryId: _categoryId!,
      );

      await _apiService.createItem(itemDTO, _filePaths);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item created successfully.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
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
    final color = theme.colorScheme;

    if (user?.role != 'SELLER') {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Item')),
        body: const Center(child: Text('Access Denied')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Item')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(_nameController, 'Item Name'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _descriptionController,
                    'Description (Optional)',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _startingBidController,
                    'Starting Bid',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _buyNowPriceController,
                    'Buy Now Price',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _categoryId,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _categoryId = value),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Upload Images",
                    style: theme.textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _filePaths
                        .map(
                          (path) => Chip(
                            label: Text(path.split('/').last),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                _filePaths.remove(path);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickFiles,
                    icon: const Icon(Icons.upload),
                    label: const Text('Choose Images'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.primary,
                      foregroundColor: color.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: color.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _createItem,
                      style: FilledButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Item',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}

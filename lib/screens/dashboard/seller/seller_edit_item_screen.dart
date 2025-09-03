// Same imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../models/item.dart';
import '../../../models/category.dart';
import '../../../services/api_service.dart';
import '../../../providers/auth_provider.dart';

class SellerEditItemScreen extends StatefulWidget {
  final String itemId;
  const SellerEditItemScreen({required this.itemId});

  @override
  _SellerEditItemScreenState createState() => _SellerEditItemScreenState();
}

class _SellerEditItemScreenState extends State<SellerEditItemScreen> {
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
    _fetchItem();
    _fetchCategories();
  }

  Future<void> _fetchItem() async {
    try {
      final item = await _apiService.getItemById(widget.itemId);
      setState(() {
        _nameController.text = item.name;
        _descriptionController.text = item.description ?? '';
        _startingBidController.text = item.startingBid.toString();
        _buyNowPriceController.text = item.buyNowPrice.toString();
        _categoryId = item.category?.id;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _apiService.getCategories(isActive: true);
      setState(() {
        _categories = categories;
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
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _filePaths = result.paths.whereType<String>().toList();
      });
    }
  }

  Future<void> _updateItem() async {
  try {
    final itemDTO = UpdateItemDTO(
      name: _nameController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      startingBid: _startingBidController.text.isEmpty
          ? null
          : double.parse(_startingBidController.text),
      buyNowPrice: _buyNowPriceController.text.isEmpty
          ? null
          : double.parse(_buyNowPriceController.text),
      categoryId: _categoryId,
    );

    await _apiService.updateItem(widget.itemId, itemDTO, _filePaths);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item updated successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pop(context); // Navigate back after showing message
  } catch (e) {
    setState(() => _errorMessage = e.toString());
  }
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final user = Provider.of<AuthProvider>(context).user;

    if (user?.role != 'SELLER') {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Item')),
        body: const Center(child: Text('Access Denied')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description (Optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _startingBidController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Starting Bid',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _buyNowPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Buy Now Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                        onChanged: (value) =>
                            setState(() => _categoryId = value),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: Text('Pick Images (${_filePaths.length} selected)'),
                        onPressed: _pickFiles,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: color.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: color.error),
                          ),
                        ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _updateItem,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Update Item',
                            style: TextStyle(fontSize: 16),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/item.dart';
import '../../../services/api_service.dart';
import '../../../providers/auth_provider.dart';

class AdminItemsScreen extends StatefulWidget {
  @override
  State<AdminItemsScreen> createState() => _AdminItemsScreenState();
}

class _AdminItemsScreenState extends State<AdminItemsScreen> {
  final ApiService _apiService = ApiService();
  List<ItemResponseDTO> _items = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final items = await _apiService.getItems();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      await _apiService.deleteItem(itemId);
      _fetchItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    if (user?.role != 'ADMIN') {
      return Scaffold(
        appBar: AppBar(title: const Text('Manage Items')),
        body: const Center(
          child: Text(
            'Access Denied',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Items')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchItems,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final imageUrl = item.images != null && item.images!.isNotEmpty
                          ? item.images![0].url
                          : 'https://via.placeholder.com/150';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Starting Bid: \$${item.startingBid.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(color: color.primary),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: color.error,
                            tooltip: 'Delete Item',
                            onPressed: () => _deleteItem(item.id),
                          ),
                          onTap: () =>{},
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

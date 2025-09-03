import 'package:flutter/material.dart';
import '../../models/item.dart';
import '../../models/user.dart';
import '../../models/category.dart';
import '../../services/api_service.dart';
import '../../services/mock_data_service.dart';

class ItemsScreen extends StatefulWidget {
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ApiService _apiService = ApiService();
  List<ItemResponseDTO> _items = [];
  bool _isLoading = false; // Changed to false to skip loading
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Commented out API call to avoid authentication issues
    // _fetchItems();
    _loadMockData(); // Load mock data instead
  }

  void _loadMockData() {
    // Use centralized mock data service
    setState(() {
      _items = MockDataService.getAllItems();
      _isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ACE-thetic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality later
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Add cart functionality later
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: color.primary,
              ),
              child: Text(
                'ACE-thetic Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact'),
              onTap: () => Navigator.pushNamed(context, '/contact'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: color.error),
                      SizedBox(height: 16),
                      Text('Unable to load products', style: theme.textTheme.headlineSmall),
                      SizedBox(height: 8),
                      Text('Please check your connection and try again'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchItems,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Welcome to ACE-thetic!',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: color.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your marketplace for buying and selling items',
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          Card(
                            margin: EdgeInsets.symmetric(horizontal: 32),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    'App Features:',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  _buildFeature(Icons.shopping_cart, 'Browse Products'),
                                  _buildFeature(Icons.sell, 'Sell Your Items'),
                                  _buildFeature(Icons.account_circle, 'User Profiles'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(context, '/login'),
                            icon: Icon(Icons.login),
                            label: Text('Login to Get Started'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        final imageUrl = item.images != null && item.images!.isNotEmpty
                            ? item.images!.first.url
                            : 'https://via.placeholder.com/150';

                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/items/:id',
                            arguments: item.id,
                          ),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    imageUrl,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Price: \$${item.buyNowPrice.toStringAsFixed(2)}',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: color.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.category?.name ?? 'No Category'} • ${item.user?.name}',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: color.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to create new items
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Create item feature - Login required')),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Item',
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/item.dart';
import '../../../services/api_service.dart';
import '../../../providers/auth_provider.dart';

class BuyerItemsScreen extends StatefulWidget {
  const BuyerItemsScreen({super.key});

  @override
  _BuyerItemsScreenState createState() => _BuyerItemsScreenState();
}

class _BuyerItemsScreenState extends State<BuyerItemsScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<ItemResponseDTO> _items = [];
  List<ItemResponseDTO> _filteredItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  double _minPrice = 0;
  double _maxPrice = 10000;
  RangeValues _selectedRange = const RangeValues(0, 10000);
  String _selectedSort = 'name';

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    try {
      final items = await _apiService.getItems();
      final prices = items.map((e) => e.startingBid).toList();
      final minPrice = prices.reduce((a, b) => a < b ? a : b);
      final maxPrice = prices.reduce((a, b) => a > b ? a : b);

      setState(() {
        _items = items;
        _filteredItems = items;
        _minPrice = minPrice;
        _maxPrice = maxPrice;
        _selectedRange = RangeValues(minPrice, maxPrice);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();
    List<ItemResponseDTO> results = _items.where((item) {
      final matchesName = item.name.toLowerCase().contains(query);
      final inPriceRange = item.startingBid >= _selectedRange.start &&
          item.startingBid <= _selectedRange.end;
      return matchesName && inPriceRange;
    }).toList();

    if (_selectedSort == 'name') {
      results.sort((a, b) => a.name.compareTo(b.name));
    } else if (_selectedSort == 'low') {
      results.sort((a, b) => a.startingBid.compareTo(b.startingBid));
    } else if (_selectedSort == 'high') {
      results.sort((a, b) => b.startingBid.compareTo(a.startingBid));
    }

    setState(() {
      _filteredItems = results;
    });
  }

  String getFullImageUrl(String url) {
    return url.replaceFirst("http://localhost:8080", ApiService.base);
  }

List<ItemResponseDTO> getRecentlyAddedItems() {
  final sorted = List<ItemResponseDTO>.from(_filteredItems)
    ..sort((a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
  return sorted.take(2).toList();
}

  List<ItemResponseDTO> getPopularItems() => _filteredItems;

  Widget buildShimmer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFilterBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search items...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('Filter by Price: \$${_selectedRange.start.toStringAsFixed(0)} - \$${_selectedRange.end.toStringAsFixed(0)}'),
          RangeSlider(
            values: _selectedRange,
            min: _minPrice,
            max: _maxPrice,
            divisions: 100,
            labels: RangeLabels(
              _selectedRange.start.toStringAsFixed(0),
              _selectedRange.end.toStringAsFixed(0),
            ),
            onChanged: (range) {
              setState(() => _selectedRange = range);
              _applyFilter();
            },
          ),
          Row(
            children: [
              const Text("Sort by: "),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedSort,
                items: const [
                  DropdownMenuItem(value: 'name', child: Text("Name (A–Z)")),
                  DropdownMenuItem(value: 'low', child: Text("Price Low → High")),
                  DropdownMenuItem(value: 'high', child: Text("Price High → Low")),
                ],
                onChanged: (value) {
                  setState(() => _selectedSort = value!);
                  _applyFilter();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<ItemResponseDTO> items, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          items.isEmpty
              ? const Text('No items available.')
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final imageUrl = item.images?.isNotEmpty == true ? item.images!.first.url : null;
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      color: theme.cardColor,
                      shadowColor: theme.brightness == Brightness.dark
                          ? Colors.white24
                          : Colors.black26,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                            child: imageUrl != null
                                ? Image.network(
                                    getFullImageUrl(imageUrl),
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 120,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                                  ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.name,
                                    style: theme.textTheme.titleSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Starting: \$${item.startingBid.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/items/:id',
                                          arguments: item.id,
                                        );
                                      },
                                      icon: const Icon(Icons.explore, size: 16),
                                      label: const Text('Explore'),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(10, 30),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final showAppBar = user?.role != 'BUYER';

    return Scaffold(
      appBar: showAppBar ? AppBar(title: const Text('Browse Items')) : null,
      body: Stack(
        children: [
          // Background Image
          Opacity(
            opacity: isDark ? 0.08 : 0.12,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/dashboard_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Foreground content
          _isLoading
              ? buildShimmer()
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          buildFilterBar(theme),
                          const SizedBox(height: 16),
                          buildSection("Recently Added", getRecentlyAddedItems(), theme),
                          buildSection("Popular Items", getPopularItems(), theme),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}

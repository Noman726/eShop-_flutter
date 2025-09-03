import '../models/item.dart';
import '../models/user.dart';
import '../models/category.dart';

class MockDataService {
  static final Map<String, ItemResponseDTO> _mockItems = {
    '1': ItemResponseDTO(
      id: '1',
      name: 'Designer Leather Jacket',
      description: 'Premium black leather jacket from a luxury brand. Made from genuine Italian leather with premium stitching and attention to detail. This jacket has been barely worn and is in excellent condition. Perfect for casual outings or semi-formal events. Features include:\n\n• Genuine Italian leather construction\n• Premium YKK zippers\n• Quilted lining for comfort\n• Multiple pockets for convenience\n• Classic design that never goes out of style\n\nSize: Medium (fits true to size)\nCondition: Like new\nOriginally purchased for \$350',
      startingBid: 80.0,
      buyNowPrice: 200.0,
      user: UserResponseDTO(
        id: 'user1',
        name: 'Fashion Seller',
        email: 'fashion@example.com',
        role: 'SELLER',
      ),
      category: CategoryResponseDTO(
        id: 'cat1',
        name: 'Outerwear',
        description: 'Jackets, coats, and outerwear',
        isActive: true,
      ),
      images: [
        ItemImageEntity(id: 'img1', url: 'https://via.placeholder.com/400x300/2C3E50/FFFFFF?text=Leather+Jacket+Front'),
        ItemImageEntity(id: 'img2', url: 'https://via.placeholder.com/400x300/34495E/FFFFFF?text=Leather+Jacket+Back'),
        ItemImageEntity(id: 'img3', url: 'https://via.placeholder.com/400x300/2C3E50/FFFFFF?text=Detail+View'),
      ],
    ),
    '2': ItemResponseDTO(
      id: '2',
      name: 'Vintage Denim Jeans',
      description: 'Classic blue denim jeans in excellent condition. These vintage jeans have the perfect worn-in look without any damage. Made from high-quality denim that gets better with age.\n\n• 100% cotton denim\n• Classic straight leg cut\n• Vintage wash and fading\n• No holes or damage\n• Authentic vintage piece from the 90s\n\nSize: 32/34 (W32 L34)\nCondition: Excellent vintage condition\nPerfect for collectors or everyday wear',
      startingBid: 30.0,
      buyNowPrice: 80.0,
      user: UserResponseDTO(
        id: 'user2',
        name: 'Vintage Store',
        email: 'vintage@example.com',
        role: 'SELLER',
      ),
      category: CategoryResponseDTO(
        id: 'cat2',
        name: 'Pants',
        description: 'Jeans, trousers, and pants',
        isActive: true,
      ),
      images: [
        ItemImageEntity(id: 'img1', url: 'https://via.placeholder.com/400x300/4A90E2/FFFFFF?text=Denim+Jeans+Front'),
        ItemImageEntity(id: 'img2', url: 'https://via.placeholder.com/400x300/5DADE2/FFFFFF?text=Denim+Jeans+Side'),
      ],
    ),
    '3': ItemResponseDTO(
      id: '3',
      name: 'Silk Evening Dress',
      description: 'Elegant red silk evening dress perfect for special occasions. This stunning dress features a flowing silhouette and luxurious silk fabric that drapes beautifully.\n\n• 100% pure silk fabric\n• Elegant flowing design\n• Perfect for formal events\n• Dry clean only\n• Designer piece\n\nSize: Small (US 4-6)\nCondition: Excellent\nWorn only once for a special event',
      startingBid: 120.0,
      buyNowPrice: 300.0,
      user: UserResponseDTO(
        id: 'user3',
        name: 'Elegant Boutique',
        email: 'boutique@example.com',
        role: 'SELLER',
      ),
      category: CategoryResponseDTO(
        id: 'cat3',
        name: 'Dresses',
        description: 'Formal and casual dresses',
        isActive: true,
      ),
      images: [
        ItemImageEntity(id: 'img1', url: 'https://via.placeholder.com/400x300/E74C3C/FFFFFF?text=Evening+Dress'),
        ItemImageEntity(id: 'img2', url: 'https://via.placeholder.com/400x300/C0392B/FFFFFF?text=Dress+Detail'),
      ],
    ),
    '4': ItemResponseDTO(
      id: '4',
      name: 'Cotton T-Shirt',
      description: 'Comfortable white cotton t-shirt. Brand new with tags, made from 100% organic cotton for ultimate comfort and breathability.\n\n• 100% organic cotton\n• Pre-shrunk fabric\n• Comfortable regular fit\n• Machine washable\n• Brand new with tags\n\nSize: Large\nCondition: Brand new\nPerfect for casual wear or layering',
      startingBid: 15.0,
      buyNowPrice: 35.0,
      user: UserResponseDTO(
        id: 'user4',
        name: 'Basic Wear',
        email: 'basic@example.com',
        role: 'SELLER',
      ),
      category: CategoryResponseDTO(
        id: 'cat4',
        name: 'Shirts',
        description: 'T-shirts and casual wear',
        isActive: true,
      ),
      images: [
        ItemImageEntity(id: 'img1', url: 'https://via.placeholder.com/400x300/95A5A6/FFFFFF?text=Cotton+T-Shirt'),
      ],
    ),
  };

  /// Get all items
  static List<ItemResponseDTO> getAllItems() {
    return _mockItems.values.toList();
  }

  /// Get item by ID
  static ItemResponseDTO? getItemById(String itemId) {
    return _mockItems[itemId];
  }
}

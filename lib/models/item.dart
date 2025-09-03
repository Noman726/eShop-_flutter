import 'category.dart';
import 'user.dart';

class ItemResponseDTO {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String? description;
  final double startingBid;
  final double buyNowPrice;
  final UserResponseDTO? user;
  final CategoryResponseDTO? category;
  final List<ItemImageEntity>? images;

  ItemResponseDTO({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.name,
    this.description,
    required this.startingBid,
    required this.buyNowPrice,
    this.user,
    this.category,
    this.images,
  });

  factory ItemResponseDTO.fromJson(Map<String, dynamic> json) {
    return ItemResponseDTO(
      id: json['id'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      name: json['name'],
      description: json['description'],
      startingBid: json['startingBid'].toDouble(),
      buyNowPrice: json['buyNowPrice'].toDouble(),
      user: json['user'] != null
          ? UserResponseDTO.fromJson(json['user'])
          : null,
      category: json['category'] != null
          ? CategoryResponseDTO.fromJson(json['category'])
          : null,
      images: json['images'] != null
          ? (json['images'] as List)
                .map((i) => ItemImageEntity.fromJson(i))
                .toList()
          : null,
    );
  }
}

class ItemImageEntity {
  final String id;
  final String url;

  ItemImageEntity({required this.id, required this.url});

  factory ItemImageEntity.fromJson(Map<String, dynamic> json) {
    return ItemImageEntity(id: json['id'], url: json['url']);
  }
}

class CreateItemDTO {
  final String name;
  final String? description;
  final double startingBid;
  final double buyNowPrice;
  final String userId;
  final String categoryId;

  CreateItemDTO({
    required this.name,
    this.description,
    required this.startingBid,
    required this.buyNowPrice,
    required this.userId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startingBid': startingBid,
      'buyNowPrice': buyNowPrice,
      'userId': userId,
      'categoryId': categoryId,
    };
  }
}

class UpdateItemDTO {
  final String? name;
  final String? description;
  final double? startingBid;
  final double? buyNowPrice;
  final String? categoryId;

  UpdateItemDTO({
    this.name,
    this.description,
    this.startingBid,
    this.buyNowPrice,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startingBid': startingBid,
      'buyNowPrice': buyNowPrice,
      'categoryId': categoryId,
    }..removeWhere((key, value) => value == null);
  }
}

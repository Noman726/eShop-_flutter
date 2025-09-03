import 'package:intl/intl.dart';
import 'user.dart';
import 'item.dart';

class ReviewResponseDTO {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final UserResponseDTO? user;
  final ItemResponseDTO? item;
  final int rating;
  final String? comment;

  ReviewResponseDTO({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.item,
    required this.rating,
    this.comment,
  });

  factory ReviewResponseDTO.fromJson(Map<String, dynamic> json) {
    return ReviewResponseDTO(
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
      user: json['user'] != null
          ? UserResponseDTO.fromJson(json['user'])
          : null,
      item: json['item'] != null
          ? ItemResponseDTO.fromJson(json['item'])
          : null,
      rating: json['rating'],
      comment: json['comment'],
    );
  }
}

class CreateReviewDTO {
  final String userId;
  final String itemId;
  final int rating;
  final String? comment;

  CreateReviewDTO({
    required this.userId,
    required this.itemId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'itemId': itemId,
      'rating': rating,
      'comment': comment,
    };
  }
}

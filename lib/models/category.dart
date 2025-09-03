class CategoryResponseDTO {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String? description;
  final bool isActive;

  CategoryResponseDTO({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.name,
    this.description,
    required this.isActive,
  });

  factory CategoryResponseDTO.fromJson(Map<String, dynamic> json) {
    return CategoryResponseDTO(
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
      isActive: json['isActive'],
    );
  }
}

class CreateCategoryDTO {
  final String name;
  final String? description;
  final bool isActive;

  CreateCategoryDTO({
    required this.name,
    this.description,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'isActive': isActive};
  }
}

class UpdateCategoryDTO {
  final String? name;
  final String? description;
  final bool? isActive;

  UpdateCategoryDTO({this.name, this.description, this.isActive});

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'isActive': isActive};
  }
}

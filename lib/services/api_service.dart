import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../models/item.dart';
import '../models/category.dart';
import '../models/review.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Use localhost for development - change this to your actual server URL
  static const String base = 'http://localhost:8080';
  static const String baseUrl = '$base/api/v1';

  final storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth
  Future<AuthResponseDTO> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final resBody = jsonDecode(response.body);
    if (resBody["user"] != null) {
      final authResponse = AuthResponseDTO.fromJson(resBody);
      await storage.write(key: 'accessToken', value: authResponse.accessToken);
      await storage.write(
        key: 'refreshToken',
        value: authResponse.refreshToken,
      );
      return authResponse;
    }
    throw Exception('Failed to login: ${response.body}');
  }

  Future<AuthResponseDTO> register(CreateUserDTO userDTO) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userDTO.toJson()),
    );

    final resBody = jsonDecode(response.body);
    if (resBody["user"] != null) {
      final authResponse = AuthResponseDTO.fromJson(resBody);
      await storage.write(key: 'accessToken', value: authResponse.accessToken);
      await storage.write(
        key: 'refreshToken',
        value: authResponse.refreshToken,
      );
      return authResponse;
    }
    throw Exception('Failed to register: ${response.body}');
  }

  Future<AuthResponseDTO> refreshToken() async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh-token'),
      headers: await getHeaders(),
    );

    final resBody = jsonDecode(response.body);
    if (resBody["accessToken"] != null) {
      final authResponse = AuthResponseDTO.fromJson(resBody);
      await storage.write(key: 'accessToken', value: authResponse.accessToken);
      await storage.write(
        key: 'refreshToken',
        value: authResponse.refreshToken,
      );
      return authResponse;
    }
    throw Exception('Failed to refresh token: ${response.body}');
  }

  // Users
  Future<List<UserResponseDTO>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: await getHeaders(),
    );
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty && data.every((item) => item["id"] != null)) {
      return data.map((json) => UserResponseDTO.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch users: ${response.body}');
  }

  Future<UserResponseDTO> getUserById(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: await getHeaders(),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["id"] != null) {
      return UserResponseDTO.fromJson(resBody);
    }
    throw Exception('Failed to fetch user: ${response.body}');
  }

  Future<UserResponseDTO> updateUser(
    String userId,
    UpdateUserDTO userDTO,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: await getHeaders(),
      body: jsonEncode(userDTO.toJson()),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["id"] != null) {
      return UserResponseDTO.fromJson(resBody);
    }
    throw Exception('Failed to update user: ${response.body}');
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
      headers: await getHeaders(),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["message"] == "success" || resBody.isEmpty) {
      return;
    }
    throw Exception('Failed to delete user: ${response.body}');
  }

  // Items
  Future<List<ItemResponseDTO>> getItems({
    String? userId,
  }) async {
    final queryParams = {
      if (userId != null) 'userId': userId,
    };
    final uri = Uri.parse(
      '$baseUrl/items',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: await getHeaders());
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty && data.every((item) => item["id"] != null)) {
      return data.map((json) => ItemResponseDTO.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch items: ${response.body}');
  }

  Future<ItemResponseDTO> getItemById(String itemId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/items/$itemId'),
      headers: await getHeaders(),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["id"] != null) {
      return ItemResponseDTO.fromJson(resBody);
    }
    throw Exception('Failed to fetch item: ${response.body}');
  }

  Future<ItemResponseDTO> createItem(
    CreateItemDTO itemDTO,
    List<String> filePaths,
  ) async {
    final uri = Uri.parse('$baseUrl/items');
    final request = http.MultipartRequest('POST', uri);

    // ✅ Do NOT set Content-Type manually here!
    final headers = await getHeaders();
    headers.remove('Content-Type'); // Remove if accidentally set
    request.headers.addAll(headers);

    // ✅ Add form fields (match DTO fields exactly)
    request.fields['name'] = itemDTO.name;
    if (itemDTO.description != null) {
      request.fields['description'] = itemDTO.description!;
    }
    request.fields['startingBid'] = itemDTO.startingBid.toString();
    request.fields['buyNowPrice'] = itemDTO.buyNowPrice.toString();
    request.fields['userId'] = itemDTO.userId;
    request.fields['categoryId'] = itemDTO.categoryId;

    // ✅ Add image files
    for (var filePath in filePaths) {
      final mimeType = lookupMimeType(filePath);
      final file = await http.MultipartFile.fromPath(
        'files',
        filePath,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );
      request.files.add(file);
    }

    // ✅ Debug print
    print("Sending fields: ${request.fields}");
    print("Sending files: ${filePaths.length}");

    // Send the request
    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    // ✅ Response logging
    print("Status Code: ${streamedResponse.statusCode}");
    print("Response Body: $responseBody");

    // ✅ Handle response
    if (streamedResponse.statusCode == 201) {
      final json = jsonDecode(responseBody);
      return ItemResponseDTO.fromJson(json);
    } else {
      throw Exception("Failed to create item: $responseBody");
    }
  }

  Future<ItemResponseDTO> updateItem(
    String itemId,
    UpdateItemDTO itemDTO,
    List<String> filePaths,
  ) async {
    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse('$baseUrl/items/$itemId'),
    );
    request.headers.addAll(await getHeaders());
    request.fields['updateItemDTO'] = jsonEncode(itemDTO.toJson());
    for (var filePath in filePaths) {
      request.files.add(await http.MultipartFile.fromPath('files', filePath));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final resBody = jsonDecode(responseBody);
    if (resBody["id"] != null) {
      return ItemResponseDTO.fromJson(resBody);
    }
    throw Exception('Failed to update item: $responseBody');
  }

  Future<void> deleteItem(String itemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/items/$itemId'),
      headers: await getHeaders(),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["message"] == "success" || resBody.isEmpty) {
      return;
    }
    throw Exception('Failed to delete item: ${response.body}');
  }

  // Categories
  Future<List<CategoryResponseDTO>> getCategories({bool? isActive}) async {
    final queryParams = {if (isActive != null) 'isActive': isActive.toString()};
    final uri = Uri.parse(
      '$baseUrl/categories',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: await getHeaders());
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty && data.every((item) => item["id"] != null)) {
      return data.map((json) => CategoryResponseDTO.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch categories: ${response.body}');
  }

  Future<CategoryResponseDTO> getCategoryById(String categoryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories/$categoryId'),
      headers: await getHeaders(),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["id"] != null) {
      return CategoryResponseDTO.fromJson(resBody);
    }
    throw Exception('Failed to fetch category: ${response.body}');
  }

  Future<CategoryResponseDTO> createCategory(
    CreateCategoryDTO categoryDTO,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: await getHeaders(),
      body: jsonEncode(categoryDTO.toJson()),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["id"] != null) {
      return CategoryResponseDTO.fromJson(resBody);
    }
    throw Exception('Failed to create category: ${response.body}');
  }

  Future<CategoryResponseDTO> updateCategory(
    String categoryId,
    UpdateCategoryDTO categoryDTO,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/categories/$categoryId'),
      headers: await getHeaders(),
      body: jsonEncode(categoryDTO.toJson()),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["id"] != null) {
      return CategoryResponseDTO.fromJson(resBody);
    }
    throw Exception('Failed to update category: ${response.body}');
  }

  Future<void> deleteCategory(String categoryId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$categoryId'),
      headers: await getHeaders(),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["message"] == "success" || resBody.isEmpty) {
      return;
    }
    throw Exception('Failed to delete category: ${response.body}');
  }

  // Reviews
  Future<List<ReviewResponseDTO>> getReviews({String? userId}) async {
    final queryParams = {if (userId != null) 'userId': userId};
    final uri = Uri.parse(
      '$baseUrl/reviews',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: await getHeaders());
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty && data.every((item) => item["id"] != null)) {
      return data.map((json) => ReviewResponseDTO.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch reviews: ${response.body}');
  }

  Future<ReviewResponseDTO> createReview(CreateReviewDTO reviewDTO) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: await getHeaders(),
      body: jsonEncode(reviewDTO.toJson()),
    );
    final resBody = jsonDecode(response.body);
    if (resBody["id"] != null) {
      return ReviewResponseDTO.fromJson(resBody);
    }
    throw Exception('Failed to create review: ${response.body}');
  }
}

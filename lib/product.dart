import 'dart:collection';
import 'dart:convert';

class Product {
  final String name;
  final List<String> categories;
  bool isFavorite;
  final HashMap<String, String> prices; // Указываем типы для HashMap
  final String currency;
  final String image;
  final String description;

  Product({
    required this.name,
    required this.categories,
    required this.isFavorite,
    required this.prices,
    required this.currency,
    required this.image,
    this.description = "",
  });

  // Десериализация из JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    // Проверяем обязательные поля и приводим типы
    final name = json['name'] as String? ?? '';
    final categories = (json['categories'] as List<dynamic>?)?.cast<String>() ?? [];
    final isFavorite = json['is_favorite'] as bool? ?? false;
    final pricesMap = (json['prices'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, value.toString()),
    ) ?? {};
    final currency = json['currency'] as String? ?? '';
    final image = json['image'] as String? ?? '';
    final description = json['description'] as String? ?? '';

    return Product(
      name: name,
      categories: categories,
      isFavorite: isFavorite,
      prices: HashMap<String, String>.from(pricesMap),
      currency: currency,
      image: image,
      description: description,
    );
  }

  // Сериализация в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categories': categories,
      'is_favorite': isFavorite,
      'prices': prices, // HashMap автоматически сериализуется как Map
      'currency': currency,
      'image': image,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Product(name: $name, categories: $categories, isFavorite: $isFavorite, prices: $prices, currency: $currency, image: $image, description: $description)';
  }
}

List<Product> parseProducts(String jsonString) {
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  final List<dynamic> jsonList = jsonData['products'] ?? [];

  return jsonList.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
}

class CartItem {
  final Product product;
  int quantity;
  String size;
  List<String>? addedSyrups;

  CartItem({
    required this.product,
    required this.size,
    required this.quantity,
    this.addedSyrups,
  });
}
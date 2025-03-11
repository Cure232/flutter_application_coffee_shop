import 'dart:convert';

class Product {
  final String name;
  final List<String> categories;
  final bool isFavorite;
  final int price;
  final String currency;
  final String image;

  Product({
    required this.name,
    required this.categories,
    required this.isFavorite,
    required this.price,
    required this.currency,
    required this.image,
  });

  // Десериализация из JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      categories: List<String>.from(json['categories']),
      isFavorite: json['is_favorite'],
      price: json['price'],
      currency: json['currency'],
      image: json['image'],
    );
  }

  // Сериализация в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categories': categories, // Сохраняем как список
      'is_favorite': isFavorite,
      'price': price,
      'currency': currency,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Product(name: $name, categories: $categories, is_favorite: $isFavorite, price: $price, currency: $currency, image: $image)';
  }
}

List<Product> parseProducts(String jsonString) {
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  final List<dynamic> jsonList = jsonData['products'];

  return jsonList.map((json) => Product.fromJson(json)).toList();
}
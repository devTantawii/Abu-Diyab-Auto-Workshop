class Tire {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String country;
  final String size;
  final Product product;

  Tire({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.country,
    required this.size,
    required this.product,
  });

  factory Tire.fromJson(Map<String, dynamic> json) {
    return Tire(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: json['quentity'] ?? 0,
      country: json['country'] ?? '',
      size: json['size'] ?? '',
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quentity': quantity,
      'country': country,
      'size': size,
      'product': product.toJson(),
    };
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String slug;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.slug,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'slug': slug,
    };
  }
}

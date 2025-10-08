class BatteryResponse {
  final List<Battery> data;
  final Pagination pagination;

  BatteryResponse({
    required this.data,
    required this.pagination,
  });

  factory BatteryResponse.fromJson(Map<String, dynamic> json) {
    return BatteryResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Battery.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Battery {
  final int id;
  final String name;
  final String description;
  final String price;
  final int quantity;
  final String country;
  final String amper;
  final Product product;

  Battery({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.country,
    required this.amper,
    required this.product,
  });

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0.00',
      quantity: json['quentity'] ?? 0,
      country: json['country'] ?? '',
      amper: json['amper'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
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
      'amper': amper,
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
      id: json['id'] ?? 0,
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

class Pagination {
  final int total;
  final int count;
  final int perPage;
  final int currentPage;
  final int totalPages;
  final bool hasMorePages;

  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.hasMorePages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      count: json['count'] ?? 0,
      perPage: json['per_page'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      hasMorePages: json['has_more_pages'] ?? false,
    );
  }
}

class SearchResponse {
  final List<ProductItem> products;
  final List<ServiceItem> services;

  SearchResponse({
    required this.products,
    required this.services,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      products: (json['data']['products'] as List)
          .map((e) => ProductItem.fromJson(e))
          .toList(),
      services: (json['data']['services'] as List)
          .map((e) => ServiceItem.fromJson(e))
          .toList(),
    );
  }
}

class ProductItem {
  final int id;
  final int productId;
  final String name;
  final Product product;

  ProductItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.product,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String slug;
  final int status;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.slug,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      slug: json['slug'],
      status: json['status'],
    );
  }
}

class ServiceItem {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String slug;
  final String fees;
  final int status;

  ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.slug,
    required this.fees,
    required this.status,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      slug: json['slug'],
      fees: json['fees'],
      status: json['status'],
    );
  }
}

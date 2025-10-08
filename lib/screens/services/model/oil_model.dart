class OilProduct {
  final int id;
  final String name;
  final String description;
  final String price;
  final int quentity;
  final String viscosty;
  final int kilometer;
  final Product product;

  OilProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quentity,
    required this.viscosty,
    required this.kilometer,
    required this.product,
  });

  factory OilProduct.fromJson(Map<String, dynamic> json) {
    return OilProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      quentity: json['quentity'],
      viscosty: json['viscosty'],
      kilometer: json['kilometer'],
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quentity': quentity,
      'viscosty': viscosty,
      'kilometer': kilometer,
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
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      slug: json['slug'],
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
      total: json['total'],
      count: json['count'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      hasMorePages: json['has_more_pages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'count': count,
      'per_page': perPage,
      'current_page': currentPage,
      'total_pages': totalPages,
      'has_more_pages': hasMorePages,
    };
  }
}

class OilResponse {
  final int status;
  final String msg;
  final List<OilProduct> data;
  final Pagination pagination;

  OilResponse({
    required this.status,
    required this.msg,
    required this.data,
    required this.pagination,
  });

  factory OilResponse.fromJson(Map<String, dynamic> json) {
    return OilResponse(
      status: json['status'],
      msg: json['msg'],
      data: (json['data'] as List)
          .map((e) => OilProduct.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

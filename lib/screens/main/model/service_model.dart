class ServicesResponse {
  final int status;
  final String msg;
  final ServicesData data;

  ServicesResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? '',
      data: ServicesData.fromJson(json['data'] ?? {}),
    );
  }
}

class ServicesData {
  final List<ProductModel> products;
  final List<ServiceModel> services;

  ServicesData({
    required this.products,
    required this.services,
  });

  factory ServicesData.fromJson(Map<String, dynamic> json) {
    return ServicesData(
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e))
          .toList()
          ?? [],
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e))
          .toList()
          ?? [],
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String slug;
  final int status;
  final List<OfferModel> offer;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.slug,
    required this.status,
    required this.offer,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      slug: json['slug'] ?? '',
      status: json['status'] ?? 0,
      offer: (json['offer'] as List<dynamic>?)
          ?.map((e) => OfferModel.fromJson(e))
          .toList()
          ?? [],
    );
  }
}

class ServiceModel {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String slug;
  final String fees;
  final int status;
  final List<OfferModel> offer;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.slug,
    required this.fees,
    required this.status,
    required this.offer,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      slug: json['slug'] ?? '',
      fees: json['fees']?.toString() ?? '0',
      status: json['status'] ?? 0,
      offer: (json['offer'] as List<dynamic>?)
          ?.map((e) => OfferModel.fromJson(e))
          .toList()
          ?? [],
    );
  }
}
class OfferModel {
  final int id;
  final int productId;
  final String discount;
  final String type; // percentage or fixed
  final String expiredAt;

  OfferModel({
    required this.id,
    required this.productId,
    required this.discount,
    required this.type,
    required this.expiredAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      discount: json['discount'] ?? '',
      type: json['type'] ?? '',
      expiredAt: json['expired_at'] ?? '',
    );
  }
}

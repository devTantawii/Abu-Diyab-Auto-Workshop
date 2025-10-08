// class CarWashResponse {
//   final int status;
//   final String msg;
//   final List<CarWashing> data;
//
//   CarWashResponse({
//     required this.status,
//     required this.msg,
//     required this.data,
//   });
//
//   factory CarWashResponse.fromJson(Map<String, dynamic> json) {
//     return CarWashResponse(
//       status: json['status'],
//       msg: json['msg'],
//       data: List<CarWashing>.from(
//         json['data'].map((item) => CarWashing.fromJson(item)),
//       ),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "status": status,
//       "msg": msg,
//       "data": data.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class CarWashing {
//   final int id;
//   final int subServiceId;
//   final int? carModelId;
//   final String price;
//   final SubService subService;
//   final dynamic carModel;
//
//   CarWashing({
//     required this.id,
//     required this.subServiceId,
//     required this.carModelId,
//     required this.price,
//     required this.subService,
//     this.carModel,
//   });
//
//   factory CarWashing.fromJson(Map<String, dynamic> json) {
//     return CarWashing(
//       id: json['id'],
//       subServiceId: json['sub_service_id'],
//       carModelId: json['car_model_id'],
//       price: json['price'],
//       subService: SubService.fromJson(json['sub_service']),
//       carModel: json['car_model'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "sub_service_id": subServiceId,
//       "car_model_id": carModelId,
//       "price": price,
//       "sub_service": subService.toJson(),
//       "car_model": carModel,
//     };
//   }
// }
//
// class SubService {
//   final int id;
//   final int serviceId;
//   final String name;
//   final String description;
//   final int status;
//
//   SubService({
//     required this.id,
//     required this.serviceId,
//     required this.name,
//     required this.description,
//     required this.status,
//   });
//
//   factory SubService.fromJson(Map<String, dynamic> json) {
//     return SubService(
//       id: json['id'],
//       serviceId: json['service_id'],
//       name: json['name'],
//       description: json['description'],
//       status: json['status'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "service_id": serviceId,
//       "name": name,
//       "description": description,
//       "status": status,
//     };
//   }
// }
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
}
class CarWashService {
  final int id;
  final String name;
  final String description;
  final String price;
  final String size;
  final String type;
  final Product product;

  CarWashService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.size,
    required this.type,
    required this.product,
  });

  factory CarWashService.fromJson(Map<String, dynamic> json) {
    return CarWashService(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      size: json['size'],
      type: json['type'],
      product: Product.fromJson(json['product']),
    );
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
}
class CarWashServiceResponse {
  final int status;
  final String msg;
  final List<CarWashService> data;
  final Pagination pagination;

  CarWashServiceResponse({
    required this.status,
    required this.msg,
    required this.data,
    required this.pagination,
  });

  factory CarWashServiceResponse.fromJson(Map<String, dynamic> json) {
    return CarWashServiceResponse(
      status: json['status'],
      msg: json['msg'],
      data: (json['data'] as List)
          .map((e) => CarWashService.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

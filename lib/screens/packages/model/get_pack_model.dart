class PackageModel {
  final int id;
  final String name;
  final String title;
  final String description;
  final String price;
  final int duration;
  final String type;
  final int status;
  final List<PackageDetailModel> details;

  PackageModel({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.type,
    required this.status,
    required this.details,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      duration: json['duration'],
      type: json['type'],
      status: json['status'],
      details: (json['details'] as List)
          .map((e) => PackageDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class PackageDetailModel {
  final int id;
  final int serviceId;
  final String discount;
  final int maximumUses;
  final ServiceModel service;

  PackageDetailModel({
    required this.id,
    required this.serviceId,
    required this.discount,
    required this.maximumUses,
    required this.service,
  });

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    return PackageDetailModel(
      id: json['id'],
      serviceId: json['service_id'],
      discount: json['discount'],
      maximumUses: json['maximum_uses'],
      service: ServiceModel.fromJson(json['service']),
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

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.slug,
    required this.fees,
    required this.status,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
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

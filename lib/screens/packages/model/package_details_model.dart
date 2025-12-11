class PackageDetailsResponse {
  final int id;
  final String name;
  final String title;
  final String description;
  final String price;
  final int duration;
  final String type;
  final int status;
  final List<PackageDetailItem> details;

  PackageDetailsResponse({
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

  factory PackageDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PackageDetailsResponse(
      id: json["id"],
      name: json["name"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      duration: json["duration"],
      type: json["type"],
      status: json["status"],
      details: List<PackageDetailItem>.from(
        json["details"].map((x) => PackageDetailItem.fromJson(x)),
      ),
    );
  }
}

class PackageDetailItem {
  final int id;
  final int packageId;
  final int serviceId;
  final String discount;
  final int maximumUses;
  final Service service;

  PackageDetailItem({
    required this.id,
    required this.packageId,
    required this.serviceId,
    required this.discount,
    required this.maximumUses,
    required this.service,
  });

  factory PackageDetailItem.fromJson(Map<String, dynamic> json) {
    return PackageDetailItem(
      id: json["id"],
      packageId: json["package_id"],
      serviceId: json["service_id"],
      discount: json["discount"],
      maximumUses: json["maximum_uses"],
      service: Service.fromJson(json["service"]),
    );
  }
}

class Service {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String slug;
  final String fees;
  final int status;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.slug,
    required this.fees,
    required this.status,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      icon: json["icon"],
      slug: json["slug"],
      fees: json["fees"],
      status: json["status"],
    );
  }
}

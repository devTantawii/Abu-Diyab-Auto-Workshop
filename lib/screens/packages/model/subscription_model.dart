// models/subscription_model.dart

class SubscriptionResponse {
  final int status;
  final String msg;
  final List<Subscription> data;

  SubscriptionResponse({required this.status, required this.msg, required this.data});

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      status: json['status'],
      msg: json['msg'],
      data: (json['data'] as List).map((e) => Subscription.fromJson(e)).toList(),
    );
  }
}

class Subscription {
  final int id;
  final int userId;
  final int packageId;
  final String price;
  final DateTime expiredAt;
  final String status;
  final DateTime createdAt;
  final User user;
  final Package package;

  Subscription({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.price,
    required this.expiredAt,
    required this.status,
    required this.createdAt,
    required this.user,
    required this.package,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      packageId: json['package_id'],
      price: json['price'],
      expiredAt: DateTime.parse(json['expired_at']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      user: User.fromJson(json['user']),
      package: Package.fromJson(json['package']),
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? image;
  final String? wallet;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.image,
    this.wallet,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      wallet: json['wallet']?.toString(),
    );
  }
}

class Package {
  final int id;
  final String name;
  final String title;
  final String description;
  final String price;
  final int duration;
  final String type;
  final int status;
  final List<PackageDetail> details;

  Package({
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

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      duration: json['duration'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? 0,
      details: (json['details'] as List? ?? []).map((e) => PackageDetail.fromJson(e)).toList(),
    );
  }
}

class PackageDetail {
  final int id;
  final int packageId;
  final int serviceId;
  final String discount;
  final int maximumUses;
  final Service service;

  PackageDetail({
    required this.id,
    required this.packageId,
    required this.serviceId,
    required this.discount,
    required this.maximumUses,
    required this.service,
  });

  factory PackageDetail.fromJson(Map<String, dynamic> json) {
    return PackageDetail(
      id: json['id'],
      packageId: json['package_id'],
      serviceId: json['service_id'],
      discount: json['discount'] ?? '',
      maximumUses: json['maximum_uses'] ?? 0,
      service: Service.fromJson(json['service']),
    );
  }
}

class Service {
  final int id;
  final String name;
  final String description;
  final String? icon;
  final String slug;
  final String fees;
  final int status;

  Service({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    required this.slug,
    required this.fees,
    required this.status,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
      slug: json['slug'] ?? '',
      fees: json['fees']?.toString() ?? '',
      status: json['status'] ?? 0,
    );
  }
}

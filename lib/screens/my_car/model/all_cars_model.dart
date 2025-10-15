class Car {
  final int id;
  final int userId;
  final String licencePlate;
  final String? name;
  final String? year;
  final String? kilometer;
  final String? carCertificate;
  final CarBrand carBrand;
  final CarModel carModel;
  final String? createdAt;
  final String? updatedAt;

  Car({
    required this.id,
    required this.userId,
    required this.licencePlate,
    this.name,
    this.year,
    this.kilometer,
    this.carCertificate,
    required this.carBrand,
    required this.carModel,
    this.createdAt,
    this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      licencePlate: json['licence_plate'] ?? '',
      name: json['name'],
      year: json['year'],
      kilometer: json['kilometer'],
      carCertificate: json['car_certificate'],
      carBrand: CarBrand.fromJson(json['car_brand'] ?? {}),
      carModel: CarModel.fromJson(json['car_model'] ?? {}),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class CarBrand {
  final int id;
  final String name;
  final String? icon;

  CarBrand({
    required this.id,
    required this.name,
    this.icon,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'],
    );
  }
}

class CarModel {
  final int id;
  final String name;

  CarModel({
    required this.id,
    required this.name,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class UserNote {
  final int id;
  final String kilometer;
  final String lastMaintenance;
  final String details;
  final String remindMe;
  final String? media;
  final int daysAgo;
  final Service service;
  final UserCar userCar;
  final String createdAt;
  final String updatedAt;

  UserNote({
    required this.id,
    required this.kilometer,
    required this.lastMaintenance,
    required this.details,
    required this.remindMe,
    this.media,
    required this.daysAgo,
    required this.service,
    required this.userCar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserNote.fromJson(Map<String, dynamic> json) {
    return UserNote(
      id: json['id'],
      kilometer: json['kilometer'],
      lastMaintenance: json['last_maintenance'],
      details: json['details'],
      remindMe: json['remind_me'],
      media: json['media'],
      daysAgo: json['days_ago'],
      service: Service.fromJson(json['service']),
      userCar: UserCar.fromJson(json['user_car']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Service {
  final int id;
  final String name;
  final String icon;

  Service({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

class UserCar {
  final int id;
  final CarBrand carBrand;
  final CarModel carModel;

  UserCar({
    required this.id,
    required this.carBrand,
    required this.carModel,
  });

  factory UserCar.fromJson(Map<String, dynamic> json) {
    return UserCar(
      id: json['id'],
      carBrand: CarBrand.fromJson(json['car_brand']),
      carModel: CarModel.fromJson(json['car_model']),
    );
  }
}

class CarBrand {
  final int id;
  final String name;
  final String icon;

  CarBrand({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

class CarModel {
  final int id;
  final String name;
  final bool status;

  CarModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}

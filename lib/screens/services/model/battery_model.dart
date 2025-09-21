class Battery {
  final int id;
  final int subServiceId;
  final int carModelId;
  final String type;
  final String country;
  final String size; // بدل ampere
  final DateTime dateOfManufacture; // بدل manufactureYear
  final int warrantyPeriodMonths; // بدل warranty + warrantyUnit
  final String price;

  Battery({
    required this.id,
    required this.subServiceId,
    required this.carModelId,
    required this.type,
    required this.country,
    required this.size,
    required this.dateOfManufacture,
    required this.warrantyPeriodMonths,
    required this.price,
  });

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      id: json['id'] ?? 0,
      subServiceId: json['sub_service_id'] ?? 0,
      carModelId: json['car_model_id'] ?? 0,
      type: json['type'] ?? '',
      country: json['country'] ?? '',
      size: json['size'] ?? '',
      dateOfManufacture: DateTime.tryParse(json['date_of_manufacture'] ?? '') ?? DateTime.now(),
      warrantyPeriodMonths: json['warranty_period_months'] ?? 0,
      price: json['price'] ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_service_id': subServiceId,
      'car_model_id': carModelId,
      'type': type,
      'country': country,
      'size': size,
      'date_of_manufacture': dateOfManufacture.toIso8601String(),
      'warranty_period_months': warrantyPeriodMonths,
      'price': price,
    };
  }
}
class Service {
  final int id;
  final int serviceId;
  final String name;
  final String description;
  final int status;
  final List<Battery> batteryChanges;

  Service({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.description,
    required this.status,
    required this.batteryChanges,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 0,
      batteryChanges: (json['battery_changes'] as List<dynamic>? ?? [])
          .map((e) => Battery.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'name': name,
      'description': description,
      'status': status,
      'battery_changes': batteryChanges.map((e) => e.toJson()).toList(),
    };
  }
}

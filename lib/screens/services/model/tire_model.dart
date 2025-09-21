class Tire {
  final int id;
  final String size;
  final int price;
  final String manufactureYear;
  final int available;
  final String type;
  final String brand;
  final String country;

  Tire({
    required this.id,
    required this.size,
    required this.price,
    required this.manufactureYear,
    required this.available,
    required this.type,
    required this.brand,
    required this.country,
  });

  factory Tire.fromJson(Map<String, dynamic> json) {
    return Tire(
      id: json['id'],
      size: json['size'],
      price: int.tryParse(json['price'].toString()) ?? 0,
      // عشان JSON بيرجع string
      manufactureYear: json['date_of_manufacture'] ?? "",
      // بدل manufacture_year
      available: json['available'] ?? 1,
      // لو مش موجود نحط قيمة افتراضية
      type: json['type'] ?? "",
      brand: json['brand'] ?? "Unknown",
      // لأن JSON مافيهوش brand
      country: json['country'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'price': price,
      'manufacture_year': manufactureYear,
      'available': available,
      'type': type,
      'brand': brand,
      'country': country,
    };
  }
}

class SubTireService {
  final int id;
  final int serviceId;
  final String name;
  final String description;
  final int status;
  final List<Tire> tires;

  SubTireService({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.description,
    required this.status,
    required this.tires,
  });

  factory SubTireService.fromJson(Map<String, dynamic> json) {
    return SubTireService(
      id: json['id'],
      serviceId: json['service_id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      tires:
          (json['tires'] as List<dynamic>)
              .map((t) => Tire.fromJson(t))
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
      'tires': tires.map((t) => t.toJson()).toList(),
    };
  }
}

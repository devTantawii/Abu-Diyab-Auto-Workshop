class Car {
  final int id;
  final String licencePlate;
  final String? name;
  final String? year;
  final String? kilometer;
  final String? carCertificate;
  final Map<String, dynamic> carBrand;
  final Map<String, dynamic> carModel;

  Car({
    required this.id,
    required this.licencePlate,
    this.name,
    this.year,
    this.kilometer,
    this.carCertificate,
    required this.carBrand,
    required this.carModel,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? 0,
      licencePlate: json['licence_plate'] ?? '',
      name: json['name'],
      year: json['year'], // جاية String
      kilometer: json['kilometer'],
      carCertificate: json['car_certificate'],
      carBrand: json['car_brand'] ?? {},
      carModel: json['car_model'] ?? {},
    );
  }
}

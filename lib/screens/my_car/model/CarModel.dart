class CarModel {
  final int id;
  final int carBrandId;
  final String name;
  final bool status;

  CarModel({
    required this.id,
    required this.carBrandId,
    required this.name,
    required this.status,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      carBrandId: json['car_brand_id'],
      name: json['name'],
      status: json['status'],
    );
  }
}

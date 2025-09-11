class CarBrandModel {
  final int id;
  final String name;
  final String image;

  CarBrandModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CarBrandModel.fromJson(Map<String, dynamic> json) {
    return CarBrandModel(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      image: (json['icon'] != null && json['icon'].toString().isNotEmpty)
          ? json['icon'].toString()
          : 'assets/images/default_car.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'CarBrandModel(id: $id, name: $name, image: $image)';
  }
}

class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? image;
  final double? lat;
  final double? long;
  final num? wallet;
  final String confirmedAt;
  final String? fcm;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.image,
    this.lat,
    this.long,
    this.wallet,
    required this.confirmedAt,
    this.fcm,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}".trim(),
      phone: json['phone'] ?? '',
      image: json['image'],
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      long: json['long'] != null ? (json['long'] as num).toDouble() : null,
      wallet: json['wallet'],
      confirmedAt: json['confirmed_at'] ?? '',
      fcm: json['fcm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "image": image,
      "lat": lat,
      "long": long,
      "wallet": wallet,
      "confirmed_at": confirmedAt,
      "fcm": fcm,
    };
  }
}

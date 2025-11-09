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
  final String? referralCode;

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
    this.referralCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}".trim(),
      phone: json['phone']?.toString() ?? '',
      image: json['image'],
      lat: json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      long: json['long'] != null ? double.tryParse(json['long'].toString()) : null,
      wallet: json['wallet'] != null ? num.tryParse(json['wallet'].toString()) : null,
      confirmedAt: json['confirmed_at']?.toString() ?? '',
      fcm: json['fcm']?.toString(),
      referralCode: json['referral_code']?.toString(),
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
      "referral_code": referralCode,
    };
  }
}

class RegisterRequestModel {
  final String name;
  final String name2;
  final String phone;
  final String password;
  final String? fcm;
  final String? referral;
  final String? idNumber;

  RegisterRequestModel({
    required this.name,
    required this.name2,
    required this.phone,
    required this.password,
    this.fcm,
    this.referral,
    this.idNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": name,
      "last_name": name2,
      "phone": phone,
      "password": password,
      "password_confirmation": password,
      if (fcm != null) "fcm": fcm,
      if (referral != null && referral!.isNotEmpty) "referral": referral,
      if (idNumber != null && idNumber!.isNotEmpty) "id_number": idNumber,
    };
  }
}
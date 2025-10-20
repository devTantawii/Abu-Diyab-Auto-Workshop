class RegisterRequestModel {
  final String name;
  final String name2;
  final String phone;
  final String password;
  final String ?fcm;
  final String? referral; // اختياري

  RegisterRequestModel({
    required this.name,
    required this.name2,
    required this.phone,
    required this.password,
     this.fcm,
    this.referral, // اختياري
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": name,
      "last_name": name2,
      "phone": phone,
      "password": password,
      "password_confirmation": password,
      if (fcm != null) "fcm": fcm, // تُضاف فقط إذا كانت غير null
      if (referral != null) "referral": referral, // تُضاف فقط إذا كانت غير null
    };
  }
}

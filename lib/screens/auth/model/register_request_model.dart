class RegisterRequestModel {
  final String name;
  final String name2;
  final String phone;
  final String password;

  RegisterRequestModel({
    required this.name,
    required this.name2,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": name,
      "last_name": name2,
      "phone": phone,
      "password": password,
      "password_confirmation": password,
    };
  }
}

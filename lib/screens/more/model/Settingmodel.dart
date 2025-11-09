class AppSetting {
  final int id;
  final String key;
  final String value;

  AppSetting({
    required this.id,
    required this.key,
    required this.value,
  });

  factory AppSetting.fromJson(Map<String, dynamic> json) {
    return AppSetting(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class AppSetting {
  final int id;
  final String key;
  final String value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppSetting({
    required this.id,
    required this.key,
    required this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory AppSetting.fromJson(Map<String, dynamic> json) {
    return AppSetting(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      value: json['value']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'value': value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

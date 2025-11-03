class StaticPagesModel {
  final int id;
  final String? privacyPolicy;
  final String? termsAndConditions;
  final String? taxCertificate;

  StaticPagesModel({
    required this.id,
    this.privacyPolicy,
    this.termsAndConditions,
    this.taxCertificate,
  });

  factory StaticPagesModel.fromJson(Map<String, dynamic> json) {
    return StaticPagesModel(
      id: json['id'],
      privacyPolicy: json['privacy_policy'],
      termsAndConditions: json['terms_and_conditions'],
      taxCertificate: json['tax_certificate'],
    );
  }
}

class ContactUsResponse {
  final int status;
  final String msg;

  ContactUsResponse({required this.status, required this.msg});

  factory ContactUsResponse.fromJson(Map<String, dynamic> json) {
    return ContactUsResponse(
      status: json['status'],
      msg: json['msg'],
    );
  }
}

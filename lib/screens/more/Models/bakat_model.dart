class PackageResponse {
  final int status;
  final String msg;
  final List<Package> data;

  PackageResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory PackageResponse.fromJson(Map<String, dynamic> json) {
    return PackageResponse(
      status: json['status'],
      msg: json['msg'],
      data: List<Package>.from(
        json['data'].map((x) => Package.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class Package {
  final int id;
  final String name;
  final String title;
  final String description;
  final String price;
  final int duration;
  final String type;
  final int status;

  Package({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.type,
    required this.status,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      duration: json['duration'],
      type: json['type'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      'type': type,
      'status': status,
    };
  }
}

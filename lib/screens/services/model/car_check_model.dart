class CarCheck {
  int? status;
  String? msg;
  List<CarCheckData>? data;

  CarCheck({this.status, this.msg, this.data});

  CarCheck.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CarCheckData>[];
      json['data'].forEach((v) {
        data!.add(new CarCheckData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarCheckData {
  int? id;
  int? serviceId;
  String? name;
  String? description;
  int? status;
  List<CarChecks>? carChecks;

  CarCheckData(
      {this.id,
        this.serviceId,
        this.name,
        this.description,
        this.status,
        this.carChecks});

  CarCheckData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    if (json['car_checks'] != null) {
      carChecks = <CarChecks>[];
      json['car_checks'].forEach((v) {
        carChecks!.add(new CarChecks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['status'] = this.status;
    if (this.carChecks != null) {
      data['car_checks'] = this.carChecks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarChecks {
  int? id;
  int? subServiceId;
  int? carModelId;
  String? price;

  CarChecks({this.id, this.subServiceId, this.carModelId, this.price});

  CarChecks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subServiceId = json['sub_service_id'];
    carModelId = json['car_model_id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_service_id'] = this.subServiceId;
    data['car_model_id'] = this.carModelId;
    data['price'] = this.price;
    return data;
  }
}

class OilChange {
  final int id;
  final int subServiceId;
  final int carModelId;
  final String price;
  final String kilometers;

  OilChange({
    required this.id,
    required this.subServiceId,
    required this.carModelId,
    required this.price,
    required this.kilometers,
  });

  factory OilChange.fromJson(Map<String, dynamic> json) {
    return OilChange(
      id: json['id'],
      subServiceId: json['sub_service_id'],
      carModelId: json['car_model_id'],
      price: json['price'],
      kilometers: json['kilometers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_service_id': subServiceId,
      'car_model_id': carModelId,
      'price': price,
      'kilometers': kilometers,
    };
  }
}

class SubOil {
  final int id;
  final int serviceId;
  final String name;
  final String description;
  final int status;
  final List<OilChange> oilChanges;

  SubOil({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.description,
    required this.status,
    required this.oilChanges,
  });

  factory SubOil.fromJson(Map<String, dynamic> json) {
    return SubOil(
      id: json['id'],
      serviceId: json['service_id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      oilChanges: (json['oil_changes'] as List)
          .map((e) => OilChange.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'name': name,
      'description': description,
      'status': status,
      'oil_changes': oilChanges.map((e) => e.toJson()).toList(),
    };
  }
}

class SubOilResponse {
  final int status;
  final String msg;
  final List<SubOil> data;

  SubOilResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SubOilResponse.fromJson(Map<String, dynamic> json) {
    return SubOilResponse(
      status: json['status'],
      msg: json['msg'],
      data: (json['data'] as List)
          .map((e) => SubOil.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

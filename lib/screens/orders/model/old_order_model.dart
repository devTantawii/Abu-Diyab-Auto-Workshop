class OldOrderModel {
  final int id;
  final int userId;
  final String code;
  final String date;
  final String time;
  final String finalTotal;
  final String status;
  final int userCarId;
  final Car? userCar;
  final List<OrderItem>? items;

  OldOrderModel({
    required this.id,
    required this.userId,
    required this.code,
    required this.date,
    required this.time,
    required this.finalTotal,
    required this.status,
    required this.userCarId,
    this.userCar,
    this.items,
  });

  factory OldOrderModel.fromJson(Map<String, dynamic> json) {
    return OldOrderModel(
      id: json['id'],
      userId: json['user_id'],
      code: json['code'],
      date: json['date'],
      time: json['time'],
      finalTotal: json['final_total'],
      status: json['status'],
      userCarId: json['user_car_id'],
      userCar: json['user_car'] != null ? Car.fromJson(json['user_car']) : null,
      items: json['items'] != null
          ? (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList()
          : [],
    );
  }
}

class Car {
  final int id;
  final int userId;
  final String? name; // ✅ كان String، صار String?
  final String? licencePlate; // ✅ احتياطيًا لأنها ممكن تكون null في بعض الـ APIs
  final String? kilometer;
  final int carModelId;
  final int carBrandId;
  final String? year; // ✅ احتياطيًا لأنها sometimes ممكن تكون null
  final CarBrand? carBrand;
  final CarModel? carModel;

  Car({
    required this.id,
    required this.userId,
    this.name,
    this.licencePlate,
    this.kilometer,
    required this.carModelId,
    required this.carBrandId,
    this.year,
    this.carBrand,
    this.carModel,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      licencePlate: json['licence_plate'],
      kilometer: json['kilometer'],
      carModelId: json['car_model_id'],
      carBrandId: json['car_brand_id'],
      year: json['year'],
      carBrand: json['car_brand'] != null
          ? CarBrand.fromJson(json['car_brand'])
          : null,
      carModel: json['car_model'] != null
          ? CarModel.fromJson(json['car_model'])
          : null,
    );
  }
}

class CarBrand {
  final int id;
  final String name;
  final String icon;

  CarBrand({required this.id, required this.name, required this.icon});

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

class CarModel {
  final int id;
  final String name;

  CarModel({required this.id, required this.name});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final String itemType;
  final int itemId;
  final ItemData? item;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.itemType,
    required this.itemId,
    this.item,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      itemType: json['item_type'],
      itemId: json['item_id'],
      item: json['item'] != null ? ItemData.fromJson(json['item']) : null,
    );
  }
}

class ItemData {
  final int id;
  final String name;

  ItemData({required this.id, required this.name});

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'],
      name: json['name'],
    );
  }
}

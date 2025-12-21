import 'dart:developer';

class OrdersResponse {
  final int status;
  final String msg;
  final List<OrderSummary> data;

  OrdersResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      status: json['status'] ?? 0,
      msg: json['msg']?.toString() ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((order) => OrderSummary.fromJson(order as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderSummary {
  final int id;
  final int userId;
  final String code;
  final String date;
  final String time;
  final String finalTotal;
  final String status;
  final int userCarId;
  final UserCar userCar;
  final List<OrderItem> items;

  OrderSummary({
    required this.id,
    required this.userId,
    required this.code,
    required this.date,
    required this.time,
    required this.finalTotal,
    required this.status,
    required this.userCarId,
    required this.userCar,
    required this.items,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    log('📋 [OrderSummary] Parsing order id=${json['id']} ...');
    return OrderSummary(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      code: json['code']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      finalTotal: json['final_total']?.toString() ?? '0',
      status: json['status']?.toString() ?? '',
      userCarId: json['user_car_id'] ?? 0,
      userCar: json['user_car'] != null
          ? UserCar.fromJson(json['user_car'] as Map<String, dynamic>)
          : UserCar.empty(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) {
        if (item == null) {
          log('⚠️ [OrderSummary] عنصر item=null تم تجاهله');
          return null;
        }
        try {
          return OrderItem.fromJson(item as Map<String, dynamic>);
        } catch (e) {
          log('❌ [OrderSummary] فشل تحويل item: $e');
          return null;
        }
      })
          .whereType<OrderItem>() // يحذف أي nulls من القائمة
          .toList(),
    );
  }
}

class UserCar {
  final int id;
  final int userId;
  final String? name;
  final String licencePlate;
  final String kilometer;
  final int carModelId;
  final int carBrandId;
  final CarBrand carBrand;
  final CarModel carModel;

  UserCar({
    required this.id,
    required this.userId,
    this.name,
    required this.licencePlate,
    required this.kilometer,
    required this.carModelId,
    required this.carBrandId,
    required this.carBrand,
    required this.carModel,
  });

  factory UserCar.fromJson(Map<String, dynamic> json) {
    return UserCar(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name']?.toString(),
      licencePlate: json['licence_plate']?.toString() ?? '',
      kilometer: json['kilometer']?.toString() ?? '',
      carModelId: json['car_model_id'] ?? 0,
      carBrandId: json['car_brand_id'] ?? 0,
      carBrand: json['car_brand'] != null
          ? CarBrand.fromJson(json['car_brand'] as Map<String, dynamic>)
          : CarBrand.empty(),
      carModel: json['car_model'] != null
          ? CarModel.fromJson(json['car_model'] as Map<String, dynamic>)
          : CarModel.empty(),
    );
  }

  factory UserCar.empty() => UserCar(
    id: 0,
    userId: 0,
    name: '',
    licencePlate: '',
    kilometer: '',
    carModelId: 0,
    carBrandId: 0,
    carBrand: CarBrand.empty(),
    carModel: CarModel.empty(),
  );
}

class CarBrand {
  final int id;
  final String name;
  final String icon;

  CarBrand({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
    );
  }

  factory CarBrand.empty() => CarBrand(id: 0, name: '', icon: '');
}

class CarModel {
  final int id;
  final String name;

  CarModel({
    required this.id,
    required this.name,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  factory CarModel.empty() => CarModel(id: 0, name: '');
}

class OrderItem {
  final int id;
  final int orderId;
  final String itemType;
  final int itemId;
  final Item? item;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.itemType,
    required this.itemId,
    this.item,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    log('🧾 [OrderItem] Parsing item id=${json['id']} ...');
    return OrderItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      itemType: json['item_type']?.toString() ?? '',
      itemId: json['item_id'] ?? 0,
      item: json['item'] != null
          ? Item.fromJson(json['item'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Item {
  final int id;
  final String name;

  Item({
    required this.id,
    required this.name,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  factory Item.empty() => Item(id: 0, name: '');
}

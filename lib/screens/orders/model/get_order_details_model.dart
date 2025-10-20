class OrderResponse {
  final int status;
  final String msg;
  final OrderData data;

  OrderResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      status: json['status'],
      msg: json['msg'],
      data: OrderData.fromJson(json['data']),
    );
  }
}

class OrderData {
  final int id;
  final String code;
  final String? notes;
  final int kilometers;
  final int isCarWorking;
  final String address;
  final String deliveryMethod;
  final String date;
  final String time;
  final dynamic totalPrice;
  final String status;
  final String createdAt;
  final String updatedAt;
  final User user;
  final UserCar userCar;
  final List<OrderItem> items;
  final List<OrderHistory> histories;
  final List<OrderMedia> media;

  OrderData({
    required this.id,
    required this.code,
    this.notes,
    required this.kilometers,
    required this.isCarWorking,
    required this.address,
    required this.deliveryMethod,
    required this.date,
    required this.time,
    this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.userCar,
    required this.items,
    required this.histories,
    required this.media,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      code: json['code'],
      notes: json['notes'],
      kilometers: json['kilometers'],
      isCarWorking: json['is_car_working'],
      address: json['address'],
      deliveryMethod: json['delivery_method'],
      date: json['date'],
      time: json['time'],
      totalPrice: json['total_price'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
      userCar: UserCar.fromJson(json['userCar']),
      items: (json['items'] as List)
          .map((i) => OrderItem.fromJson(i))
          .toList(),
      histories: (json['histories'] as List)
          .map((h) => OrderHistory.fromJson(h))
          .toList(),
      media: (json['media'] as List)
          .map((m) => OrderMedia.fromJson(m))
          .toList(),
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
    );
  }
}

class UserCar {
  final String brand;
  final String model;

  UserCar({
    required this.brand,
    required this.model,
  });

  factory UserCar.fromJson(Map<String, dynamic> json) {
    return UserCar(
      brand: json['brand'],
      model: json['model'],
    );
  }
}

class OrderItem {
  final int id;
  final String itemType;
  final int itemId;
  final int quantity;
  final String price;
  final dynamic totalPrice;
  final Item item;

  OrderItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.quantity,
    required this.price,
    this.totalPrice,
    required this.item,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      itemType: json['item_type'],
      itemId: json['item_id'],
      quantity: json['quantity'],
      price: json['price'],
      totalPrice: json['total_price'],
      item: Item.fromJson(json['item']),
    );
  }
}

class Item {
  final int id;
  final int productId;
  final String name;
  final String description;
  final String price;
  final int quentity;
  final String viscosty;
  final int kilometer;

  Item({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.quentity,
    required this.viscosty,
    required this.kilometer,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      quentity: json['quentity'],
      viscosty: json['viscosty'],
      kilometer: json['kilometer'],
    );
  }
}

class OrderHistory {
  final int id;
  final String fromStatus;
  final String toStatus;
  final String note;
  final String createdAt;
  final String updatedAt;

  OrderHistory({
    required this.id,
    required this.fromStatus,
    required this.toStatus,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      id: json['id'],
      fromStatus: json['from_status'],
      toStatus: json['to_status'],
      note: json['note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class OrderMedia {
  final int id;
  final String media;

  OrderMedia({
    required this.id,
    required this.media,
  });

  factory OrderMedia.fromJson(Map<String, dynamic> json) {
    return OrderMedia(
      id: json['id'],
      media: json['media'],
    );
  }
}

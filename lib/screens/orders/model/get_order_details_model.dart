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
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
      msg: json['msg']?.toString() ?? '',
      data: OrderData.fromJson(json['data'] ?? {}),
    );
  }
}

class OrderData {
  final int id;
  final String code;
  final String? notes;
  final int? kilometers;
  final int? isCarWorking;
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
    this.kilometers,
    this.isCarWorking,
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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code: json['code']?.toString() ?? '',
      notes: json['notes']?.toString(),
      kilometers: int.tryParse(json['kilometers']?.toString() ?? ''),
      isCarWorking: int.tryParse(json['is_car_working']?.toString() ?? ''),
      address: json['address']?.toString() ?? '',
      deliveryMethod: json['delivery_method']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      totalPrice: json['total_price'],
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      user: User.fromJson(json['user'] ?? {}),
      userCar: UserCar.fromJson(json['userCar'] ?? {}),
      items: (json['items'] as List? ?? [])
          .map((i) => OrderItem.fromJson(i))
          .toList(),
      histories: (json['histories'] as List? ?? [])
          .map((h) => OrderHistory.fromJson(h))
          .toList(),
      media: (json['media'] as List? ?? [])
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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

class UserCar {
  final String brand;
  final String brandIcon;
  final String model;
  final String licencePlate;
  final String kilometer;

  UserCar({
    required this.brand,
    required this.brandIcon,
    required this.model,
    required this.licencePlate,
    required this.kilometer,
  });

  factory UserCar.fromJson(Map<String, dynamic> json) {
    return UserCar(
      brand: json['brand']?.toString() ?? '',
      brandIcon: json['brand_icon']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      licencePlate: json['licence_plate']?.toString() ?? '',
      kilometer: json['kilometer']?.toString() ?? '',
    );
  }
}

class OrderItem {
  final int id;
  final String itemType;
  final int itemId;
  final int? quantity;
  final String? price;
  final dynamic totalPrice;
  final Item item;

  OrderItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    this.quantity,
    this.price,
    this.totalPrice,
    required this.item,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      itemType: json['item_type']?.toString() ?? '',
      itemId: int.tryParse(json['item_id']?.toString() ?? '0') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? ''),
      price: json['price']?.toString(),
      totalPrice: json['total_price'],
      item: Item.fromJson(json['item'] ?? {}),
    );
  }
}

class Item {
  final int id;
  final int? productId;
  final String name;
  final String? description;
  final String? price;
  final int? quentity;
  final String? viscosty;
  final int? kilometer;
  final String? icon;
  final String? slug;
  final int? fees;
  final int? status;

  Item({
    required this.id,
    this.productId,
    required this.name,
    this.description,
    this.price,
    this.quentity,
    this.viscosty,
    this.kilometer,
    this.icon,
    this.slug,
    this.fees,
    this.status,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: json['price']?.toString(),
      quentity: int.tryParse(json['quentity']?.toString() ?? ''),
      viscosty: json['viscosty']?.toString(),
      kilometer: int.tryParse(json['kilometer']?.toString() ?? ''),
      icon: json['icon']?.toString(),
      slug: json['slug']?.toString(),
      fees: int.tryParse(json['fees']?.toString() ?? ''),
      status: int.tryParse(json['status']?.toString() ?? ''),
    );
  }
}

class OrderHistory {
  final int id;
  final String fromStatus;
  final String toStatus;
  final String? note;
  final String createdAt;
  final String updatedAt;

  OrderHistory({
    required this.id,
    required this.fromStatus,
    required this.toStatus,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fromStatus: json['from_status']?.toString() ?? '',
      toStatus: json['to_status']?.toString() ?? '',
      note: json['note']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}

class OrderMedia {
  final int? id;
  final String? media;
  final String? type;
  final String? url;
  final String? createdAt;

  OrderMedia({
    this.id,
    this.media,
    this.type,
    this.url,
    this.createdAt,
  });

  factory OrderMedia.fromJson(Map<String, dynamic> json) {
    return OrderMedia(
      id: int.tryParse(json['id']?.toString() ?? ''),
      media: json['media']?.toString(),
      type: json['type']?.toString(),
      url: json['url']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

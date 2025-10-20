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
      status: json['status'],
      msg: json['msg'],
      data: (json['data'] as List)
          .map((order) => OrderSummary.fromJson(order))
          .toList(),
    );
  }
}

class OrderSummary {
  final int id;
  final String code;
  final int userId;
  final String? notes;
  final int kilometers;
  final int isCarWorking;
  final int userCarId;
  final String lat;
  final String long;
  final String address;
  final String deliveryMethod;
  final String date;
  final String time;
  final String total;
  final String offerDiscount;
  final dynamic packageDiscount;
  final String pointsDiscount;
  final String finalTotal;
  final String status;
  final bool isCancelled;
  final String createdAt;
  final String updatedAt;

  OrderSummary({
    required this.id,
    required this.code,
    required this.userId,
    this.notes,
    required this.kilometers,
    required this.isCarWorking,
    required this.userCarId,
    required this.lat,
    required this.long,
    required this.address,
    required this.deliveryMethod,
    required this.date,
    required this.time,
    required this.total,
    required this.offerDiscount,
    this.packageDiscount,
    required this.pointsDiscount,
    required this.finalTotal,
    required this.status,
    required this.isCancelled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      id: json['id'],
      code: json['code'],
      userId: json['user_id'],
      notes: json['notes'],
      kilometers: json['kilometers'],
      isCarWorking: json['is_car_working'],
      userCarId: json['user_car_id'],
      lat: json['lat'],
      long: json['long'],
      address: json['address'],
      deliveryMethod: json['delivery_method'],
      date: json['date'],
      time: json['time'],
      total: json['total'],
      offerDiscount: json['offer_discount'],
      packageDiscount: json['package_discount'],
      pointsDiscount: json['points_discount'],
      finalTotal: json['final_total'],
      status: json['status'],
      isCancelled: json['is_cancelled'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

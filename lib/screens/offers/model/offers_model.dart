class OfferResponse {
  final int status;
  final String msg;
  final List<Offer> data;

  OfferResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    return OfferResponse(
      status: json['status'],
      msg: json['msg'],
      data: List<Offer>.from(json['data'].map((x) => Offer.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "msg": msg,
      "data": data.map((x) => x.toJson()).toList(),
    };
  }
}

class Offer {
  final int id;
  final String name;
  final String description;
  final String image;
  final OfferItem? service;
  final OfferItem? product;
  final String discount;
  final String type;
  final String startAt;
  final String expiredAt;
  final bool status;

  Offer({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.service,
    this.product,
    required this.discount,
    required this.type,
    required this.startAt,
    required this.expiredAt,
    required this.status,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      service: json['service'] != null
          ? OfferItem.fromJson(json['service'])
          : null,
      product: json['product'] != null
          ? OfferItem.fromJson(json['product'])
          : null,
      discount: json['discount'],
      type: json['type'],
      startAt: json['start_at'],
      expiredAt: json['expired_at'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "image": image,
      "service": service?.toJson(),
      "product": product?.toJson(),
      "discount": discount,
      "type": type,
      "start_at": startAt,
      "expired_at": expiredAt,
      "status": status,
    };
  }
}

class OfferItem {
  final int id;
  final String name;

  OfferItem({
    required this.id,
    required this.name,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    return OfferItem(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

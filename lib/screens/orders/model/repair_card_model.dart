class RepairClauseDetailModel {
  final int id;
  final int repairClauseId;
  final String name;
  final String price;

  RepairClauseDetailModel({
    required this.id,
    required this.repairClauseId,
    required this.name,
    required this.price,
  });

  factory RepairClauseDetailModel.fromJson(Map<String, dynamic> json) {
    return RepairClauseDetailModel(
      id: json['id'],
      repairClauseId: json['repair_clause_id'],
      name: json['name'],
      price: json['price'],
    );
  }
}

class RepairDetailModel {
  final int id;
  final int repairCardId;
  final String title;
  final String price;
  final bool isUrgent;
  final bool isChosen;
  final List<RepairClauseDetailModel> clauseDetails;

  RepairDetailModel({
    required this.id,
    required this.repairCardId,
    required this.title,
    required this.price,
    required this.isUrgent,
    required this.isChosen,
    required this.clauseDetails,
  });

  factory RepairDetailModel.fromJson(Map<String, dynamic> json) {
    return RepairDetailModel(
      id: json['id'],
      repairCardId: json['repair_card_id'],
      title: json['title'],
      price: json['price'],
      isUrgent: json['is_urgent'] == 1,
      isChosen: json['is_chosen'] == 1,
      clauseDetails: (json['clause_details'] as List)
          .map((e) => RepairClauseDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class RepairCardModel {
  final int id;
  final int orderId;
  final String media;
  final String subTotal;
  final String tax;
  final String finalPrice;
  final String createdAt;
  final String userChosenPrice;
  final List<RepairDetailModel> details;

  RepairCardModel({
    required this.id,
    required this.orderId,
    required this.media,
    required this.subTotal,
    required this.tax,
    required this.finalPrice,
    required this.createdAt,
    required this.userChosenPrice,
    required this.details,
  });

  factory RepairCardModel.fromJson(Map<String, dynamic> json) {
    return RepairCardModel(
      id: json['id'],
      orderId: json['order_id'],
      media: json['media'],
      subTotal: json['sub_total'],
      tax: json['tax'],
      finalPrice: json['final_price'],
      createdAt: json['created_at'],
      userChosenPrice: json['user_chosen_price'],
      details: (json['details'] as List)
          .map((e) => RepairDetailModel.fromJson(e))
          .toList(),
    );
  }
}

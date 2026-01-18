class PaymentPreviewModel {
  final Breakdown breakdown;
  final List<PaymentMethod> paymentMethods;

  PaymentPreviewModel({required this.breakdown, required this.paymentMethods});

  factory PaymentPreviewModel.fromJson(Map<String, dynamic> json) {
    return PaymentPreviewModel(
      breakdown: Breakdown.fromJson(json['breakdown']),
      paymentMethods: List<PaymentMethod>.from(
        json['payment_methods'].map((x) => PaymentMethod.fromJson(x)),
      ),
    );
  }
}

class Breakdown {
  final num itemsSubtotal;
  final num packageDiscount;
  final num offerDiscount;
  final num pointsRequested;
  final num pointsDiscount;
  final num totalAfterDiscounts;
  final num taxRate;
  final num taxAmount;
  final num total;
  final num walletBalanceAfterDeduction;

  Breakdown({
    required this.itemsSubtotal,
    required this.packageDiscount,
    required this.offerDiscount,
    required this.pointsRequested,
    required this.pointsDiscount,
    required this.total,
    required this.walletBalanceAfterDeduction,
    required this.totalAfterDiscounts,
    required this.taxRate,
    required this.taxAmount,
  });

  factory Breakdown.fromJson(Map<String, dynamic> json) {
    return Breakdown(
      itemsSubtotal: json['items_subtotal'],
      packageDiscount: json['package_discount'],
      offerDiscount: json['offer_discount'],
      pointsRequested: json['points_requested'],
      pointsDiscount: json['points_discount'],
      totalAfterDiscounts: json['total_after_discounts'],
      taxRate: json['tax_rate'],
      taxAmount: json['tax_amount'],
      total: json['total'],
      walletBalanceAfterDeduction: json['wallet_balance_after_deduction'],
    );
  }
}

class PaymentMethod {
  final String key;
  final String name;

  PaymentMethod({required this.key, required this.name});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(key: json['key'], name: json['name']);
  }
}

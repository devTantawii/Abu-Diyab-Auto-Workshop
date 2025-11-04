
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/language/locale.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/Custom-Button.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../orders/model/payment_preview_model.dart';
import '../widgets/review_req_body.dart';
import 'final-review.dart';

class ReviewRequestPage extends StatefulWidget {
  final int? selectedUserCarId;
  final dynamic selectedProduct;
  final String? notes;
  final String? kiloRead;
  final List<File>? selectedCarDocs;
  final String title;
  final String icon;
  final String slug;
  final String? count;
  final String? isCarWorking;

  const ReviewRequestPage({
    super.key,
    this.selectedUserCarId,
    this.selectedProduct,
    this.notes,
    this.kiloRead,
    this.selectedCarDocs,
    required this.title,
    required this.icon,
    required this.slug,
    this.count,
    this.isCarWorking,
  });

  @override
  State<ReviewRequestPage> createState() => _ReviewRequestPageState();
}

class _ReviewRequestPageState extends State<ReviewRequestPage> {
  int selectedIndex = 0;
  DateTime? selectedDateTime;
  String? selectedAddress;
  double? lat, lng;

  @override
  void initState() {
    super.initState();
    if (widget.selectedUserCarId != null) {
      context.read<CarCubit>().getUserCar(widget.selectedUserCarId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomGradientAppBar(
        title_ar: "جدولة الطلب",
        title_en: "My Orders",
        onBack: () => Navigator.pop(context),
      ),
      body: ReviewRequestBody(
        widget: widget,
        selectedIndex: selectedIndex,
        onDeliveryMethodChanged: (i) => setState(() => selectedIndex = i),
        onDateSelected: (date) => setState(() => selectedDateTime = date),
        onAddressSelected: (addr, lt, ln) => setState(() {
          selectedAddress = addr;
          lat = lt;
          lng = ln;
        }),
        selectedDateTime: selectedDateTime,
        selectedAddress: selectedAddress,
      ),
      bottomNavigationBar: CustomBottomButton(
        textAr: "مراجعة الطلب",
        textEn: "Review Order",
        onPressed: () => _onReviewPressed(context),
      ),
    );
  }

  Future<void> _onReviewPressed(BuildContext context) async {
    if (selectedAddress == null || lat == null || lng == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("يرجى اختيار العنوان أولاً")));
      return;
    }

    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("يرجى اختيار اليوم و الوقت")));
      return;
    }

    // ✅ البيانات كاملة → نروح للشاشة التانية
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinalReview(
          userCarId: widget.selectedUserCarId,
          selectedProduct: widget.selectedProduct,
          notes: widget.notes,
          kiloRead: widget.kiloRead,
          address: selectedAddress,
          dateTime: selectedDateTime,
          deliveryMethod: selectedIndex == 1 ? "insite" : "outsite",
          slug: widget.slug,
          title: widget.title,
          icon: widget.icon,
          isCarWorking: widget.isCarWorking,
          selectedCarDocs: widget.selectedCarDocs,
          lat: lat,
          long: lng,
          count: widget.count,
        ),
      ),
    );
  }
}

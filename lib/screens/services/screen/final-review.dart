import 'dart:io';
import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/api.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/commponents.dart';
import '../../../widgets/web_payment.dart';
import '../../orders/model/payment_preview_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/final_review_header.dart';
import '../widgets/car_details_section.dart';
import '../widgets/appointment_details.dart';
import '../widgets/balance_section.dart';
import '../widgets/order_success_bottom_sheet.dart';
import '../widgets/packages_banner.dart';
import '../widgets/payment_summary.dart';
import '../widgets/payment_method_modal.dart';

class FinalReview extends StatefulWidget {
  final int? userCarId;
  final dynamic selectedProduct;
  final String? notes;
  final String? kiloRead;
  final String? address;
  final DateTime? dateTime;
  final String deliveryMethod;
  final String slug;
  final String title;
  final String icon;
  final double? lat;
  final double? long;
  final List<File>? selectedCarDocs;
  final String? count;
  final String? isCarWorking;

  const FinalReview({
    super.key,
    this.userCarId,
    this.selectedProduct,
    this.notes,
    this.kiloRead,
    this.address,
    this.dateTime,
    required this.deliveryMethod,
    required this.slug,
    required this.title,
    required this.icon,
    this.lat,
    this.long,
    this.selectedCarDocs,
    this.count,
    this.isCarWorking,
  });

  @override
  State<FinalReview> createState() => _FinalReviewState();
}

class _FinalReviewState extends State<FinalReview> {
  String? selectedPaymentMethod;
  late final locale = AppLocalizations.of(context);
  bool isLoading = true;
  PaymentPreviewModel? previewModel;
  int usedPoints = 0;
  bool isSummaryLoading = false; // ✅ تحميل جزئي للـ Summary فقط

  @override
  void initState() {
    super.initState();
    _fetchPreview();
  }

  Future<void> _fetchPreview() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final dio = Dio();

      final url = "$mainApi/app/elwarsha/payments/preview";
      final deliveryMethod =
      widget.deliveryMethod == "outsite" ? "towTruck" : "inWorkshop";

      final formData = {
        "payment_method": "card",
        "payload": {
          "user_car_id": widget.userCarId,
          "delivery_method": deliveryMethod,
          "date":
          "${widget.dateTime!.year}-${widget.dateTime!.month.toString().padLeft(2, '0')}-${widget.dateTime!.day.toString().padLeft(2, '0')}",
          "time":
          "${widget.dateTime!.hour.toString().padLeft(2, '0')}:${widget.dateTime!.minute.toString().padLeft(2, '0')}",
          "address": widget.address,
          "notes": widget.notes ?? "",
          "kilometers": int.tryParse(widget.kiloRead ?? "0") ?? 0,
          "is_car_working":
          (widget.isCarWorking == "true" || widget.isCarWorking == "1")
              ? 1
              : 0,
          "items": [
            {
              "type": widget.slug,
              "id": (widget.selectedProduct is int)
                  ? widget.selectedProduct
                  : widget.selectedProduct?.id ?? 0,
              "quantity": int.tryParse(widget.count ?? "1") ?? 1,
            },
          ],
        },
        "points": usedPoints,
      };

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final data = response.data['data'];
      setState(() {
        previewModel = PaymentPreviewModel.fromJson(data);

        // ✅ استخدم القيمة اللي فعلاً راجعة من السيرفر
        usedPoints = (previewModel?.breakdown.pointsRequested ?? 0).toInt();

        isLoading = false;
      });

    } catch (e) {
      debugPrint("❌ Error fetching preview: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء تحميل المعاينة")),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (previewModel == null) {
      return const Scaffold(body: Center(child: Text("فشل تحميل البيانات")));
    }

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor(context),
      appBar: CustomGradientAppBar(
        title_ar: "مراجعة الطلب",
        title_en: "My Orders",
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
          color: backgroundColor(context),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FinalReviewHeader(
                    title: widget.title,
                    icon: widget.icon,
                    deliveryMethod: widget.deliveryMethod,
                  ),
                  SizedBox(height: 12.h),

                  CarDetailsSection(userCarId: widget.userCarId),
                  SizedBox(height: 12.h),

                  AppointmentDetails(
                    deliveryMethod: widget.deliveryMethod,
                    address: widget.address,
                    dateTime: widget.dateTime,
                  ),
                  SizedBox(height: 12.h),

                  BalanceSection(
                    model: previewModel!,
                    appliedPoints: usedPoints,
                    onApplyPoints: (points) async {
                      setState(() {
                        usedPoints = points;
                        isSummaryLoading = true;
                      });
                      await _fetchPreview();
                      setState(() => isSummaryLoading = false);
                    },
                  ),

                  SizedBox(height: 12.h),
                  PackagesBanner(),
                  SizedBox(height: 16.h),

                  // ✅ PaymentSummary جزء طبيعي من الصفحة
                  PaymentSummary(
                    model: previewModel!,
                    isLoading: isSummaryLoading,
                    onConfirm: () => _showPaymentMethods(context),
                  ),

                  SizedBox(height: 24.h), // padding إضافي في آخر الصفحة
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    if (previewModel == null || previewModel!.paymentMethods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            locale!.isDirectionRTL(context)
                ? 'لا توجد طرق دفع متاحة حالياً'
                : "No payment methods are currently available.",
            style: TextStyle(fontSize: 18.sp, color: accentColor),
          ),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      isScrollControlled: true,
      builder: (_) => PaymentMethodModal(
        paymentMethods: previewModel!.paymentMethods,
        selectedMethod: selectedPaymentMethod,
        onSelect: (method) {
          setState(() => selectedPaymentMethod = method);
        },
        onConfirm: () => _initiatePayment(context),
      ),
    );
  }

  Future<void> _initiatePayment(BuildContext context) async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locale!.isDirectionRTL(context)
              ? 'من فضلك اختر وسيلة الدفع'
              : "Please select a payment method."),
        ),
      );
      return;
    }

    final token = await _getToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطأ: لم يتم العثور على التوكن')),
      );
      return;
    }

    final url = "$mainApi/app/elwarsha/payments/initiate";
    final formData = FormData();

    final fields = _buildPayload();

// ✅ اطبع كل البيانات قبل الإرسال
    debugPrint("====== بيانات الطلب اللي هتتبعت للسيرفر ======");
    fields.forEach((key, value) {
      debugPrint("➡️ $key: $value");
      formData.fields.add(MapEntry(key, value.toString()));
    });
    debugPrint("============================================");

// ✅ اطبع الملفات كمان (لو فيه صور عربية السيارة مثلًا)
    if (widget.selectedCarDocs != null && widget.selectedCarDocs!.isNotEmpty) {
      for (int i = 0; i < widget.selectedCarDocs!.length; i++) {
        final file = widget.selectedCarDocs![i];
        final multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
        formData.files.add(MapEntry("media[$i]", multipartFile));
        debugPrint("📸 ملف مرفق → media[$i]: ${file.path}");
      }
    } else {
      debugPrint("📁 لا توجد مرفقات (selectedCarDocs فارغة)");
    }


    if (widget.selectedCarDocs != null && widget.selectedCarDocs!.isNotEmpty) {
      for (int i = 0; i < widget.selectedCarDocs!.length; i++) {
        final file = widget.selectedCarDocs![i];
        final multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
        formData.files.add(MapEntry("media[$i]", multipartFile));
        debugPrint("FILE => media[$i]: ${file.path}");
      }
    }

    final dio = Dio(
      BaseOptions(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    try {
      debugPrint("Sending request to: $url ...");
      final response = await dio.post(url, data: formData);
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Response: ${response.data}");

      // إغلاق Modal اختيار طريقة الدفع أولاً
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (response.statusCode == 201) {
        final data = response.data["data"];

        if (response.statusCode == 201 && response.data["data"]?["payment_url"] != null) {
          final paymentUrl = response.data["data"]["payment_url"];
          debugPrint("Payment URL: $paymentUrl");
          Navigator.pop(context); // إغلاق الـ modal
          navigateTo(context, WebPayment(url: paymentUrl));
        }
        // 2. دفع كاش (لا يوجد payment_url)
        else if (data != null && data["order_id"] != null) {
          final orderId = data["order_id"] as int;
          final amount = (data["amount"] ?? 0).toDouble();

          debugPrint("Cash Payment → Order #$orderId created");

          showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            builder: (_) => OrderSuccessBottomSheet(
              orderId: orderId,
              amount: amount,
            ),
          );

        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data["msg"] ?? 'تم الإرسال لكن لا توجد بيانات دفع'),
            ),
          );
        }
      } else {
        // فشل عام
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data["msg"] ?? 'فشل في إنشاء الطلب'),
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الاتصال بالخادم: ${e.message}'),
        ),
      );
    } catch (e) {
      debugPrint("Unexpected error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ غير متوقع')),
      );
    }
  }
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, dynamic> _buildPayload() {
    return {
      "points": usedPoints, // ✅ أضف هذا السطر هنا
      "payment_method": selectedPaymentMethod,
      "payload[user_car_id]": widget.userCarId,
      "payload[delivery_method]": widget.deliveryMethod,
      "payload[date]":
      "${widget.dateTime?.year}-${widget.dateTime?.month.toString().padLeft(2, '0')}-${widget.dateTime?.day.toString().padLeft(2, '0')}",
      "payload[time]":
      "${widget.dateTime?.hour.toString().padLeft(2, '0')}:${widget.dateTime?.minute.toString().padLeft(2, '0')}",
      "payload[address]": widget.address ?? "",
      "payload[notes]": widget.notes ?? "",
      "payload[kilometers]": widget.kiloRead ?? "0",
      "payload[lat]": widget.lat ?? "",
      "payload[long]": widget.long ?? "",
      "payload[is_car_working]": (widget.isCarWorking == "true" || widget.isCarWorking == "1") ? 1 : 0,
      "payload[items][0][type]": widget.slug ?? "0",
      "payload[items][0][id]": (widget.selectedProduct is int) ? widget.selectedProduct : widget.selectedProduct?.id ?? 0,
      "payload[items][0][quantity]": widget.count ?? "1",
    };
  }
}
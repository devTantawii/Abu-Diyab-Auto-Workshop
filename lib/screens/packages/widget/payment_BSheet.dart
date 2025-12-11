import 'dart:convert';

import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/progress_bar.dart';
import '../../more/screen/widget/terms and conditions.dart';
import '../../orders/model/payment_preview_model.dart';
import '../../services/widgets/payment_method_tile.dart';

class PaymentBsheet extends StatefulWidget {
  final int packageId;

  const PaymentBsheet({super.key, required this.packageId});

  @override
  State<PaymentBsheet> createState() => _PaymentBsheetState();
}

class _PaymentBsheetState extends State<PaymentBsheet> {
  bool agreeTerms = false;
  String? selectedMethod;
  final Dio dio = Dio();
  bool isLoading = false;
  final List<PaymentMethod> methods = [
    PaymentMethod(key: "cash", name: "Cash"),
    PaymentMethod(key: "tamara", name: "Tamara"),
    PaymentMethod(key: "madfu", name: "Madfu"),
  ];

  Future<void> createSubscription() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dio.post(
        "$mainApi/app/elwarsha/subscriptions/create",
        data: {
          "package_id": widget.packageId,
          "payment_method": selectedMethod,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // ❗ اطبع status code والbody كامل
      print("STATUS CODE: ${response.statusCode}");
      print("FULL BODY:\n${const JsonEncoder.withIndent('  ').convert(response.data)}");

      final data = response.data;
      final message = data["message"] ?? "تم إنشاء الاشتراك";

      // ❗ اعرض الرسالة مهما كان statusCode
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );

      // ❗ لو الكود 200، نرجع true
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      }

    } catch (e, stackTrace) {
      // ❗ اطبع الخطأ الكامل مع stack trace
      print("ERROR: $e");
      print("STACK TRACE: $stackTrace");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ أثناء تنفيذ الدفع: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      height: 0.70.sh,
      decoration: BoxDecoration(
        color: backgroundColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///━━━━━━━━ HEADER ━━━━━━━━
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      ProgressBar(),
                      ProgressBar(),
                      ProgressBar(active: true),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  ///━━━━━━━━ PAYMENT BOX ━━━━━━━━
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        color: backgroundWhiteColor(context),
                        borderRadius: BorderRadius.circular(16.sp),
                        border: Border.all(color: Colors.grey, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),

                          Text(
                            locale!.isDirectionRTL(context)
                                ? 'طريقة الدفع'
                                : "Payment Options",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: headingColor(context),
                            ),
                          ),

                          SizedBox(height: 6.h),

                          Text(
                            locale.isDirectionRTL(context)
                                ? 'برجاء إختيار طريقة الدفع المناسبة لك.'
                                : "Choose your preferred payment method.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: paragraphColor(context),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          ///━━━━━━━━ LIST OF METHODS ━━━━━━━━
                          Expanded(
                            child: ListView.builder(
                              itemCount: methods.length,
                              itemBuilder: (ctx, index) {
                                return PaymentMethodTile(
                                  method: methods[index],
                                  selected: selectedMethod,
                                  locale: locale,
                                  onSelect: (key) {
                                    setState(() => selectedMethod = key);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  ///━━━━━━━━ TERMS ━━━━━━━━
                  Row(
                    children: [
                      Checkbox(
                        value: agreeTerms,
                        activeColor: typographyMainColor(context),
                        onChanged: (value) {
                          setState(() => agreeTerms = value!);
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TermsAndConditions(),
                              ),
                            );
                          },
                          child: Text(
                            locale.isDirectionRTL(context)
                                ? "أوافق على الشروط والأحكام"
                                : "I agree to the Terms and Conditions",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: typographyMainColor(context),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  ///━━━━━━━━ CONFIRM BUTTON ━━━━━━━━
                  GestureDetector(
                    onTap:
                        agreeTerms && selectedMethod != null && !isLoading
                            ? () {
                              createSubscription();
                            }
                            : null,

                    child: Container(
                      width: double.infinity,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color:
                            agreeTerms && selectedMethod != null
                                ? typographyMainColor(context)
                                : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child:
                            isLoading
                                ? SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  locale.isDirectionRTL(context)
                                      ? 'تأكيد الدفع'
                                      : 'Confirm Payment',
                                  style: TextStyle(
                                    color: buttonPrimaryTextColor(context),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/screens/final_review/services/payment_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constant/api.dart';

class PaymentResult {
  final bool success;
  final String? paymentUrl;
  final String? message;

  PaymentResult({required this.success, this.paymentUrl, this.message});
}

class PaymentService {
  static Future<PaymentResult> initiatePayment({
    required BuildContext context,
    required String? token,
    required String selectedPaymentMethod,
    required Map<String, dynamic> payload,
    required List<File>? files,
  }) async {
    if (token == null || token.isEmpty) {
      return PaymentResult(success: false, message: 'خطأ: لم يتم العثور على التوكن');
    }

    final formData = FormData();
    payload.forEach((k, v) {
      formData.fields.add(MapEntry(k, v.toString()));
      debugPrint("FIELD => $k: $v");
    });

    if (files != null && files.isNotEmpty) {
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final multipartFile = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
        formData.files.add(MapEntry("media[$i]", multipartFile));
        debugPrint("FILE => media[$i]: ${file.path}");
      }
    }

    final dio = Dio(BaseOptions(headers: {"Authorization": "Bearer $token", "Accept": "application/json"}));

    try {
      final response = await dio.post(paymentsInitiateApi, data: formData);
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Response: ${response.data}");

      if (response.statusCode == 201 && response.data["data"]?["payment_url"] != null) {
        return PaymentResult(success: true, paymentUrl: response.data["data"]["payment_url"]);
      } else {
        return PaymentResult(success: false, message: response.data["msg"] ?? 'فشل في بدء عملية الدفع');
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
      return PaymentResult(success: false, message: 'خطأ في الاتصال: ${e.message}');
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return PaymentResult(success: false, message: 'حدث خطأ غير متوقع');
    }
  }
}
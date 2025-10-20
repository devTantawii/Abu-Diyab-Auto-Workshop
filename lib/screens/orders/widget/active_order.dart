import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/get_order_model.dart';
import 'order_details_screen.dart';

class ActiveOrder extends StatelessWidget {
  final OrderSummary order;
  const ActiveOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      height: 370.h,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0x3F000000)
                : const Color(0xFF9B8989),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(children: [
              const TextSpan(
                text: 'رقم الطلب : ',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black),
              ),
              TextSpan(
                text: order.code,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFBA1B1B),
                    fontSize: 18),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          Text('العنوان: ${order.address}',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('الحالة: ${order.status}',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('الإجمالي: ${order.total} ر.س',
              style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(orderId: order.id),
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFBA1B1B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Center(
                      child: Text('عرض التفاصيل',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1.3,
                          color: ThemeMode.light == ThemeMode.light
                              ? Colors.black
                              : Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Center(
                    child: Text('تواصل مع المركز',
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

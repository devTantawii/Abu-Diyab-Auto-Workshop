import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/language/locale.dart'; // تأكد إن المسار صحيح
import '../model/get_order_model.dart';
import 'order_details_screen.dart';

class ActiveOrder extends StatelessWidget {
  final OrderSummary order;
  const ActiveOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final car = order.userCar;
    final serviceName =
    order.items.isNotEmpty ? order.items.first.item.name :
    (locale!.isDirectionRTL(context) ? 'خدمة غير محددة' : 'Undefined Service');

    return Container(
      width: 350.w,
      height: 440.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// 🧩 اسم الخدمة
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: locale!.isDirectionRTL(context)
                            ? 'اسم الخدمة : '
                            : 'Service Name: ',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 15.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: serviceName,
                        style: TextStyle(
                          color: const Color(0xFFBA1B1B),
                          fontSize: 22.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
          //    if (car.carBrand.icon.isNotEmpty)
          //      Image.network(
          //        car.carBrand.icon,
          //        width: 23.w,
          //        height: 23.h,
          //        errorBuilder: (_, __, ___) => const Icon(Icons.car_repair),
          //      ),
            ],
          ),

          const Divider(thickness: 0.7),

          /// 🔢 رقم الطلب + الحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    locale.isDirectionRTL(context)
                        ? 'رقم الطلب: '
                        : 'Order No: ',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 16.h,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    order.code,
                    style: const TextStyle(
                      color: Color(0xFFBA1B1B),
                      fontSize: 16,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(thickness: 0.7),

          /// 🚗 بيانات السيارة
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 93.w,
                height: 85.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: car.carBrand.icon.isNotEmpty
                    ? Image.network(car.carBrand.icon, fit: BoxFit.cover)
                    : Image.asset('assets/icons/car_logo.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(context, locale.isDirectionRTL(context) ? 'الماركة:' : 'Brand:', car.carBrand.name),
                  _infoRow(context, locale.isDirectionRTL(context) ? 'الموديل:' : 'Model:', car.carModel.name),
                  _infoRow(context, locale.isDirectionRTL(context) ? 'رقم اللوحة:' : 'Plate No:', car.licencePlate),
                ],
              ),
            ],
          ),

          const Divider(thickness: 0.7),
          Row(
            children: [
              Text(
                locale.isDirectionRTL(context)
                    ? 'حاله الطلب : '
                    : 'Order status : ',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 16.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 20.w,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: ShapeDecoration(
                  color: _getStatusColor(order.status),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  _translateStatus(order.status, locale, context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.h,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ],
          ),
          const Divider(thickness: 0.7),

          /// 📅 التاريخ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locale.isDirectionRTL(context)
                    ? 'تاريخ الإنجاز:'
                    : 'Completion Date:',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 16,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                order.date,
                style: const TextStyle(
                  color: Color(0xFFBA1B1B),
                  fontSize: 20,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Divider(thickness: 0.7),

          /// 💰 إجمالي الفاتورة
          Center(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 327.w),
              height: 55.h,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1.5,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/design_money.png', width: 22.w, height: 22.h),
                    SizedBox(width: 8.w),
                    Text(
                      locale.isDirectionRTL(context) ? 'الإجمالي:' : 'Total:',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      order.finalTotal,
                      style: const TextStyle(
                        color: Color(0xFFBA1B1B),
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Image.asset('assets/icons/ryal.png', width: 22.w, height: 22.h),
                  ],
                ),
              ),
            ),
          ),

          const Divider(thickness: 0.7),

          /// 🔘 الأزرار
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Center(
                      child: Text(
                        locale.isDirectionRTL(context)
                            ? 'عرض التفاصيل'
                            : 'View Details',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      locale.isDirectionRTL(context)
                          ? 'تواصل مع المركز'
                          : 'Contact Center',
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 18.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFBA1B1B),
            fontSize: 18,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'admin_approved':
        return Colors.blueAccent;
      case 'car_delivered':
        return Colors.teal;
      case 'inspection_done':
        return Colors.indigo;
      case 'agree_inspection':
        return Colors.amber;
      case 'maintenance_done':
        return Colors.green;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _translateStatus(String status, AppLocalizations locale, BuildContext context) {
    final isArabic = locale.isDirectionRTL(context);
    switch (status) {
      case 'pending':
        return isArabic ? 'قيد الانتظار' : 'Pending';
      case 'admin_approved':
        return isArabic ? 'موافقة الإدارة' : 'Admin Approved';
      case 'car_delivered':
        return isArabic ? 'تم استلام السيارة' : 'Car Delivered';
      case 'inspection_done':
        return isArabic ? 'تم الفحص' : 'Inspection Done';
      case 'agree_inspection':
        return isArabic ? 'تم تأكيد الفحص' : 'Inspection Confirmed';
      case 'maintenance_done':
        return isArabic ? 'الصيانة منتهية' : 'Maintenance Done';
      case 'completed':
        return isArabic ? 'مكتمل' : 'Completed';
      default:
        return isArabic ? 'غير معروف' : 'Unknown';
    }
  }
}

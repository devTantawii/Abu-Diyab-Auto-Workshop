import 'package:abu_diyab_workshop/screens/orders/widget/rate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../model/old_order_model.dart';
import 'order_details_screen.dart';

class OldOrder extends StatelessWidget {
  final OldOrderModel order;

  const OldOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final car = order.userCar;
    final serviceName = order.items != null && order.items!.isNotEmpty
        ? order.items!.first.item?.name ?? ''
        : locale!.isDirectionRTL(context)
        ? 'خدمة غير محددة'
        : 'Undefined Service';
    final firstItem = order.items != null && order.items!.isNotEmpty
        ? order.items!.first
        : null;
    return Container(
      width: 350.w,
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
          // 🧩 اسم الخدمة
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: locale!.isDirectionRTL(context)
                            ? 'اسم الخدمة: '
                            : 'Service Name: ',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: serviceName,
                        style: TextStyle(
                          color: typographyMainColor(context),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        //      if (car?.carBrand?.icon != null)
        //        Image.network(
        //          car!.carBrand!.icon,
        //          width: 23.w,
        //          height: 23.h,
        //          errorBuilder: (_, __, ___) => const Icon(Icons.car_repair),
        //        ),
            ],
          ),

          const Divider(thickness: 0.7),

          // 🔢 رقم الطلب + الحالة
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    order.code,
                    style:  TextStyle(
                      color: typographyMainColor(context),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(thickness: 0.7),

          // 🚗 بيانات السيارة
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
                child: car?.carBrand?.icon != null
                    ? Image.network(car!.carBrand!.icon, fit: BoxFit.cover)
                    : Image.asset('assets/icons/car_logo.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoRow(
                    context,
                    locale.isDirectionRTL(context) ? 'الماركة:' : 'Brand:',
                    car?.carBrand?.name ??
                        (locale.isDirectionRTL(context)
                            ? 'غير محدد'
                            : 'Undefined'),
                  ),
                  _infoRow(
                    context,
                    locale.isDirectionRTL(context) ? 'الموديل:' : 'Model:',
                    car?.year ??
                        (locale.isDirectionRTL(context)
                            ? 'غير محدد'
                            : 'Undefined'),
                  ),
                  _infoRow(
                    context,
                    locale.isDirectionRTL(context)
                        ? 'رقم اللوحة:'
                        : 'Plate Number:',
                    car?.licencePlate ??
                        (locale.isDirectionRTL(context)
                            ? 'غير متوفر'
                            : 'Unavailable'),
                  ),
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 20.w,),
              Expanded(
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: ShapeDecoration(
                    color: _getStatusColor(order.status),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      locale.isDirectionRTL(context)
                          ? _translateStatusAr(order.status)
                          : _translateStatusEn(order.status),
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
          const Divider(thickness: 0.7),

          // 📅 التاريخ
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                order.date,
                style:  TextStyle(
                  color: typographyMainColor(context),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Divider(thickness: 0.7),


          // 🔘 الأزرار
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                 //  Navigator.push(
                 //    context,
                 //    MaterialPageRoute(
                 //      builder: (_) => OrderDetailsScreen(orderId: order.id),
                 //    ),
                 //  );
                  },
                  child: Container(
                    height: 50.h,
                    decoration: ShapeDecoration(
                      color: typographyMainColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        locale.isDirectionRTL(context)
                            ? 'الفاتوره'
                            : 'Invoice',
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
               SizedBox(width: 22.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (firstItem?.item?.id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RateService(serviceID: firstItem!.item!.id),
                        ),
                      );
                    } else {
                      // اختياري: إظهار رسالة أن الخدمة غير متوفرة للتقييم
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(locale.isDirectionRTL(context)
                            ? 'لا يمكن تقييم الخدمة'
                            : 'Cannot rate the service')),
                      );
                    }
                  },
                  child: Container(
                    height: 50.h,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side:  BorderSide(width: 1.3,
    color: Theme.of(context).brightness ==
    Brightness.light
    ? Colors.black
        : Colors.white,

                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        locale.isDirectionRTL(context)
                            ? 'وش رأيك بالخدمة؟'
                            : 'How was the service?',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
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
        Text(title,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            )),
         SizedBox(width: 8.w),
        Text(value,
            style: TextStyle(
              color: typographyMainColor(context),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _translateStatusAr(String status) {
    switch (status) {
      case 'completed':
        return 'مكتمل';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }

  String _translateStatusEn(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }
}

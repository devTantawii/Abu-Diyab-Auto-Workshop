import 'package:abu_diyab_workshop/screens/orders/widget/rate_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../cubit/order_details_cubit.dart';
import '../cubit/order_details_state.dart';
import '../model/get_order_details_model.dart';
import '../model/get_order_details_model.dart' as details;
import '../model/old_order_model.dart' hide OrderItem;

class OldOrder extends StatelessWidget {
  final OldOrderModel order;

  const OldOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final car = order.userCar;
    final serviceName =
        order.items != null && order.items!.isNotEmpty
            ? order.items!.first.item?.name ?? ''
            : locale!.isDirectionRTL(context)
            ? 'خدمة غير محددة'
            : 'Undefined Service';
    final firstItem =
        order.items != null && order.items!.isNotEmpty
            ? order.items!.first
            : null;
    return Container(
      width: 350.w,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).brightness == Brightness.light
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
                        text:
                            locale!.isDirectionRTL(context)
                                ? 'اسم الخدمة: '
                                : 'Service Name: ',
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
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
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    order.code,
                    style: TextStyle(
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
                child:
                    car?.carBrand?.icon != null
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
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
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
                      style: TextStyle(
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
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                order.date,
                style: TextStyle(
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
                    OrderDetailsBottomSheet.show(context, order.id);
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
                        locale.isDirectionRTL(context) ? 'التفاصيل' : 'Details',
                        style: TextStyle(
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
                          builder:
                              (_) =>
                                  RateService(serviceID: firstItem!.item!.id),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            locale.isDirectionRTL(context)
                                ? 'لا يمكن تقييم الخدمة'
                                : 'Cannot rate the service',
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 50.h,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.3,
                          color:
                              Theme.of(context).brightness == Brightness.light
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
                          color:
                              Theme.of(context).brightness == Brightness.light
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
        Text(
          title,
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            color: typographyMainColor(context),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
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



class OrderDetailsBottomSheet extends StatelessWidget {
  final int orderId;

  const OrderDetailsBottomSheet({super.key, required this.orderId});

  static void show(BuildContext context, int orderId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: GestureDetector(
            onTap: () {},
            child: BlocProvider(
              create: (context) => OrderDetailsCubit()..getOrderDetails(orderId),
              child: OrderDetailsBottomSheet(orderId: orderId),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: MediaQuery.of(context).viewInsets,
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Text(
                        locale!.isDirectionRTL(context)
                            ? 'تفاصيل الطلب'
                            : 'Order Details',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 17.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.cancel,
                          color: typographyMainColor(context),
                          size: 25.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Divider(height: 1, thickness: 0.5),
                Expanded(
                  child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
                    builder: (context, state) {
                      if (state is OrderDetailsLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: typographyMainColor(context),
                          ),
                        );
                      } else if (state is OrderDetailsError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 60.sp,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  state.message,
                                  style: GoogleFonts.almarai(
                                    fontSize: 16.sp,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                SizedBox(
                                  height: 45.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<OrderDetailsCubit>()
                                          .getOrderDetails(orderId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      typographyMainColor(context),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.r),
                                      ),
                                    ),
                                    child: Text(
                                      locale.isDirectionRTL(context)
                                          ? 'إعادة المحاولة'
                                          : 'Retry',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (state is OrderDetailsSuccess) {
                        return _buildOrderDetails(
                          context,
                          state.order,
                          scrollController,
                          locale,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

   String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    final s = amount.toString().trim();
    final d = double.tryParse(s);
    if (d == null) return s;
    return d.round().toString();
  }

  Widget _buildCurrencyRow(BuildContext context, String amount,
      {TextStyle? style}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(amount, style: style),
        SizedBox(width: 6.w),
        Image.asset(
          'assets/icons/ryal.png',
          width: 16.w,
          height: 16.w,
          fit: BoxFit.contain,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      ],
    );
  }

  Widget _buildOrderDetails(
      BuildContext context,
      details.OrderData order,
      ScrollController scrollController,
      AppLocalizations locale,
      ) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildSection(
          //   context,
          //   locale.isDirectionRTL(context) ? 'معلومات الطلب' : 'Order Info',
          //   [
          //     _buildInfoRow(
          //       context,
          //       locale.isDirectionRTL(context) ? 'رقم الطلب' : 'Order Code',
          //       order.code,
          //       locale,
          //     ),
          //     _buildInfoRow(
          //       context,
          //       locale.isDirectionRTL(context) ? 'التاريخ' : 'Date',
          //       order.date.split('T')[0],
          //       locale,
          //     ),
          //     _buildInfoRow(
          //       context,
          //       locale.isDirectionRTL(context) ? 'الوقت' : 'Time',
          //       order.time,
          //       locale,
          //     ),
          //     _buildStatusRow(
          //       context,
          //       locale.isDirectionRTL(context) ? 'الحالة' : 'Status',
          //       locale.isDirectionRTL(context)
          //           ? _translateStatusAr(order.status)
          //           : _translateStatusEn(order.status),
          //       _getStatusColor(order.status),
          //       locale,
          //     ),
          //   ],
          // ),
          // SizedBox(height: 15.h),
          // _buildSection(
          //   context,
          //   locale.isDirectionRTL(context) ? 'معلومات العميل' : 'Customer Info',
          //   [
          //     _buildInfoRow(
          //       context,
          //       locale.isDirectionRTL(context) ? 'الاسم' : 'Name',
          //       '${order.user.firstName} ${order.user.lastName}',
          //       locale,
          //     ),
          //     _buildInfoRow(
          //       context,
          //       locale.isDirectionRTL(context) ? 'الهاتف' : 'Phone',
          //       order.user.phone,
          //       locale,
          //     ),
          //   ],
          // ),
         // SizedBox(height: 15.h),
          // _buildSection(
          //   context,
          //   locale.isDirectionRTL(context) ? 'معلومات السيارة' : 'Car Info',
          //   [
          //     _buildCarInfoCard(context, order, locale),
          //   ],
          // ),
          // SizedBox(height: 15.h),
          // _buildSection(
          //   context,
          //   locale.isDirectionRTL(context) ? 'معلومات التوصيل' : 'Delivery Info',
          //   [
          //     _buildInfoRow(
          //       context,
          //       locale.isDirectionRTL(context)
          //           ? 'طريقة التوصيل'
          //           : 'Delivery Method',
          //       locale.isDirectionRTL(context)
          //           ? _translateDeliveryMethodAr(order.deliveryMethod)
          //           : _translateDeliveryMethodEn(order.deliveryMethod),
          //       locale,
          //     ),
          //     _buildInfoRow(
          //       context,
          //       locale.isDirectionRTL(context) ? 'العنوان' : 'Address',
          //       order.address,
          //       locale,
          //     ),
          //     _buildInfoRow(
          //       context,
          //       locale.isDirectionRTL(context)
          //           ? 'طريقة الدفع'
          //           : 'Payment Method',
          //       locale.isDirectionRTL(context)
          //           ? _translatePaymentMethodAr(order.paymentMethod)
          //           : _translatePaymentMethodEn(order.paymentMethod),
          //       locale,
          //     ),
          //   ],
          // ),
          SizedBox(height: 15.h),
          _buildSectionTitle(
            context,
            locale.isDirectionRTL(context) ? 'الخدمات' : 'Services',
          ),
          SizedBox(height: 10.h),
          ...order.items
              .map((item) => _buildItemCard(context, item, locale))
              .toList(),
          SizedBox(height: 15.h),
          _buildPriceSummary(context, order, locale),
          SizedBox(height: 15.h),
          _buildSectionTitle(
            context,
            locale.isDirectionRTL(context) ? 'سجل الطلب' : 'Order History',
          ),
          SizedBox(height: 10.h),
          _buildHistoryTimeline(context, order.histories, locale),
          SizedBox(height: 15.h),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            _buildSection(
              context,
              locale.isDirectionRTL(context) ? 'ملاحظات' : 'Notes',
              [
                Text(
                  order.notes!,
                  style: GoogleFonts.almarai(
                    fontSize: 14.sp,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.7)
                        : Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
          ],
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context,
      String title,
      List<Widget> children,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF5F5F5)
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Graphik Arabic',
              color: typographyMainColor(context),
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Graphik Arabic',
        color: typographyMainColor(context),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context,
      String label,
      String value,
      AppLocalizations locale,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.almarai(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.6)
                    : Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.almarai(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(
      BuildContext context,
      String label,
      String value,
      Color statusColor,
      AppLocalizations locale,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.almarai(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.6)
                    : Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  value,
                  style: GoogleFonts.almarai(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarInfoCard(
      BuildContext context,
      details.OrderData order,
      AppLocalizations locale,
      ) {
    return Row(
      children: [
        if (order.userCar.brandIcon.isNotEmpty)
          Container(
            width: 70.w,
            height: 70.h,
            margin: EdgeInsets.only(
              left: locale.isDirectionRTL(context) ? 0 : 12.w,
              right: locale.isDirectionRTL(context) ? 12.w : 0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(8.w),
            child: Image.network(
              order.userCar.brandIcon,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.directions_car,
                size: 30.sp,
                color: Colors.grey,
              ),
            ),
          ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarDetailRow(
                context,
                locale.isDirectionRTL(context) ? 'الماركة' : 'Brand',
                order.userCar.brand,
              ),
              SizedBox(height: 6.h),
              _buildCarDetailRow(
                context,
                locale.isDirectionRTL(context) ? 'الموديل' : 'Model',
                order.userCar.model,
              ),
              SizedBox(height: 6.h),
              _buildCarDetailRow(
                context,
                locale.isDirectionRTL(context) ? 'رقم اللوحة' : 'Plate',
                order.userCar.licencePlate,
              ),
              SizedBox(height: 6.h),
              _buildCarDetailRow(
                context,
                locale.isDirectionRTL(context) ? 'العداد' : 'Kilometer',
                order.userCar.kilometer,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarDetailRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.almarai(
            fontSize: 13.sp,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.6)
                : Colors.white.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.almarai(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(
      BuildContext context,
      details.OrderItem item,
      AppLocalizations locale,
      ) {
    final priceText = _formatAmount(item.price ?? 0);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[850],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]!
              : Colors.grey[700]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.item.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Graphik Arabic',
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              _buildCurrencyRow(
                context,
                priceText,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Graphik Arabic',
                  color: typographyMainColor(context),
                ),
              ),
            ],
          ),
          if (item.item.description != null &&
              item.item.description!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              item.item.description!,
              style: GoogleFonts.almarai(
                fontSize: 13.sp,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.5),
              ),
            ),
          ],
          if (item.item.type != null ||
              item.item.size != null ||
              item.quantity != null) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 8.h,
              children: [
                if (item.item.type != null)
                  _buildItemChip(
                    context,
                    locale.isDirectionRTL(context) ? 'النوع' : 'Type',
                    item.item.type!,
                  ),
                if (item.item.size != null)
                  _buildItemChip(
                    context,
                    locale.isDirectionRTL(context) ? 'الحجم' : 'Size',
                    item.item.size!,
                  ),
                if (item.quantity != null)
                  _buildItemChip(
                    context,
                    locale.isDirectionRTL(context) ? 'الكمية' : 'Qty',
                    item.quantity.toString(),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemChip(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF5F5F5)
            : Colors.grey[800],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.almarai(
              fontSize: 12.sp,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.almarai(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(
      BuildContext context,
      details.OrderData order,
      AppLocalizations locale,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF5F5F5)
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.isDirectionRTL(context) ? 'ملخص الأسعار' : 'Price Summary',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Graphik Arabic',
              color: typographyMainColor(context),
            ),
          ),
          SizedBox(height: 12.h),
          _buildPriceRow(
            context,
            locale.isDirectionRTL(context) ? 'المجموع' : 'Subtotal',
            _formatAmount(order.total),
            locale,
          ),
          if (order.offerDiscount != null &&
              double.tryParse(order.offerDiscount.toString()) != null &&
              double.parse(order.offerDiscount.toString()) > 0)
            _buildPriceRow(
              context,
              locale.isDirectionRTL(context) ? 'خصم العروض' : 'Offer Discount',
              _formatAmount(order.offerDiscount),
              locale,
              isDiscount: true,
            ),
          if (order.pointsDiscount != null &&
              double.tryParse(order.pointsDiscount.toString()) != null &&
              double.parse(order.pointsDiscount.toString()) > 0)
            _buildPriceRow(
              context,
              locale.isDirectionRTL(context) ? 'خصم النقاط' : 'Points Discount',
              _formatAmount(order.pointsDiscount),
              locale,
              isDiscount: true,
            ),
          _buildPriceRow(
            context,
            locale.isDirectionRTL(context) ? 'الضريبة' : 'Tax',
            _formatAmount(order.taxAmount),
            locale,
          ),
          Divider(height: 20.h, thickness: 1),
          _buildPriceRow(
            context,
            locale.isDirectionRTL(context) ? 'الإجمالي النهائي' : 'Final Total',
            _formatAmount(order.finalTotal),
            locale,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      BuildContext context,
      String label,
      String value,
      AppLocalizations locale, {
        bool isDiscount = false,
        bool isBold = false,
      }) {
    final amountText = (isDiscount &&
        double.tryParse(value) != null &&
        double.parse(value) > 0)
        ? '-$value'
        : value;

    final textStyle = GoogleFonts.almarai(
      fontSize: isBold ? 16.sp : 14.sp,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
      color: isDiscount
          ? Colors.red
          : (isBold
          ? typographyMainColor(context)
          : (Theme.of(context).brightness == Brightness.light
          ? Colors.black
          : Colors.white)),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.almarai(
              fontSize: isBold ? 15.sp : 14.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(isBold ? 1 : 0.7)
                  : Colors.white.withOpacity(isBold ? 1 : 0.7),
            ),
          ),
          _buildCurrencyRow(context, amountText, style: textStyle),
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(
      BuildContext context,
      List<details.OrderHistory> histories,
      AppLocalizations locale,
      ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF5F5F5)
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: List.generate(histories.length, (index) {
          final history = histories[index];
          final isLast = index == histories.length - 1;
          return _buildHistoryItem(context, history, locale, isLast);
        }),
      ),
    );
  }

  Widget _buildHistoryItem(
      BuildContext context,
      details.OrderHistory history,
      AppLocalizations locale,
      bool isLast,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _getStatusColor(history.toStatus),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 50.h,
                color: _getStatusColor(history.toStatus).withOpacity(0.3),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.isDirectionRTL(context)
                      ? _translateStatusAr(history.toStatus)
                      : _translateStatusEn(history.toStatus),
                  style: GoogleFonts.almarai(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  history.createdAt,
                  style: GoogleFonts.almarai(
                    fontSize: 12.sp,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
                if (history.note != null && history.note!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    history.note!,
                    style: GoogleFonts.almarai(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.6)
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'rejected':
      case 'cancelled':
        return const Color(0xFFF44336);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'admin_approved':
      case 'car_delivered':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  String _translateStatusAr(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'مكتمل';
      case 'rejected':
        return 'مرفوض';
      case 'pending':
        return 'قيد الانتظار';
      case 'admin_approved':
        return 'موافق عليه';
      case 'car_delivered':
        return 'تم تسليم السيارة';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  String _translateStatusEn(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      case 'admin_approved':
        return 'Admin Approved';
      case 'car_delivered':
        return 'Car Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String _translateDeliveryMethodAr(String method) {
    switch (method.toLowerCase()) {
      case 'outsite':
      case 'outside':
        return 'توصيل خارجي';
      case 'inside':
        return 'داخلي';
      default:
        return method;
    }
  }

  String _translateDeliveryMethodEn(String method) {
    switch (method.toLowerCase()) {
      case 'outsite':
      case 'outside':
        return 'Outside Delivery';
      case 'inside':
        return 'Inside';
      default:
        return method;
    }
  }

  String _translatePaymentMethodAr(String method) {
    final m = method.trim().toLowerCase();

    switch (m) {
      case 'madfu':
        return 'مدفوع';
      case 'tamara':
        return 'تمارا';
      case 'cash':
      case 'cash_on_delivery':
      case 'cash on delivery':
        return 'الدفع عند الاستلام';
      case 'points':
        return 'نقاط';
      default:
        return method;
    }
  }

  String _translatePaymentMethodEn(String method) {
    final m = method.trim().toLowerCase();

    switch (m) {
      case 'madfu':
        return 'Madfu';
      case 'tamara':
        return 'Tamara';
      case 'cash':
      case 'cash_on_delivery':
      case 'cash on delivery':
        return 'Cash on Delivery';
      case 'points':
        return 'Points';
      default:
        return method;
    }
  }

}

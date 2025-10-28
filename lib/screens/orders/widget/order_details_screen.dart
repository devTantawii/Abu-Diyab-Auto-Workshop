import 'package:abu_diyab_workshop/screens/orders/widget/check_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/language/locale.dart';
import '../../services/widgets/Custom-Button.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/order_details_cubit.dart';
import '../cubit/order_details_state.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => OrderDetailsCubit()..getOrderDetails(orderId),
      child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is OrderDetailsError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('تفاصيل الطلب'),
                backgroundColor: const Color(0xFFBA1B1B),
              ),
              body: Center(child: Text(state.message)),
            );
          } else if (state is OrderDetailsSuccess) {
            final order = state.order;

            // ✅ كل الحالات الممكنة بالترتيب
            final allStatuses = [
              'pending',
              'admin_approved',
              'car_delivered',
              'inspection_done',
              'agree_inspection',
              'maintenance_done',
              'completed',
            ];

            // ✅ الحالة الحالية للطلب
            final currentStatus = order.status.toLowerCase();

            // ✅ شرط الزر
            final isButtonActive = currentStatus == 'inspection_done';

            return Scaffold(
              appBar: CustomGradientAppBar(
                title_ar: "تفاصيل طلب",
                title_en: "Order Details",
                onBack: () => Navigator.pop(context),
              ),

              // ✅ إضافة السحب للتحديث
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderDetailsCubit>().getOrderDetails(orderId);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                    Brightness.light
                                    ? const Color(0x3F000000)
                                    : const Color(0xFF9B8989),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locale!
                                                  .isDirectionRTL(context)
                                                  ? 'اسم الخدمة : '
                                                  : 'Service Name: ',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .brightness ==
                                                    Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 15.h,
                                                fontFamily: 'Graphik Arabic',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: order.items.first.item.name,
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
                                  ],
                                ),
                                const Divider(thickness: 0.7),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          locale.isDirectionRTL(context)
                                              ? 'رقم الطلب: '
                                              : 'Order No: ',
                                          style: TextStyle(
                                            color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
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
                                      child: order.userCar.brandIcon.isNotEmpty
                                          ? Image.network(
                                        order.userCar.brandIcon,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        'assets/icons/car_logo.png',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        _infoRow(
                                          context,
                                          locale.isDirectionRTL(context)
                                              ? 'الماركة:'
                                              : 'Brand:',
                                          "${order.userCar.brand} , ${order.userCar.model}",
                                        ),
                                        _infoRow(
                                          context,
                                          locale.isDirectionRTL(context)
                                              ? 'الممشى:'
                                              : 'KM:',
                                          order.userCar.kilometer,
                                        ),
                                        _infoRow(
                                          context,
                                          locale.isDirectionRTL(context)
                                              ? 'رقم اللوحة:'
                                              : 'Plate No:',
                                          order.userCar.licencePlate,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 0.7),

                                /// ✅ الحالات كلها بالترتيب
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: allStatuses.map((status) {
                                    final isDone =
                                        allStatuses.indexOf(status) <=
                                            allStatuses.indexOf(currentStatus);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: isDone
                                                ? const Color(0xFF1FAF38)
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            translateStatus(status),
                                            style: TextStyle(
                                              color: isDone
                                                  ? Colors.black
                                                  : Colors.grey,
                                              fontSize: 16.h,
                                              fontWeight: isDone
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              fontFamily: 'Graphik Arabic',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ الزر السفلي بناءً على الحالة
              bottomNavigationBar: CustomBottomButton(
                textAr: "عرض نتيجه الفحص",
                textEn: "Check Result",
                isEnabled: isButtonActive, // 👈 الزر يشتغل فقط في حالة inspection_done
                onPressed: isButtonActive
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckResultScreen(orderId: order.id),
                    ),
                  );
                }
                    : null, // 👈 الزر يتعطل في باقي الحالات
              ),
            );
          }
          return const SizedBox.shrink();
        },
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
            fontSize: 16.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFBA1B1B),
            fontSize: 16,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'admin_approved':
        return 'تمت الموافقة من الإدارة';
      case 'car_delivered':
        return 'تم استلام السيارة';
      case 'inspection_done':
        return 'تم الفحص';
      case 'agree_inspection':
        return 'تمت الموافقة على الفحص';
      case 'maintenance_done':
        return 'تمت الصيانة';
      case 'completed':
        return 'اكتمل';
      case 'rejected':
        return 'مرفوض';
      case 'cancelled':
        return 'تم الإلغاء';
      default:
        return status;
    }
  }
}

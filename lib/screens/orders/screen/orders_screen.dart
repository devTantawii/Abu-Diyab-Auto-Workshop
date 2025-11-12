import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/get_order_cubit.dart';
import '../cubit/get_order_state.dart';
import '../cubit/old_orders_cubit.dart';
import '../cubit/old_orders_state.dart';
import '../widget/active_order.dart';
import '../widget/old_order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _showActiveOrders = true;

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getAllOrders();
    context.read<OldOrdersCubit>().getOldOrders();
  }

  Future<void> _refresh() async {
    if (_showActiveOrders) {
      await context.read<OrdersCubit>().getAllOrders();
    } else {
      await context.read<OldOrdersCubit>().getOldOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor(context),

      appBar: CustomGradientAppBar(
        title_ar: "طلباتي",
        title_en: " My Orders",
        showBackIcon: false,
      ),

      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
          color:backgroundColor(context),

      ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _showActiveOrders = true);
                        },
                        child: Container(
                          height: 50.h,
                          decoration: ShapeDecoration(
                            color:
                                _showActiveOrders
                                    ? buttonPrimaryBgColor(context)
                                    : const Color(0xFFE0E0E0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              locale!.isDirectionRTL(context)
                                  ? 'الطلبات النشطة'
                                  : 'Active Orders',
                              style: TextStyle(
                                color:
                                    _showActiveOrders
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _showActiveOrders = false);
                        },
                        child: Container(
                          height: 50.h,
                          decoration: ShapeDecoration(
                            color:
                                !_showActiveOrders
                                    ?  buttonPrimaryBgColor(context)
                                    : const Color(0xFFE0E0E0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              locale!.isDirectionRTL(context)
                                  ? 'الطلبات القديمة'
                                  : 'Old Orders',
                              style: TextStyle(
                                color:
                                    !_showActiveOrders
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ✅ المحتوى داخل RefreshIndicator
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh, // ← هنا التحديث عند السحب
                  child:
                      _showActiveOrders
                          ? BlocBuilder<OrdersCubit, OrdersState>(
                            builder: (context, state) {
                              if (state is OrdersLoading) {
                                return Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Column(
                                    children: List.generate(2, (index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 20.h),
                                          width: double.infinity,
                                          height: 200.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15.r),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              }
                              else if (state is OrdersSuccess) {
                                final allowedStatuses = [
                                  'pending',
                                  'admin_approved',
                                  'car_delivered',
                                  'inspection_done',
                                  'agree_inspection',
                                  'maintenance_done',
                                ];

                                final activeOrders =
                                    state.orders
                                        .where(
                                          (o) =>
                                              allowedStatuses.contains(o.status),
                                        )
                                        .toList();

                                if (activeOrders.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/no_orders.png',
                                          width: 250.w,
                                          height: 192.h,
                                        ),
                                        Text(
                                          locale.isDirectionRTL(context)
                                              ? ' ما عندك طلبات نشطة الحين'
                                              : 'You have no active orders right now.',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Graphik Arabic',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: activeOrders.length,
                                  itemBuilder: (context, index) {
                                    final order = activeOrders[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ActiveOrder(order: order),
                                    );
                                  },
                                );
                              } else if (state is OrdersError) {
                                return Center(
                                  child: Text('حدث خطأ: ${state.message}'),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                          : BlocBuilder<OldOrdersCubit, OldOrdersState>(
                            builder: (context, state) {
                              if (state is OldOrdersLoading) {
                                return Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Column(
                                    children: List.generate(2, (index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 20.h),
                                          width: double.infinity,
                                          height: 200.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15.r),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );

                              } else if (state is OldOrdersSuccess) {
                                if (state.orders.isEmpty) {
                                  return const Center(
                                    child: Text('لا توجد طلبات قديمة'),
                                  );
                                }
                                return ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: state.orders.length,
                                  itemBuilder: (context, index) {
                                    final order = state.orders[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OldOrder(order: order),
                                    );
                                  },
                                );
                              } else if (state is OldOrdersError) {
                                return Center(
                                  child: Text('حدث خطأ: ${state.message}'),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

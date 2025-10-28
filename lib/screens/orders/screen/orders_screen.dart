  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';

  import '../../../core/language/locale.dart';
  import '../../../widgets/app_bar_widget.dart';
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
      // ✅ تحميل البيانات عند دخول الشاشة
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
        appBar: AppBar(
          toolbarHeight: 130.h,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Directionality(
            textDirection: Localizations.localeOf(context).languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Container(
              padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              decoration: buildAppBarDecoration(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locale!.isDirectionRTL(context) ? "طلباتي" : "My Orders",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        body: Column(
          children: [
            // ✅ أزرار التبديل بين الطلبات النشطة والقديمة
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _showActiveOrders = true);
                      },
                      child: Container(
                        height: 50,
                        decoration: ShapeDecoration(
                          color: _showActiveOrders
                              ? const Color(0xFFBA1B1B)
                              : const Color(0xFFE0E0E0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'الطلبات النشطة',
                            style: TextStyle(
                              color: _showActiveOrders
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _showActiveOrders = false);
                      },
                      child: Container(
                        height: 50,
                        decoration: ShapeDecoration(
                          color: !_showActiveOrders
                              ? const Color(0xFFBA1B1B)
                              : const Color(0xFFE0E0E0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'الطلبات القديمة',
                            style: TextStyle(
                              color: !_showActiveOrders
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18,
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

            const SizedBox(height: 16),

            // ✅ المحتوى داخل RefreshIndicator
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh, // ← هنا التحديث عند السحب
                child: _showActiveOrders
                    ? BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      );
                    } else if (state is OrdersSuccess) {
                      final allowedStatuses = [
                        'pending',
                        'admin_approved',
                        'car_delivered',
                        'inspection_done',
                        'agree_inspection',
                        'maintenance_done',
                      ];

                      final activeOrders = state.orders
                          .where((o) => allowedStatuses.contains(o.status))
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
                                'ما عندك طلبات نشطة الحين',
                                style: TextStyle(
                                  color: Colors.black,
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
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.red),
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
      );
    }
  }

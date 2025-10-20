import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../main/screen/main_screen.dart';

import '../cubit/get_order_cubit.dart';
import '../cubit/get_order_state.dart';
import '../repo/get_order_repo.dart';
import '../widget/active_order.dart';
import '../widget/old_order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

bool _showActiveOrders = true;

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => OrdersCubit(OrdersRepo(Dio()))..getAllOrders(),
      child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showActiveOrders = true;
                        });
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(10),
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
                        setState(() {
                          _showActiveOrders = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(10),
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
            Expanded(
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.red));
                  } else if (state is OrdersSuccess) {
                    final orders = _showActiveOrders
                        ? state.orders
                        .where((o) => o.status == 'pending')
                        .toList()
                        : state.orders
                        .where((o) => o.status != 'pending')
                        .toList();

                    if (orders.isEmpty) {
                      return const Center(child: Text('لا توجد طلبات حالياً'));
                    }

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ActiveOrder(order: order),
                        );
                      },
                    );
                  } else if (state is OrdersError) {
                    return Center(child: Text("خطأ: ${state.message}"));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/order_details_cubit.dart';
import '../cubit/order_details_state.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
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
              appBar: AppBar(title: const Text('تفاصيل الطلب')),
              body: Center(child: Text(state.message)),
            );
          } else if (state is OrderDetailsSuccess) {
            final order = state.order;
            return Scaffold(
              appBar: AppBar(
                title: Text('تفاصيل الطلب ${order.code}'),
                backgroundColor: const Color(0xFFBA1B1B),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("رقم الطلب: ${order.code}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("العنوان: ${order.address}"),
                    Text("التاريخ: ${order.date}"),
                    Text("الوقت: ${order.time}"),
                    Text("الحالة: ${order.status}"),
                    const Divider(height: 30, thickness: 1),
                    Text("بيانات العميل", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("${order.user.firstName} ${order.user.lastName}"),
                    Text("الهاتف: ${order.user.phone}"),
                    const Divider(height: 30, thickness: 1),
                    Text("بيانات السيارة", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("العلامة: ${order.userCar.brand}"),
                    Text("الموديل: ${order.userCar.model}"),
                    const Divider(height: 30, thickness: 1),
                    Text("العناصر", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ...order.items.map((item) => ListTile(
                      title: Text(item.item.name),
                      subtitle: Text(item.item.description),
                      trailing: Text("${item.price} ر.س"),
                    )),
                    const Divider(height: 30, thickness: 1),
                    Text("الصور", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: order.media
                            .map((m) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(m.media, height: 100, width: 100, fit: BoxFit.cover),
                          ),
                        ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

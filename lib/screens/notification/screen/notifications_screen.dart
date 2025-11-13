import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/error_widget_retry.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/noti_cubit.dart';
import '../cubit/noti_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => NotificationsCubit()..fetchNotifications(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: CustomGradientAppBar(
          title_ar: "الإشعارات",
          title_en: "Notifications",
          showBackIcon: true,
          onBack: () => Navigator.pop(context),
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              // 💫 تأثير التحميل Shimmer
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: List.generate(3, (index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        width: double.infinity,
                        height: 100.h,
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

            else if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                // 📭 حالة لا يوجد إشعارات
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined,
                            color: const Color(0xFF006D92), size: 80.sp),
                        SizedBox(height: 20.h),
                        Text(
                          locale!.isDirectionRTL(context)
                              ? "لا توجد إشعارات حالياً"
                              : "No notifications yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          locale.isDirectionRTL(context)
                              ? "سنقوم بإعلامك فور وصول تحديث جديد"
                              : "You’ll be notified when something new arrives.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // 📜 عرض قائمة الإشعارات
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🟦 دائرة جانبية بالألوان الرسمية
                        Container(
                          width: 10.w,
                          height: 10.w,
                          margin: EdgeInsets.only(top: 6.h, right: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF419BBA),
                            shape: BoxShape.circle,
                          ),
                        ),

                        // 📄 النصوص
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                notification.body,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade700,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  notification.createdAt,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF006D92),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            else if (state is NotificationsError) {
              // ⚠️ في حالة الخطأ
              return ErrorWidgetWithRetry(
                onRetry: () {
                  context.read<NotificationsCubit>().fetchNotifications();
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

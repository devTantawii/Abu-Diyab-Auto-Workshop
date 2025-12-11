// screens/my_packages_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';

import '../../services/widgets/custom_app_bar.dart';
import '../cubit/package_details_cubit.dart';

import '../cubit/subscriptions_cubit.dart';
import '../model/subscription_model.dart';
import '../widget/package_details_sheet.dart';

class MyPackagesScreen extends StatelessWidget {
  const MyPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => SubscriptionsCubit()..loadSubscriptions(),
      child: Scaffold(
        appBar: CustomGradientAppBar(
          title_ar: "باقاتي",
          title_en: "My Packages",
          onBack: () => Navigator.pop(context),
        ),
        body: const _SubscriptionsView(),
      ),
    );
  }
}

class _SubscriptionsView extends StatelessWidget {
  const _SubscriptionsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        if (state is SubscriptionsLoading || state is SubscriptionsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SubscriptionsError) {
          return Center(
            child: Text(
              "Error: ${state.message}",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is SubscriptionsLoaded) {
          final list = state.subscriptions;

          if (list.isEmpty) {
            return const Center(child: Text("No subscriptions found."));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: list.length,
            itemBuilder: (context, index) =>
                _SubscriptionCard(subscription: list[index]),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  const _SubscriptionCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final pkg = subscription.package;
    final locale = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: strokeGrayColor(context),
          width: 2.w,
        ),
        color: backgroundWhiteColor(context),
        borderRadius: BorderRadius.circular(15.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      pkg.title,
                      style: TextStyle(
                        color: headingColor(context),
                        fontSize: 22.sp,
                        fontFamily: "Graphik Arabic",
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      pkg.description,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: paragraphColor(context),
                        fontSize: 12.sp,
                        fontFamily: "Graphik Arabic",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Text(
                    subscription.price,
                    style: TextStyle(
                      color: primaryColor(context),
                      fontSize: 20.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Image.asset(
                    "assets/icons/ryal.png",
                    width: 18.w,
                    height: 18.h,
                    color: primaryColor(context),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          /// DETAILS (الخدمات)
          Column(
            children: pkg.details.map((d) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: iconGrayColor(context),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),

                    Expanded(
                      child: Text(
                        "${d.service.name} - خصم ${d.discount}%",
                        style: TextStyle(
                          color: primaryColor(context),
                          fontSize: 14.sp,
                          fontFamily: "Graphik Arabic",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          Divider(
            height: 25.h,
            color: strokeGrayColor(context),
          ),

          /// VALIDITY + EXPIRE DATE
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                locale!.isDirectionRTL(context)
                    ? "تاريخ الانتهاء : "
                    : "Expires at: ",
                style: TextStyle(
                  color: headingColor(context),
                  fontSize: 18.sp,
                  fontFamily: "Graphik Arabic",
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subscription.expiredAt
                    .toLocal()
                    .toIso8601String()
                    .split("T")
                    .first,
                style: TextStyle(
                  color: primaryColor(context),
                  fontSize: 16.sp,
                  fontFamily: "Graphik Arabic",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

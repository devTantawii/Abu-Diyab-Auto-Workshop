import 'package:abu_diyab_workshop/screens/profile/cubit/profile_cubit.dart';
import 'package:abu_diyab_workshop/screens/profile/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../cubit/reward_logs_cubit.dart';
import '../cubit/reward_logs_state.dart';
import '../model/reward_log_model.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({super.key});

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().fetchProfile();
    context.read<RewardLogsCubit>().fetchRewardLogs();

  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // حالة التحميل
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // حالة البيانات (مسجل دخول)
          if (state is ProfileLoaded) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFBFFD0), Color(0xFFBA1B1B)],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        textDirection: locale!.isDirectionRTL(context)
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        children: [
                          Expanded(
                            child: Text(
                              locale!.isDirectionRTL(context)
                                  ? 'شارك التطبيق واربح معنا !'
                                  : 'Share the app and win !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Material(
                            shape: const CircleBorder(),
                            elevation: 3,
                            color: Colors.white,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Transform.translate(
                                offset: Offset(-2.w, 0),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // دعوة الأصدقاء
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            locale!.isDirectionRTL(context)
                                ? 'ادع أصدقائك وأحصل علي 20'
                                : 'Invite your friends and get 20',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF474747),
                              fontSize: 14.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Image.asset(
                            "assets/icons/ryal.png",
                            color: const Color(0xFF474747),
                            width: 14.w,
                            height: 14.h,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // خطوات المشاركة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StepIcon(
                            icon: Icons.share,
                            label:
                                locale!.isDirectionRTL(context)
                                    ? "1. شارك الرابط"
                                    : "1. Share the link",
                            imagePath: "assets/images/vector_down.png",
                          ),
                          _StepIcon(
                            icon: Icons.person_add,
                            label:
                                locale!.isDirectionRTL(context)
                                    ? "2. صديقك يسجل"
                                    : "2. Your friend is registering",
                            imagePath: "assets/images/vector_up.png",
                          ),
                          SizedBox(width: 6.w),
                          _StepIcon(
                            icon: Icons.card_giftcard,
                            label:
                                locale!.isDirectionRTL(context)
                                    ? "3. اربح مكافأت"
                                    : "3. Earn rewards",
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // كود الدعوة
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: ShapeDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black87,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.5.w,
                              color: Color(0xFF9B9B9B),
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              locale!.isDirectionRTL(context)
                                  ? "كود الدعوة الخاص بك"
                                  : "Your invitation code",
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white70,
                                fontSize: 16.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              textDirection: TextDirection.ltr,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final code =
                                          state.user.referralCode?.toString() ??
                                          '';
                                      if (code.isNotEmpty) {
                                        await Clipboard.setData(
                                          ClipboardData(text: code),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              locale!.isDirectionRTL(context)
                                                  ? "تم نسخ الكود: $code"
                                                  : "Copied: $code",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 40.h,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFBA1B1B),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          locale!.isDirectionRTL(context)
                                              ? "   نسخ"
                                              : "  Copy",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Flexible(
                                  flex: 6,
                                  child: Container(
                                    height: 40.h,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1.w,
                                          color: Color(0xFFBA1B1B),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        state.user.referralCode?.toString() ??
                                            'Login To Win',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).brightness ==
                                                      Brightness.light
                                                  ? Color(0xFF474747)
                                                  : Colors.white70,
                                          fontSize: 18.sp,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // زر المشاركة
                      Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFBA1B1B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              locale!.isDirectionRTL(context)
                                  ? "   مشاركة الآن"
                                  : "  Share now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Image.asset(
                              "assets/icons/telegram.png",
                              width: 18.w,
                              height: 18.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // الرصيد الحالي
                      Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.5.w,
                              color: Color(0xFFBA1B1B),
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12.r,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),
                              Text(
                                locale!.isDirectionRTL(context)
                                    ? "   رصيدك الحالي"
                                    : "  Your current balance",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white70,
                                  fontSize: 20.sp,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.user.wallet?.toString() ?? '0',
                                    style: TextStyle(
                                      color: const Color(0xFFBA1B1B),
                                      fontSize: 25.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/icons/ryal.png",
                                    width: 20.w,
                                    height: 22.h,
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: 50.h,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFBA1B1B),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          locale!.isDirectionRTL(context)
                                              ? "   عدد الإحالات الخاصه بك"
                                              : "  Your number of referrals",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 50.h,
                                      decoration: ShapeDecoration(
                                        color: Theme.of(context).brightness == Brightness.light
                                            ? Colors.white70
                                            : Colors.black54,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1.5.w,
                                            color: const Color(0xFF9B9B9B),
                                          ),
                                          borderRadius: BorderRadius.circular(15.r),
                                        ),
                                      ),
                                      child: BlocBuilder<RewardLogsCubit, RewardLogsState>(
                                        builder: (context, rewardState) {
                                          if (rewardState is RewardLogsLoading) {
                                            return const Center(child: CircularProgressIndicator());
                                          } else if (rewardState is RewardLogsLoaded) {
                                            final logs = rewardState.data.logs;
                                            final referralsCount = logs.length; // ← احسب العدد اللي يناسبك هنا
                                            return Center(
                                              child: Text(
                                                '$referralsCount',
                                                style: TextStyle(
                                                  color: Theme.of(context).brightness == Brightness.light
                                                      ? Colors.black
                                                      : Colors.white70,
                                                  fontSize: 18.sp,
                                                  fontFamily: 'Graphik Arabic',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Center(
                                              child: Text(
                                                '-',
                                                style: TextStyle(
                                                  color: Theme.of(context).brightness == Brightness.light
                                                      ? Colors.black
                                                      : Colors.white70,
                                                  fontSize: 18.sp,
                                                  fontFamily: 'Graphik Arabic',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // === سجل المكافآت ===
                      Row(
                        children: [
                          Text(
                            locale!.isDirectionRTL(context)
                                ? "   سجل المكافأت"
                                : " Reward Record",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // ← هنا الجزء الجديد
                      BlocBuilder<RewardLogsCubit, RewardLogsState>(
                        builder: (context, state) {
                          if (state is RewardLogsLoading) {
                            return _buildLogsContainer(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (state is RewardLogsLoaded) {
                            final logs = state.data.logs;
                            if (logs.isEmpty) {
                              return _buildLogsContainer(
                                child: Center(
                                  child: Text(
                                    locale!.isDirectionRTL(context)
                                        ? "لا توجد مكافآت بعد"
                                        : "No rewards yet",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return _buildLogsContainer(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                itemCount: logs.length,
                                itemBuilder: (context, index) {
                                  final log = logs[index];
                                  return _buildLogItem(log, locale, context);
                                },
                              ),
                            );
                          }

                          if (state is RewardLogsError) {
                            return _buildLogsContainer(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      locale!.isDirectionRTL(context)
                                          ? "فشل تحميل السجل"
                                          : "Failed to load",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    ElevatedButton(
                                      onPressed:
                                          () =>
                                              context
                                                  .read<RewardLogsCubit>()
                                                  .fetchRewardLogs(),
                                      child: Text(
                                        locale!.isDirectionRTL(context)
                                            ? "إعادة"
                                            : "Retry",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return _buildLogsContainer(
                            child: Center(
                              child: Text(
                                "سجل المكافآت هنا...",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // حالة افتراضية (غير مسجل أو خطأ)
          return Center(
            child: Text(
              locale!.isDirectionRTL(context)
                  ? "سجل الدخول لرؤية المحتوى"
                  : "Login to view content",
              style: TextStyle(fontSize: 18.sp),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogsContainer({required Widget child}) {
    return Container(
      width: 350.w,
      height: 239.h,
      decoration: ShapeDecoration(
        color:
            Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.5.w, color: const Color(0xFF9B9B9B)),
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
      child: child,
    );
  }

  Widget _buildLogItem(
    RewardLog log,
    AppLocalizations locale,
    BuildContext context,
  ) {
    final isRTL = locale.isDirectionRTL(context);
    final sign = log.isAddition ? '+' : '-';
    final color = log.isAddition ? Colors.green : Colors.red;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    sign,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTypeText(log.type, locale),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black87
                                : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${log.isAddition ? '+' : '-'}${log.points}',
                style: TextStyle(
                  color: log.isAddition ? Colors.green : Colors.red,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),


              Image.asset(
                'assets/icons/ryal.png',
                width: 15.w,
                height: 15.h,
                color: color,
              ),
            ],
          ),
          Text(
            " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
  String _getTypeText(String type, AppLocalizations locale) {
    final isRTL = locale.isDirectionRTL(context);

    switch (type) {
      case 'referral':
        return isRTL ? 'دعوة صديق' : 'Invite a friend';
      case 'task':
        return isRTL ? 'مهمة' : 'Task';
      case 'order':
        return isRTL ? 'طلب' : 'Order';
      default:
        return type;
    }
  }

}

class _StepIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? imagePath;

  const _StepIcon({required this.icon, required this.label, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black87,
              child: Icon(icon, size: 28.sp, color: Color(0xFFBA1B1B)),
            ),
            if (imagePath != null) ...[
              SizedBox(width: 6.w),
              Image.asset(imagePath!, width: 60.w, fit: BoxFit.fill),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 10.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

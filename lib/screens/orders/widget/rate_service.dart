// lib/features/rate_service/ui/rate_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/rate_service_cubit.dart';

class RateService extends StatelessWidget {
  final int serviceID;

  const RateService({super.key, required this.serviceID});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RateServiceCubit(),
      child: _RateServiceView(serviceID: serviceID),
    );
  }
}

class _RateServiceView extends StatefulWidget {
  final int serviceID;

  const _RateServiceView({required this.serviceID});

  @override
  State<_RateServiceView> createState() => _RateServiceViewState();
}

class _RateServiceViewState extends State<_RateServiceView> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      context.read<RateServiceCubit>().setComment(_notesController.text);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isRTL = locale.isDirectionRTL(context);

    return Scaffold(
      appBar: CustomGradientAppBar(
        title_ar: "تقييم الخدمة",
        title_en: "Service Rating",
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                isRTL
                    ? 'وش رأيك بخدمتنا؟'
                    : 'What do you think of our service?',
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                  fontSize: 16.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text("🤔", style: TextStyle(fontSize: 100.sp)),
              SizedBox(height: 20.h),

              // نجوم التقييم
              BlocBuilder<RateServiceCubit, RateServiceState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          context.read<RateServiceCubit>().setRating(index + 1);
                        },
                        child: Icon(
                          Icons.star,
                          color:
                              index < state.rating ? Colors.amber : Colors.grey,
                          size: 40.sp,
                        ),
                      );
                    }),
                  );
                },
              ),
              SizedBox(height: 10.h),
              BlocBuilder<RateServiceCubit, RateServiceState>(
                builder: (context, state) {
                  return Text(
                    state.rating == 0
                        ? (isRTL ? 'اختر تقييمك' : 'Choose your rating')
                        : '${state.rating} / 5',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontFamily: 'Graphik Arabic',
                    ),
                  );
                },
              ),
              SizedBox(height: 30.h),

              // حقل الملاحظات
              TextField(
                controller: _notesController,
                maxLines: 5,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText:
                      isRTL
                          ? 'اكتب ملاحظاتك هنا (اختياري)'
                          : 'Write your notes here (optional)',
                  hintStyle: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                    fontFamily: 'Graphik Arabic',
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,

                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5.w),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey, width: 2.w),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Graphik Arabic',
                  fontSize: 14.sp,
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                ),
              ),
              SizedBox(height: 50.h),

              // زر الإرسال
              SizedBox(
                width: 250.w,
                child: BlocConsumer<RateServiceCubit, RateServiceState>(
                  listener: (context, state) {
                    if (state.status == RateServiceStatus.success) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 32.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/rate_success.png",
                                  width: 220.w,
                                  height: 220.h,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  isRTL ? 'يعطيك العافية!' : 'Thank you!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: typographyMainColor(context),
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Graphik Arabic',
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  isRTL
                                      ? 'ملاحظاتك تساعدنا نصير أفضل 😍'
                                      : 'Your feedback helps us improve 😍',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    color: Colors.black,
                                    fontFamily: 'Graphik Arabic',
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      ); // يغلق البوتوم شيت
                                      Navigator.pop(
                                        context,
                                      ); // يرجع لصفحة سابقة
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: typographyMainColor(
                                        context,
                                      ),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                    ),
                                    child: Text(
                                      isRTL ? 'تم' : 'Done',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Graphik Arabic',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state.status == RateServiceStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage ?? 'حدث خطأ'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state.status == RateServiceStatus.loading ||
                                  state.rating == 0
                              ? null
                              : () => context
                                  .read<RateServiceCubit>()
                                  .submitReview(widget.serviceID),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        backgroundColor:
                            state.rating == 0
                                ? Colors.grey
                                :                            typographyMainColor(context),

                      foregroundColor: Colors.white,
                      ),
                      child:
                          state.status == RateServiceStatus.loading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                isRTL ? 'إرسال التقييم' : 'Submit Rating',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Graphik Arabic',
                                ),
                              ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

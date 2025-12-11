import 'package:abu_diyab_workshop/screens/packages/widget/payment_BSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/progress_bar.dart';
import '../cubit/package_details_cubit.dart';
import '../cubit/package_details_state.dart';

class PackageDetailsSheet extends StatefulWidget {
  final int packageId;

  const PackageDetailsSheet({super.key, required this.packageId});

  @override
  State<PackageDetailsSheet> createState() => _PackageDetailsSheetState();
}

class _PackageDetailsSheetState extends State<PackageDetailsSheet> {
  @override
  void initState() {
    super.initState();
    context.read<PackageDetailsCubit>().getPackageDetails(widget.packageId);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocBuilder<PackageDetailsCubit, PackageDetailsState>(
      builder: (context, state) {
        if (state is PackageDetailsLoading) {
          return SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PackageDetailsFailure) {
          return SizedBox(
            height: 300,
            child: Center(child: Text(state.message)),
          );
        }

        if (state is PackageDetailsSuccess) {
          final data = state.data;

          return Container(
            height: 0.60.sh,
            decoration: BoxDecoration(
              color: backgroundWhiteColor(context),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ProgressBar(),
                            ProgressBar(active: true),
                            ProgressBar(),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name,
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                      color: headingColor(context),
                                      fontFamily: 'Graphik Arabic',
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    data.description,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: paragraphColor(context),
                                      fontFamily: 'Graphik Arabic',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  data.details.map((detail) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10.w,
                                            height: 10.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  detail.service.name,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: primaryColor(
                                                      context,
                                                    ),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'Graphik Arabic',
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  detail.service.description,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: paragraphColor(
                                                      context,
                                                    ),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'Graphik Arabic',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Row(
                          children: [
                            Text(
                              locale!.isDirectionRTL(context)
                                  ? "صلاحية الباقة : "
                                  : "Package Validity: ",
                              style: TextStyle(
                                color: headingColor(context),
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              locale!.isDirectionRTL(context)
                                  ? "(${data.duration} شهور)"
                                  : "( Month ${data.duration})",
                              style: TextStyle(
                                color: primaryColor(context),
                                fontSize: 16.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: backgroundWhiteColor(context),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2.w, color: Color(0xFF9B9B9B)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 20.w,
                        ),
                        child: Row(
                          children: [
                            Text(
                              locale!.isDirectionRTL(context)
                                  ? "الإجمالي"
                                  : "Total",
                              style: TextStyle(
                                color: headingColor(context),
                                fontSize: 16,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Text(
                              data.price,
                              style: TextStyle(
                                color: primaryColor(context),
                                fontSize: 16.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Image.asset(
                              "assets/icons/ryal.png",
                              width: 15.w,
                              height: 15.h,
                              color: primaryColor(context),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),

                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return PaymentBsheet(packageId: data.id);
                            },
                          );
                        },

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: primaryColor(context),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              locale!.isDirectionRTL(context)
                                  ? "اشترك الآن"
                                  : "Subscribe Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox();
      },
    );
  }
}

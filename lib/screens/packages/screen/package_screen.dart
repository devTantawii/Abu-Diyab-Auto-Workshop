import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/get_pack_cubit.dart';
import '../cubit/get_pack_state.dart';
import '../cubit/package_details_cubit.dart';
import '../widget/package_details_sheet.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomGradientAppBar(
        title_ar: "الباقات",
        title_en: "packages",
        onBack: () => Navigator.pop(context),
      ),
      body: BlocProvider(
        create: (_) => PackagesCubit()..getPackages(),
        child: BlocBuilder<PackagesCubit, PackagesState>(
          builder: (context, state) {
            if (state is PackagesLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is PackagesSuccess) {
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.packages.length,
                itemBuilder: (context, index) {
                  final package = state.packages[index];

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return BlocProvider(
                            create: (_) => PackageDetailsCubit(),
                            child: PackageDetailsSheet(packageId: package.id),
                          );
                        },
                      );
                    },
                    child: Container(
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
                                  children: [
                                    Text(
                                      package.name,
                                      style: TextStyle(
                                        color: headingColor(context),
                                        fontSize: 22.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    SizedBox(height: 4.h),

                                    Text(
                                      package.description,
                                      style: TextStyle(
                                        color: paragraphColor(context),
                                        fontSize: 11.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    package.price,
                                    style: TextStyle(
                                      color: primaryColor(context),
                                      fontSize: 20.sp,
                                      fontFamily: 'Poppins',
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
                          Column(
                            children:
                                package.details.map((detail) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  detail.service.name,
                                                  style: TextStyle(
                                                    color: primaryColor(
                                                      context,
                                                    ),
                                                    fontSize: 14.sp,
                                                    fontFamily:
                                                        'Graphik Arabic',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  detail.service.description,
                                                  style: TextStyle(
                                                    color: paragraphColor(
                                                      context,
                                                    ),
                                                    fontSize: 12.sp,
                                                    fontFamily:
                                                        'Graphik Arabic',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                    ? "(${package.duration} شهور)"
                                    : "( Month ${package.duration})",
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
                  );
                },
              );
            }

            if (state is PackagesFailure) {
              return Center(child: Text("Error: "));
              //       return Center(child: Text("Error: ${state.error}"));
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}

// lib/screens/final_review/widgets/car_details_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../my_car/cubit/all_cars_state.dart';


class CarDetailsSection extends StatelessWidget {
  final int? userCarId;

  const CarDetailsSection({super.key, this.userCarId});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              locale!.isDirectionRTL(context) ? " السيارة " : "The car",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        BlocBuilder<CarCubit, CarState>(
          builder: (context, state) {
            if (state is SingleCarLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SingleCarLoaded) {
              final car = state.car;
              return _buildCarCard(context, car, locale);
            } else if (state is SingleCarError) {
              return Text(
                state.message,
                style: TextStyle(color: Colors.red),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _buildCarCard(BuildContext context, dynamic car, AppLocalizations locale) {
    return Container(
      decoration: BoxDecoration(
        color: boxcolor(context),
        border: Border.all(color: borderColor(context), width: 1.5.w),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      padding: EdgeInsets.all(8.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.sp),
              child: Image.network(
                car.carBrand.icon ?? "",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  "assets/images/main_pack.png",
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      locale.isDirectionRTL(context) ? "الموديل:" : "Model:",
                      style: TextStyle(
                        color: textColor(context),
                        fontSize: 12.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        " ${car.carBrand.name} ${car.carModel.name} ${car.year ?? ''}",
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 13.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      locale.isDirectionRTL(context) ? "رقم اللوحة:" : "license plate number:",
                      style: TextStyle(
                        color: textColor(context),
                        fontSize: 12.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        " ${car.licencePlate}",
                        style: TextStyle(
                          color: Color(0xFFBA1B1B),
                          fontSize: 13.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      locale.isDirectionRTL(context) ? "الممشي:" : "Car mileage:",
                      style: TextStyle(
                        color: textColor(context),
                        fontSize: 12.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        " ${car.kilometer ?? '--'} كم",
                        style: TextStyle(
                          color: Color(0xFFBA1B1B),
                          fontSize: 13.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.3.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
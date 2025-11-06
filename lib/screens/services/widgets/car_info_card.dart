import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../my_car/cubit/all_cars_state.dart';

class CarInfoSection extends StatelessWidget {
  const CarInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    late final locale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale!.isDirectionRTL(context)
              ? " السيارة "
              : "The car",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: headingColor(context),
          ),
        ),
        SizedBox(height: 10.h),
        BlocBuilder<CarCubit, CarState>(
          builder: (context, state) {
            if (state is SingleCarLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SingleCarLoaded) {
              final car = state.car;
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: buttonBgWhiteColor(context),
                  border: Border.all(color: buttonSecondaryBorderColor(context), width: 1.5.w),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                padding: EdgeInsets.all(8.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        car.carBrand.icon ?? "",
                        width: 90.w,
                        height: 90.w,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            Image.asset("assets/images/main_pack.png", width: 90
                                .w, height: 90.w),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _carDetailRow(
                            context,
                            locale.isDirectionRTL(context) ? "الموديل:" : "Model:",
                            "${car.carBrand.name} ${car.carModel.name} ${car.year ?? ''}",
                          ),
                          SizedBox(height: 6.h),
                          _carDetailRow(context,
                              locale.isDirectionRTL(context) ? "رقم اللوحة:" : "license plate number:",
                              car.licencePlate ?? '--'),
                          SizedBox(height: 6.h),
                          _carDetailRow(context,
                            locale.isDirectionRTL(context) ? "الممشي:" : "Car mileage:",
                            "${car.kilometer ?? '--'} كم",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is SingleCarError) {
              return Text(state.message, style: TextStyle(color: Colors.red));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _carDetailRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: headingColor(context),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color:accentColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              height: 1.3.h,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
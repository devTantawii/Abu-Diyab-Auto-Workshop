import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../my_car/cubit/all_cars_cubit.dart';
import '../../my_car/cubit/all_cars_state.dart';

class CarInfoSection extends StatelessWidget {
  const CarInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "السيارة",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
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
                height: 107.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xff1D1D1D),
                  border: Border.all(color: Colors.grey, width: 1.5.w),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                padding: EdgeInsets.all(8.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        car.carBrand.icon ?? "",
                        width: 100.w,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Image.asset("assets/images/main_pack.png"),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _carDetailRow(
                            "الموديل:",
                            "${car.carBrand.name} ${car.carModel.name} ${car.year ?? ''}",
                          ),
                          const Spacer(),
                          _carDetailRow("رقم اللوحة:", car.licencePlate ?? '--'),
                          const Spacer(),
                          _carDetailRow(
                            "الممشى:",
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

  Widget _carDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFFBA1B1B),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.69,
          ),
        ),
      ],
    );
  }
}

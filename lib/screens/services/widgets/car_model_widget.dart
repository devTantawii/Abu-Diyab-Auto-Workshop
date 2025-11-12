// ملف car_model_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../my_car/cubit/CarModelCubit.dart';
import '../../my_car/cubit/CarModelState.dart';
import '../cubit/battery_cubit.dart';

class CarModelWidget extends StatelessWidget {
  final String titleAr;
  final String titleEn;
  final int? selectedCarModelId;
  final Function(int modelId) onModelSelected;

  const CarModelWidget({
    Key? key,
    required this.titleAr,
    required this.titleEn,
    required this.selectedCarModelId,
    required this.onModelSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---------------- العنوان ----------------
        Align(
          alignment: locale.isDirectionRTL(context)
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            locale.isDirectionRTL(context) ? titleAr : titleEn,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 14.sp,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 10.h),

        /// ---------------- الموديلات ----------------
        BlocBuilder<CarModelCubit, CarModelState>(
          builder: (context, state) {
            if (state is CarModelLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CarModelLoaded) {
              if (state.models.isEmpty) {
                return Center(
                  child: Text(
                    state.message ?? "لا توجد موديلات متاحة",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 50.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.models.length,

                  itemBuilder: (context, index) {
                    final car = state.models[index];
                    final isSelected = selectedCarModelId == car.id;

                    return GestureDetector(
                      onTap: () {
                        onModelSelected(car.id);
                  //      context.read<BatteryCubit>().fetchServicesByModel(car.id);
                      },
                      child: Container(
                        width: 70.w,
                        height: 50.h,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? buttonPrimaryBgColor(context).withOpacity(0.3) // شفافية 50%
                              : Theme.of(context).brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? buttonPrimaryBgColor(context)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),                        alignment: Alignment.center,
                        child: Text(
                          car.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: 10.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is CarModelError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}

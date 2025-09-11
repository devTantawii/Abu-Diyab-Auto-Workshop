import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/language/locale.dart';
import '../../my_car/cubit/CarModelCubit.dart';
import '../../my_car/cubit/car_brand_cubit.dart';
import '../../my_car/cubit/car_brand_state.dart';

class CarBrandSection extends StatelessWidget {
  final String titleAr;
  final String titleEn;
  final int? selectedCarBrandId;
  final Function(int brandId) onBrandSelected;

  const CarBrandSection({
    Key? key,
    required this.titleAr,
    required this.titleEn,
    required this.selectedCarBrandId,
    required this.onBrandSelected,
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

        /// ---------------- الماركات ----------------
        BlocBuilder<CarBrandCubit, CarBrandState>(
          builder: (context, state) {
            if (state is CarBrandLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CarBrandLoaded) {
              return SizedBox(
                height: 110.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.brands.length,
                  itemBuilder: (context, index) {
                    final car = state.brands[index];
                    final isSelected = selectedCarBrandId == car.id;

                    return GestureDetector(
                      onTap: () {
                        onBrandSelected(car.id);
                        context.read<CarModelCubit>().fetchCarModels(car.id);
                      },
                      child: Container(
                        width: 80.w,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE19A9A)
                              : Theme.of(context).brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFBA1B1B)
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
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              car.image,
                              width: 40.w,
                              height: 40.h,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 24),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              car.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                isSelected ? Colors.black : Colors.grey,
                                fontSize: 12.h,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is CarBrandError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),

        SizedBox(height: 15.h),
      ],
    );
  }
}

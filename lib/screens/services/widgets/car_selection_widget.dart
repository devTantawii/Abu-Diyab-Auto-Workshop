import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../my_car/cubit/all_cars_state.dart';
import '../../my_car/model/all_cars_model.dart';
import '../../my_car/screen/widget/details_item.dart';
import '../../my_car/widget/bottom_add_car.dart';



class CarsSection extends StatefulWidget {
  final Function(int brandId, int modelId)? onCarSelected;

  const CarsSection({super.key, this.onCarSelected});

  @override
  State<CarsSection> createState() => _CarsSectionState();
}

class _CarsSectionState extends State<CarsSection> {
  late CarCubit _cubit;

  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  @override
  void initState() {
    super.initState();
    _cubit = CarCubit();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    _cubit.fetchCars(token);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        GestureDetector(
          onTap: () async {
            final added = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const AddCarBottomSheet(),
            );

            if (added == true) {
              await _loadCars();
              if (mounted) setState(() {});
            }
          },
          child: Container(
            height: 30.h,
            width: 70.w,
            alignment: Alignment.center,
            child: Text(
              'add car',
              style: TextStyle(
                color: const Color(0xFFBA1B1B),
                fontSize: 15.sp,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          height: 120.h,
          width: double.infinity,
          child: BlocProvider.value(
            value: _cubit,
            child: BlocBuilder<CarCubit, CarState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state is CarLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.red,
                    ),
                  );
                } else if (state is CarError) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                  );
                } else if (state is CarLoaded) {
                  if (state.cars.isEmpty) {
                    return const Center(child: Text("لا توجد سيارات"));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.cars.length,
                    itemBuilder: (context, index) {
                      final car = state.cars[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: _carCard(context, car, true, locale),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
  Widget _carCard(
      BuildContext context,
      Car car,
      bool withEditNav,
      AppLocalizations locale,
      ) {
    final isSelected = _selectedCarBrandId == car.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCarBrandId = null;
            _selectedCarModelId = null;
          } else {
            _selectedCarBrandId = car.id;
            _selectedCarModelId = car.carModel['id'];
          }
        });

        if (widget.onCarSelected != null) {
          widget.onCarSelected!(_selectedCarBrandId!, _selectedCarModelId!);
        }
      },

      child: Container(
        width: 330.w,
        decoration: ShapeDecoration(
          color: isSelected
              ? const Color(0xFFBA1B1B).withOpacity(0.2) // لون مميز للكارت المحدد
              : Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.50,
                color: isSelected
                    ? const Color(0xFFBA1B1B)
                    : const Color(0xFF9B9B9B)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: NetworkImage(
                    car.carBrand['icon'] ?? 'https://via.placeholder.com/150',
                  ),
                  onError: (exception, stackTrace) {
                    debugPrint('❌ Error loading image: $exception');
                  },
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DetailItem(
                    labelAr: 'الموديل:',
                    value: '${car.carBrand['name']} ${car.carModel['name']}',
                    labelEn: 'car brand :',
                  ),
                  DetailItem(
                    labelAr: 'رقم اللوحة:',
                    value: car.licencePlate,
                    labelEn: 'Car Model :',
                  ),
                  DetailItem(
                    labelAr: 'سنة الصنع:',
                    value: car.year?.toString() ?? '',
                    labelEn: 'Year :',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

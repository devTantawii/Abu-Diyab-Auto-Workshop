import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
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
  /// ✅ هنخلي الكول باك يرجع user_car_id فقط
  final Function(int userCarId)? onCarSelected;

  const CarsSection({super.key, this.onCarSelected});

  @override
  State<CarsSection> createState() => _CarsSectionState();
}

class _CarsSectionState extends State<CarsSection> {
  late CarCubit _cubit;
  int? _selectedUserCarId;

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
        Row(
          children: [
            Text(
              locale.isDirectionRTL(context) ? "السيارة" : 'Car',
              style: TextStyle(
                color: accentColor,
                fontSize: 15.sp,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CarError) {
                  return Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40.sp,
                    ),
                  );
                } else if (state is CarLoaded) {
                  if (state.cars.isEmpty) {
                    return Center(
                      child: GestureDetector(
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
                          width: MediaQuery.of(context).size.width * 0.87,
                          decoration: ShapeDecoration(
                            color: boxcolor(context),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.50.w,
                                color: borderColor(context),
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '+ إضافة سيارة',
                              style: TextStyle(
                                color: const Color(0xFFBA1B1B),
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...state.cars.map(
                            (car) => Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: _carCard(context, car, locale),
                        ),
                      ),
                      SizedBox(width: 10.w),
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
                          width: MediaQuery.of(context).size.width * 0.87,
                          decoration: ShapeDecoration(
                            color: boxcolor(context),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.50.w,
                                color: borderColor(context),
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '+ إضافة سيارة',
                              style: TextStyle(
                                color: const Color(0xFFBA1B1B),
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _carCard(BuildContext context, Car car, AppLocalizations locale) {
    final isSelected = _selectedUserCarId == car.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserCarId = isSelected ? null : car.id;
        });

        /// ✅ نرسل الـ user_car_id فقط للـ parent
        if (widget.onCarSelected != null && _selectedUserCarId != null) {
          widget.onCarSelected!(_selectedUserCarId!);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.87,
        decoration: ShapeDecoration(
          color: isSelected
              ? const Color(0xFFBA1B1B).withOpacity(0.2)
              : boxcolor(context),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.50.w,
              color: isSelected ? accentColor : borderColor(context),
            ),
            borderRadius: BorderRadius.circular(15.r),
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
                    car.carBrand.icon ?? 'https://via.placeholder.com/150',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailItem(
                    labelAr: 'الموديل:',
                    value: '${car.carBrand.name} ${car.carModel.name}',
                    labelEn: 'Car:',
                  ),
                  DetailItem(
                    labelAr: 'رقم اللوحة:',
                    value: car.licencePlate,
                    labelEn: 'Plate:',
                  ),
                  DetailItem(
                    labelAr: 'سنة الصنع:',
                    value: car.year?.toString() ?? '',
                    labelEn: 'Year:',
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

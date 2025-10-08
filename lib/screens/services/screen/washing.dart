import 'dart:io';
import 'package:abu_diyab_workshop/screens/services/cubit/washing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/language/locale.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../my_car/model/all_cars_model.dart';
import '../../my_car/screen/widget/details_item.dart';
import '../../my_car/screen/widget/image_picker.dart';
import '../cubit/car_check_cubit.dart';
import '../cubit/washing_state.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/NotesAndCarCounter-Section.dart';
import '../widgets/car_selection_widget.dart';
import '../widgets/custom_app_bar.dart';

class Washing extends StatefulWidget {
  const Washing({super.key});

  @override
  State<Washing> createState() => _WashingState();
}

class _WashingState extends State<Washing> {
  late CarCubit _cubit;

  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  int? _selectedServiceIndex; // العنصر المختار فقط
  final int itemsPerPage = 4; // عدد المنتجات لكل صفحة

  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    notesController.dispose();
    kiloReadController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<CarWashCubit>().fetchCarWashServices(page: currentPage);

    _scrollController.addListener(() {
      final state = context.read<CarWashCubit>().state;
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          state is CarWashLoaded &&
          state.pagination.hasMorePages) {
        currentPage++;
        context.read<CarWashCubit>().fetchCarWashServices(page: currentPage);
      }
    });
    _cubit = CarCubit();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    await _cubit.fetchCars(token); // 🔁 جلب البيانات

  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
   //   backgroundColor:  Colors.transparent,
      appBar: CustomGradientAppBar(
        title_ar: "إنشاء طلب",
        onBack: () {
          context.read<CarCheckCubit>().resetCarChecks();
          Navigator.pop(context);
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color:
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// -------------------- العنوان --------------------
                Row(
                  children: [
                    Text(
                      'غسيل ونظافة',
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Image.asset(
                      'assets/icons/technical-support.png',
                      height: 20.h,
                      width: 20.w,
                    ),
                  ],
                ),
                SizedBox(height: 15.h),

                /// -------------------- خطوات التقدم --------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _progressBar(active: true),
                    _progressBar(),
                    _progressBar(),
                  ],
                ),

                /// -------------------- قسم السيارات --------------------
                CarsSection(
                  onCarSelected: (brandId, modelId) {
                    setState(() {
                      _selectedCarBrandId = brandId;
                      _selectedCarModelId = modelId;
                    });
                  },
                ),


                /// -------------------- الخدمات --------------------
                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "الخدمات المتوفرة"
                        : 'Available Services',
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                BlocBuilder<CarWashCubit, CarWashState>(
                  builder: (context, state) {
                    if (state is CarWashLoading && state is! CarWashLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CarWashLoaded) {
                      final data = state.services;

                      // Use a single selected index instead of list of booleans
                      if (_selectedServiceIndex == null && data.isNotEmpty) {
                        _selectedServiceIndex = null;
                      }

                      // Pagination
                      final totalPages = (data.length / itemsPerPage).ceil();

                      // تأكد أن currentPage ضمن الحدود
                      if (currentPage > totalPages) currentPage = totalPages > 0 ? totalPages : 1;
                      if (currentPage < 1) currentPage = 1;

                      final startIndex = (currentPage - 1) * itemsPerPage;
                      final endIndex = (startIndex + itemsPerPage) > data.length
                          ? data.length
                          : startIndex + itemsPerPage;
                      final currentItems = data.sublist(
                        startIndex.clamp(0, data.length),
                        endIndex.clamp(0, data.length),
                      );

                      return Column(
                        children: [
                          ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currentItems.length,
                            itemBuilder: (context, index) {
                              final item = currentItems[index];
                              final actualIndex = startIndex + index;
                              return _serviceItem(context, item, actualIndex);
                            },
                          ),
                          SizedBox(height: 12.h),

                          // Pagination UI مع المربعات والأسهم المعكوسة
                          Container(
                            width: double.infinity,
                            height: 60.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Next arrow (يسار)
                                GestureDetector(
                                  onTap: currentPage < totalPages
                                      ? () {
                                    setState(() {
                                      currentPage++;
                                    });
                                  }
                                      : null,
                                  child: Icon(
                                    Icons.arrow_left,
                                    size: 50.sp,
                                    color: currentPage < totalPages
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.25),
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Next page (gray box) إذا موجود
                                if (currentPage < totalPages)
                                  Container(
                                    width: 50.w,
                                    height: 50.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      '${currentPage + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                if (currentPage < totalPages) SizedBox(width: 8.w),

                                // Current page (red box)
                                Container(
                                  width: 50.w,
                                  height: 50.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFBA1B1B),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    '$currentPage',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Previous arrow (يمين)
                                GestureDetector(
                                  onTap: currentPage > 1
                                      ? () {
                                    setState(() {
                                      currentPage--;
                                    });
                                  }
                                      : null,
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 50.sp,
                                    color: currentPage > 1
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (state is CarWashError) {
                      return Center(child: Text("no data"));
                    }
                    return const SizedBox();
                  },
                ),

                SizedBox(height: 10.h),


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomButton(
        textAr: "التالي",
        textEn: "Next",
        onPressed: () {
          // ✅ 1. طباعة ID السيارة المختارة
          print("✅ Selected Car ID: $_selectedCarBrandId");

          if (selectedCarDoc != null) {
            print("🖼️ Selected Car Document: ${selectedCarDoc!.path}");
          } else {
            print("⚠️ No car document selected yet.");
          }

          // ✅ 2. جلب الخدمة المختارة (خدمة واحدة فقط)
          final washState = context.read<CarWashCubit>().state;
          if (washState is CarWashLoaded) {
            if (_selectedServiceIndex != null) {
              final item = washState.services[_selectedServiceIndex!];
              print("✅ Selected Service:");
              print(" - ${item.name} (${item.price} ريال)");
            } else {
              print("⚠️ No service selected yet.");
            }

            // ✅ 3. طباعة الملاحظات
            print("📝 Notes: ${notesController.text}");

            // ✅ 4. طباعة ممشى السيارة
            print("🚗 Car Kilometer Reading: ${kiloReadController.text}");
          } else {
            print("⚠️ No services loaded yet.");
          }
        },
      ),
    );
  }

  /// ----------------------------------------------------------
  /// 🔹 عناصر مساعدة
  /// ----------------------------------------------------------
  Widget _progressBar({bool active = false}) {
    return Container(
      width: 100.w,
      height: 6.h,
      decoration: ShapeDecoration(
        color: active ? const Color(0xFFBA1B1B) : const Color(0xFFAFAFAF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _serviceItem(BuildContext context, dynamic item, int index) {
    final isSelected = _selectedServiceIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedServiceIndex = index; // اختيار عنصر واحد فقط
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            width: 1.5.w,
            color: const Color(0xFF9B9B9B),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox icon فقط يتغير لونه عند الاختيار
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? const Color(0xFFBA1B1B) : const Color(0xFF474747),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            item.price,
                            style: TextStyle(
                              color: const Color(0xFFBA1B1B),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Image.asset(
                            'assets/icons/ryal.png',
                            width: 20.w,
                            height: 20.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFF474747)
                          : Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
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

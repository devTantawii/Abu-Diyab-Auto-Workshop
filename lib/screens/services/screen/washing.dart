import 'dart:io';
import 'package:abu_diyab_workshop/screens/services/cubit/washing_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/screen/review-request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/progress_bar.dart';
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
  final String title;
  final String description;
  final String icon;
  final String slug; // ✅ أضف ده

  const Washing({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.slug,
  });

  @override
  State<Washing> createState() => _WashingState();
}

class _WashingState extends State<Washing> {
  late CarCubit _cubit;

  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  List<File> selectedCarDocs = [];
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  int? _selectedServiceIndex; // العنصر المختار فقط
  final int itemsPerPage = 4; // عدد المنتجات لكل صفحة
  int? _selectedUserCarId;

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor(context),
        appBar: CustomGradientAppBar(
          title_ar: "إنشاء طلب",
          title_en: "Create Request",
          onBack: () {
            context.read<CarCheckCubit>().resetCarChecks();
            Navigator.pop(context);
          },
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp),
              topRight: Radius.circular(15.sp),
            ),
            color: backgroundColor(context),
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
                        widget.title,
                        textAlign: TextAlign.right,
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
                      SizedBox(width: 5),
                      Image.network(
                        widget.icon,
                        height: 20.h,
                        width: 20.w,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image_not_supported, size: 20.h);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  Row(
                    children: [
                      Text(
                        widget.description,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: paragraphColor(context),
                          fontSize: 13.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProgressBar(active: true),
                      ProgressBar(),
                      ProgressBar(),
                    ],
                  ),

                  /// -------------------- قسم السيارات --------------------
                  CarsSection(
                    onCarSelected: (userCarId) {
                      setState(() {
                        _selectedUserCarId = userCarId;
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
                        color: headingColor(context),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  BlocBuilder<CarWashCubit, CarWashState>(
                    builder: (context, state) {
                      if (state is CarWashLoading && state is! CarWashLoaded) {
                        return Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            children: List.generate(2, (index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  width: double.infinity,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      } else if (state is CarWashLoaded) {
                        final data = state.services;

                        // Use a single selected index instead of list of booleans
                        if (_selectedServiceIndex == null && data.isNotEmpty) {
                          _selectedServiceIndex = null;
                        }
                        // Pagination
                        final totalPages = (data.length / itemsPerPage).ceil();
                        if (currentPage > totalPages)
                          currentPage = totalPages > 0 ? totalPages : 1;
                        if (currentPage < 1) currentPage = 1;

                        final startIndex = (currentPage - 1) * itemsPerPage;
                        final endIndex =
                            (startIndex + itemsPerPage) > data.length
                                ? data.length
                                : startIndex + itemsPerPage;
                        final currentItems =
                            (data.isNotEmpty && startIndex < endIndex)
                                ? data.sublist(
                                  startIndex.clamp(0, data.length),
                                  endIndex.clamp(0, data.length),
                                )
                                : [];

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

                            Container(
                              width: double.infinity,
                              height: 120.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Next arrow (يسار)
                                  GestureDetector(
                                    onTap:
                                        currentPage < totalPages
                                            ? () {
                                              setState(() {
                                                currentPage++;
                                              });
                                            }
                                            : null,
                                    child: Icon(
                                      Icons.arrow_left,
                                      size: 50.sp,
                                      color:
                                          currentPage < totalPages
                                              ? Colors.black
                                              : Colors.black.withOpacity(0.25),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),

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
                                          color: backgroundColor(context),
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  if (currentPage < totalPages)
                                    SizedBox(width: 8.w),

                                  // Current page (red box)
                                  Container(
                                    width: 50.w,
                                    height: 50.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: typographyMainColor(context),
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
                                    onTap:
                                        currentPage > 1
                                            ? () {
                                              setState(() {
                                                currentPage--;
                                              });
                                            }
                                            : null,
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 50.sp,
                                      color:
                                          currentPage > 1
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
            // تحقق من البيانات المطلوبة
            if (_selectedUserCarId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("يرجى اختيار السيارة")),
              );
              return;
            }

            // ✅ إذا كانت كل البيانات تمام
            if (_selectedServiceIndex == null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("يرجى اختيار الخدمة")));
              return;
            }

            final cubit = context.read<CarWashCubit>();
            final selectedService =
                (cubit.state as CarWashLoaded).services[_selectedServiceIndex!];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (BuildContext context) => ReviewRequestPage(
                      title: widget.title,
                      icon: widget.icon,
                      slug: widget.slug,
                      selectedUserCarId: _selectedUserCarId,
                      selectedProduct: selectedService,
                      //   notes:
                      //   notesController.text.isNotEmpty
                      //       ? notesController.text
                      //       : null,
                      //   kiloRead:
                      //    kiloReadController.text.isNotEmpty
                      //        ? kiloReadController.text
                      //        : null,
                      // selectedCarDocs: selectedCarDocs,
                    ),
              ),
            );
          },
        ),

        /*
        bottomNavigationBar: CustomBottomButton(
          textAr: "التالي",
          textEn: "Next",
          onPressed: () {
            final cubit = context.read<CarWashCubit>();
            final selectedService = (_selectedServiceIndex != null &&
                cubit.state is CarWashLoaded)
                ? (cubit.state as CarWashLoaded).services[_selectedServiceIndex!]
                : null;

            if (_selectedUserCarId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("يرجى اختيار سيارة")),
              );
              return;
            }

            if (selectedService == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("يرجى اختيار خدمة")),
              );
              return;
            }

       //   Navigator.push(
       //     context,
       //     MaterialPageRoute(
       //       builder: (context) => ReviewRequestPage(
       //         selectedUserCarId: _selectedUserCarId,
       //         selectedProduct: selectedService,
       //         notes: notesController.text,
       //         kiloRead: kiloReadController.text,
       //         selectedCarDoc: selectedCarDoc,
       //         title: widget.title,
       //         icon: widget.icon,
       //       ),
       //     ),
       //   );

            // طباعة بيانات للتجريب
            print("✅ Selected Car ID: $_selectedUserCarId");
            print("✅ Selected Service: ${selectedService.name}");
            print("📝 Notes: ${notesController.text}");
            print("🚗 Car Kilometer Reading: ${kiloReadController.text}");
            print("📄 Selected Car Doc: ${selectedCarDoc?.path ?? 'None'}");
          },
        ),
        */
      ),
    );
  }

  Widget _serviceItem(BuildContext context, dynamic item, int index) {
    final isSelected = _selectedServiceIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedServiceIndex = index;
        });
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.symmetric(vertical: 10.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: buttonBgWhiteColor(context),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              width: 1.5.w,
              color: buttonSecondaryBorderColor(context),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color:
                    isSelected
                        ? typographyMainColor(context)
                        : const Color(0xFF474747),
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
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: headingColor(context),
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
                                color: typographyMainColor(context),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Image.asset(
                              'assets/icons/ryal.png',
                              width: 20.w,
                              height: 20.h,
                              color: typographyMainColor(context),

                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.light
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
      ),
    );
  }
}

import 'dart:io';
import 'package:abu_diyab_workshop/screens/services/widgets/car_brand_widget.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../../my_car/cubit/CarModelCubit.dart';
import '../../my_car/cubit/CarModelState.dart';
import '../../my_car/cubit/car_brand_cubit.dart';
import '../../my_car/cubit/car_brand_state.dart';
import '../../my_car/screen/widget/image_picker.dart';
import '../cubit/oil_cubit.dart';
import '../cubit/oil_state.dart';

import '../model/oil_model.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/NotesAndCarCounter-Section.dart';
import '../widgets/car_model_widget.dart';
import '../widgets/car_selection_widget.dart';
import '../widgets/custom_app_bar.dart';

/// ---------------- Main UI ----------------
class ChangeOil extends StatefulWidget {
  const ChangeOil({super.key});

  @override
  State<ChangeOil> createState() => _ChangeOilState();
}

class _ChangeOilState extends State<ChangeOil> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  String? selectedViscosity;
  final List<String> viscosityOptions = [
    '0W-20',
    '5W-20',
    '5W-30',
    '10W-30',
    '10W-40',
    '15W-40',
    '20W-50',
    '0W-40',
  ];
  int currentPage = 1;
  final int itemsPerPage = 5; // عدد العناصر في كل صفحة
  ScrollController _scrollController = ScrollController();
  int? _selectedOilIndex; // لو حابب تحدد عنصر محدد

  @override
  void dispose() {
    notesController.dispose();
    kiloReadController.dispose();

    // نفرغ الزيوت لما نخرج من الشاشة

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<OilCubit>().fetchOils();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomGradientAppBar(
        title_ar: "إنشاء طلب",
        onBack: () {
          context.read<OilCubit>().resetOils(); // هنا قبل ما نرجع
          Navigator.pop(context);
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (selectedViscosity != null) {
                      // 🧹 لو في فلتر محدد، امسحه مباشرة
                      setState(() {
                        selectedViscosity = null;
                      });
                      context.read<OilCubit>().filterOilsByViscosity(null);
                    } else {
                      // 🪟 عرض قائمة الفلترة في BottomSheet
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          String? tempSelectedViscosity = selectedViscosity;
                          return StatefulBuilder(
                            builder: (context, setModalState) {
                              return Container(
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFEAEAEA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                height: 350.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'الفلترة',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFFBA1B1B),
                                          fontSize: 25.sp,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '-----------------------------------------------------------------------------------------------------------------------------------------',
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: const Color(0xFF9B9B9B),
                                        fontSize: 16.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'لزوجة الزيت',
                                      style: TextStyle(
                                        color: const Color(0xFF474747),
                                        fontSize: 18,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // 🧩 الأزرار داخل الشبكة
                                    Expanded(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final double containerWidth =
                                              constraints.maxWidth;
                                          const int itemsPerRow = 4;
                                          const double spacing = 10;
                                          const double buttonHeight = 45;
                                          const double rowSpacing = 15;

                                          final double buttonWidth =
                                              (containerWidth -
                                                  (spacing *
                                                      (itemsPerRow - 1))) /
                                              itemsPerRow;

                                          return Container(
                                            width: double.infinity,
                                            child: Stack(
                                              children:
                                                  viscosityOptions.asMap().entries.map((
                                                    entry,
                                                  ) {
                                                    final index = entry.key;
                                                    final String
                                                    viscosityValue =
                                                        entry.value;
                                                    final int row =
                                                        index ~/ itemsPerRow;
                                                    final int col =
                                                        index % itemsPerRow;

                                                    final double left =
                                                        col *
                                                        (buttonWidth + spacing);
                                                    final double top =
                                                        row *
                                                        (buttonHeight +
                                                            rowSpacing);
                                                    final bool isSelected =
                                                        tempSelectedViscosity ==
                                                        viscosityValue;

                                                    return Positioned(
                                                      left: left,
                                                      top: top,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setModalState(() {
                                                            tempSelectedViscosity =
                                                                viscosityValue;
                                                          });
                                                        },
                                                        child: Container(
                                                          width: buttonWidth,
                                                          height: buttonHeight,
                                                          decoration: ShapeDecoration(
                                                            color:
                                                                isSelected
                                                                    ? const Color(
                                                                      0x19BA1B1B,
                                                                    )
                                                                    : null,
                                                            shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1.5,
                                                                color:
                                                                    isSelected
                                                                        ? const Color(
                                                                          0xFFBA1B1B,
                                                                        )
                                                                        : const Color(
                                                                          0xFF9B9B9B,
                                                                        ),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    5,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              viscosityValue,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color:
                                                                    isSelected
                                                                        ? Colors
                                                                            .black
                                                                        : const Color(
                                                                          0xFF474747,
                                                                        ),
                                                                fontSize:
                                                                    isSelected
                                                                        ? 18
                                                                        : 16,
                                                                fontFamily:
                                                                    'Graphik Arabic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // 🔘 زر عرض النتائج
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedViscosity =
                                                  tempSelectedViscosity;
                                            });
                                            Navigator.pop(context);
                                            context
                                                .read<OilCubit>()
                                                .filterOilsByViscosity(
                                                  selectedViscosity,
                                                );
                                          },
                                          child: Container(
                                            width: 240.w,
                                            height: 50.h,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFFBA1B1B),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'عرض النتائج',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.sp,
                                                  fontFamily: 'Graphik Arabic',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color:
                          selectedViscosity != null
                              ? const Color(0x67BA1B1B)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            selectedViscosity != null
                                ? const Color(0xFFBA1B1B)
                                : const Color(0xFFA4A4A4),
                        width: 1,
                      ),
                    ),
                    child:
                        selectedViscosity != null
                            ? const Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            )
                            : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/icons/icon_filter.png',
                                color: Colors.grey,
                              ),
                            ),
                  ),
                ),

                Row(
                  children: [
                    Text(
                      'تغيير الزيت',
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
                    Image.asset(
                      'assets/icons/technical-support.png',
                      height: 20.h,
                      width: 20.w,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

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

                /// ---------------- الزيوت ----------------
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
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
            BlocBuilder<OilCubit, OilState>(
              builder: (context, state) {
                if (state is OilLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is OilLoaded) {
                  final data = state.oils;

                  // تعيين العنصر المحدد إذا كان null
                  if (_selectedOilIndex == null && data.isNotEmpty) {
                    _selectedOilIndex = null;
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
                          final oil = currentItems[index];
                          final actualIndex = startIndex + index;

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 1.2.sp,
                                  child: Checkbox(
                                    value: state.selections[actualIndex],
                                    onChanged: (v) {
                                      context.read<OilCubit>().toggleSelection(actualIndex, v ?? false);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFF474747),
                                      width: 1.2,
                                    ),
                                    checkColor: Colors.white,
                                    activeColor: const Color(0xFF1FAF38),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            oil.name,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Theme.of(context).brightness == Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                oil.price,
                                                style: TextStyle(
                                                  color: const Color(0xFFBA1B1B),
                                                  fontSize: 16.sp,
                                                  fontFamily: 'Poppins',
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
                                      SizedBox(height: 6.h),
                                      Text(
                                        oil.description,
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.light
                                              ? const Color(0xFF474747)
                                              : Colors.white,
                                          fontSize: 11.sp,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.w500,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),

                      // Pagination UI
                      Container(
                        width: double.infinity,
                        height: 60.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left arrow now = Next
                            GestureDetector(
                              onTap: currentPage < totalPages
                                  ? () {
                                setState(() {
                                  currentPage++;
                                });
                              }
                                  : null,
                              child: Icon(
                                Icons.arrow_left, // تبقى في اليسار
                                size: 50.sp,
                                color: currentPage < totalPages
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.25),
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // Next page gray box
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

                            // Current page red box
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

                            // Right arrow now = Previous
                            GestureDetector(
                              onTap: currentPage > 1
                                  ? () {
                                setState(() {
                                  currentPage--;
                                });
                              }
                                  : null,
                              child: Icon(
                                Icons.arrow_right, // تبقى في اليمين
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
                } else if (state is OilError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
                SizedBox(height: 10.h),

                NotesAndCarCounterSection(
                  notesController: notesController,
                  kiloReadController: kiloReadController,
                ),

                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              locale.isDirectionRTL(context)
                                  ? 'إستمارة السيارة '
                                  : 'Car Registration ',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text:
                              locale.isDirectionRTL(context)
                                  ? '( أختياري )'
                                  : '( Optional )',
                          style: TextStyle(
                            color: const Color(0xFF4D4D4D),
                            fontSize: 12.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign:
                        locale.isDirectionRTL(context)
                            ? TextAlign.right
                            : TextAlign.left,
                  ),
                ),
                SizedBox(height: 10.h),
                UploadFormWidget(
                  onImageSelected: (file) {
                    selectedCarDoc = file;
                  },
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
      //هنا زرار التالي في اخر الصفحه
      bottomNavigationBar: CustomBottomButton(
        textAr: "التالي",
        textEn: "Next",
        onPressed: () {
          // ✅ 1. طباعة السيارة المختارة
          print("🚗 Selected Car Brand ID: $_selectedCarBrandId");
          print("🚙 Selected Car Model ID: $_selectedCarModelId");

          // ✅ 2. جلب الزيوت المختارة من الحالة
          final oilState = context.read<OilCubit>().state;
          if (oilState is OilLoaded) {
            final selectedOils = <Map<String, dynamic>>[];

            for (int i = 0; i < oilState.oils.length; i++) {
              if (oilState.selections[i]) {
                final oil = oilState.oils[i];
                selectedOils.add({
                  "id": oil.id,
                  "name": oil.name,
                  "price": oil.price,
                  "viscosity": oil.viscosty,
                });
              }
            }

            if (selectedOils.isNotEmpty) {
              print("✅ Selected Oils (${selectedOils.length}):");
              for (var oil in selectedOils) {
                print(
                  " - ${oil['name']} | ${oil['viscosity']} | ${oil['price']} ريال (ID: ${oil['id']})",
                );
              }
            } else {
              print("⚠️ No oils selected yet.");
            }
          } else {
            print("⚠️ No oils loaded yet.");
          }

          // ✅ 3. طباعة الملاحظات
          print("📝 Notes: ${notesController.text}");

          // ✅ 4. طباعة ممشى السيارة
          print("📏 Car Kilometer Reading: ${kiloReadController.text}");

          // ✅ 5. طباعة حالة الاستمارة (الصورة)
          if (selectedCarDoc != null) {
            print("📄 Car Document Selected: ${selectedCarDoc!.path}");
          } else {
            print("📄 No car document uploaded.");
          }

          // ✅ 6. طباعة الفلترة الحالية (لزوجة الزيت)
          if (selectedViscosity != null) {
            print("🧴 Active Filter: $selectedViscosity");
          } else {
            print("🧴 No viscosity filter applied.");
          }

          // هنا ممكن تروح للصفحة التالية أو ترسل البيانات للـ API
          print("✅ Proceeding to next step...");
        },
      ),
    );
  }

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
}

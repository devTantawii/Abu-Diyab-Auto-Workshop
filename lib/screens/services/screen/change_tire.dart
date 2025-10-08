import 'dart:io';

import 'package:abu_diyab_workshop/screens/services/cubit/tire_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/widgets/car_brand_widget.dart';
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
import '../cubit/battery_cubit.dart';
import '../cubit/tire_state.dart';

import '../widgets/Custom-Button.dart';
import '../widgets/NotesAndCarCounter-Section.dart';
import '../widgets/car_model_widget.dart';
import '../widgets/car_selection_widget.dart';
import '../widgets/custom_app_bar.dart';

class ChangeTire extends StatefulWidget {
  const ChangeTire({super.key});

  @override
  State<ChangeTire> createState() => _ChangeTireState();
}

class _ChangeTireState extends State<ChangeTire> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  int count = 1;
  int? selectedTireIndex;

  // متغيرات خارج الـ build
  int currentPage = 1;
  final int itemsPerPage = 5; // عدد العناصر في كل صفحة
  ScrollController _scrollController = ScrollController();
  final List<String> tireSizeOptions = [
    'R-14',
    'R-15',
    'R-16',
    'R-17',
    'R-18',
    'R-19',
    'R-20',
  ];
  String? selectedTireSize;

  @override
  void initState() {
    super.initState();
    context.read<TireCubit>().fetchTires();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFD27A7A),
      appBar: CustomGradientAppBar(
        title_ar: "إنشاء طلب",
        onBack: () => Navigator.pop(context),
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (selectedTireSize != null) {
                          // 🧹 لو في فلتر محدد، امسحه مباشرة
                          setState(() {
                            selectedTireSize = null;
                          });
                          context.read<TireCubit>().fetchTires(); // تحميل كل الكفرات بدون فلتر
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
                              String? tempSelectedSize = selectedTireSize;
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
                                            'فلترة المقاسات',
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
                                        const SizedBox(height: 12),

                                        // 🧩 الأزرار داخل الشبكة
                                        Expanded(
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final double containerWidth = constraints.maxWidth;
                                              const int itemsPerRow = 4;
                                              const double spacing = 10;
                                              const double buttonHeight = 45;
                                              const double rowSpacing = 15;
                                              final double buttonWidth =
                                                  (containerWidth - (spacing * (itemsPerRow - 1))) / itemsPerRow;

                                              return Container(
                                                width: double.infinity,
                                                child: Stack(
                                                  children: tireSizeOptions.asMap().entries.map((entry) {
                                                    final index = entry.key;
                                                    final String sizeValue = entry.value;
                                                    final int row = index ~/ itemsPerRow;
                                                    final int col = index % itemsPerRow;

                                                    final double left = col * (buttonWidth + spacing);
                                                    final double top = row * (buttonHeight + rowSpacing);
                                                    final bool isSelected = tempSelectedSize == sizeValue;

                                                    return Positioned(
                                                      left: left,
                                                      top: top,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setModalState(() {
                                                            tempSelectedSize = sizeValue;
                                                          });
                                                        },
                                                        child: Container(
                                                          width: buttonWidth,
                                                          height: buttonHeight,
                                                          decoration: ShapeDecoration(
                                                            color: isSelected ? const Color(0x19BA1B1B) : null,
                                                            shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1.5,
                                                                color: isSelected
                                                                    ? const Color(0xFFBA1B1B)
                                                                    : const Color(0xFF9B9B9B),
                                                              ),
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              sizeValue,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: isSelected ? Colors.black : const Color(0xFF474747),
                                                                fontSize: isSelected ? 18 : 16,
                                                                fontFamily: 'Graphik Arabic',
                                                                fontWeight: FontWeight.w600,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedTireSize = tempSelectedSize;
                                                });
                                                Navigator.pop(context);
                                                context.read<TireCubit>().fetchTires(size: selectedTireSize);
                                              },
                                              child: Container(
                                                width: 240.w,
                                                height: 50.h,
                                                decoration: ShapeDecoration(
                                                  color: const Color(0xFFBA1B1B),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
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
                          color: selectedTireSize != null ? const Color(0x67BA1B1B) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedTireSize != null ? const Color(0xFFBA1B1B) : const Color(0xFFA4A4A4),
                            width: 1,
                          ),
                        ),
                        child: selectedTireSize != null
                            ? const Icon(Icons.cancel_outlined, color: Colors.white)
                            : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/icons/icon_filter.png',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      'تغيير اطارات',
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

                BlocBuilder<TireCubit, TireState>(
                  builder: (context, state) {
                    if (state is TireLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TireLoaded) {
                      final tires = state.tires;

                      // Pagination
                      final totalPages = (tires.length / itemsPerPage).ceil();

                      if (currentPage > totalPages)
                        currentPage = totalPages > 0 ? totalPages : 1;
                      if (currentPage < 1) currentPage = 1;

                      final startIndex = (currentPage - 1) * itemsPerPage;
                      final endIndex =
                          (startIndex + itemsPerPage) > tires.length
                              ? tires.length
                              : startIndex + itemsPerPage;
                      final currentItems = tires.sublist(
                        startIndex.clamp(0, tires.length),
                        endIndex.clamp(0, tires.length),
                      );

                      return Column(
                        children: [
                          ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currentItems.length,
                            itemBuilder: (context, index) {
                              final tire = currentItems[index];
                              final actualIndex = startIndex + index;
                              bool isSelected =
                                  selectedTireIndex == actualIndex;

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8.h),
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
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
                                        value: isSelected,
                                        onChanged: (v) {
                                          setState(() {
                                            if (v == true) {
                                              selectedTireIndex =
                                                  actualIndex; // اختيار هذا الكفر فقط
                                            } else {
                                              selectedTireIndex =
                                                  null; // إلغاء الاختيار
                                            }
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFF474747),
                                          width: 1.2,
                                        ),
                                        checkColor: Colors.white,
                                        activeColor: const Color(0xFF1FAF38),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),

                                    // تفاصيل الكفر
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  tire.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.light
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontSize: 14.sp,
                                                    fontFamily:
                                                        'Graphik Arabic',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${tire.price}",
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFFBA1B1B,
                                                      ),
                                                      fontSize: 16.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                            "المقاس: ${tire.size}",
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          Text(
                                            "البلد: ${tire.country}",
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          Text(
                                            "الكمية المتاحة: ${tire.quantity}",
                                            style: TextStyle(fontSize: 12.sp),
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

                          // Pagination UI (الأسهم معكوسة: يسار = Next، يمين = Previous)
                          Container(
                            width: double.infinity,
                            height: 60.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left arrow = Next
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
                                if (currentPage < totalPages)
                                  SizedBox(width: 8.w),

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

                                // Right arrow = Previous
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
                    } else if (state is TireError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
                SizedBox(height: 10.h),

                Container(
                  padding: const EdgeInsets.symmetric(
                    //    horizontal: 16,
                    vertical: 12,
                  ),
                  width: 120.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "عدد الإطارات",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF9B9B9B)),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double buttonSize = constraints.maxWidth * 0.18;
                            buttonSize = buttonSize.clamp(40, 55);
                            return Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() => count++);
                                  },

                                  child: Container(
                                    width: buttonSize,
                                    height: buttonSize,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFBA1B1B),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.sp,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w700,
                                      ),
                                      child: Text("$count"),
                                    ),
                                  ),
                                ),
                                // زر الزيادة
                                InkWell(
                                  onTap: () {
                                    if (count > 0) {
                                      setState(() => count--);
                                    }
                                  },

                                  child: Container(
                                    width: buttonSize,
                                    height: buttonSize,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFBA1B1B),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.sp,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

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
                            color: Colors.black,
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
        textEn: "Add My Car",
        onPressed: () {
          final tireCubit = context.read<TireCubit>();
          final selectedTire =
              (tireCubit.state is TireLoaded && selectedTireIndex != null)
                  ? (tireCubit.state as TireLoaded).tires[selectedTireIndex!]
                  : null;

          print("Selected Car Brand ID: $_selectedCarBrandId");
          print("Selected Car Model ID: $_selectedCarModelId");
          print(
            "Selected Tire: ${selectedTire != null ? selectedTire.name : 'None'}",
          );
          print("Tire Count: $count");
          print("Notes: ${notesController.text}");
          print("Kilometer Reading: ${kiloReadController.text}");
          print("Selected Car Document: ${selectedCarDoc?.path ?? 'None'}");
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

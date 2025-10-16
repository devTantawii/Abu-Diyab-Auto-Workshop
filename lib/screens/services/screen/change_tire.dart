import 'dart:io';

import 'package:abu_diyab_workshop/screens/services/cubit/tire_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/screen/review-request.dart';
import 'package:abu_diyab_workshop/screens/services/widgets/car_brand_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/multi_image_picker.dart';
import '../../../widgets/progress_bar.dart';
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
  final String title;
  final String description;
  final String icon;
  final String slug; // ✅ أضف ده

  const ChangeTire({super.key, required this.title, required this.description, required this.icon, required this.slug});

  @override
  State<ChangeTire> createState() => _ChangeTireState();
}

class _ChangeTireState extends State<ChangeTire> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  List<File> selectedCarDocs = [];
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  int count = 1;
  int? selectedTireIndex;
  int? _selectedUserCarId;

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
      backgroundColor:scaffoldBackgroundColor(context),
      appBar: CustomGradientAppBar(
        title_ar: "إنشاء طلب",
        title_en: "Create Request",
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),color:backgroundColor(context),    ),        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(textDirection: locale.isDirectionRTL(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    GestureDetector(
                      onTap: () {
                        if (selectedTireSize != null) {
                          setState(() {
                            selectedTireSize = null;
                          });
                          context.read<TireCubit>().filterTiresBySize(null);
                        } else {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.sp),
                              ),
                            ),
                            builder: (context) {
                              String? tempSelectedSize = selectedTireSize;
                              return StatefulBuilder(
                                builder: (context, setModalState) {
                                  return Container(
                                    decoration: ShapeDecoration(
                                      color: backgroundColor(context),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.sp),
                                          topRight: Radius.circular(20.sp),
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    height: 350.h,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(locale.isDirectionRTL(context)?
                                            'الفلترة':"Filtering",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: accentColor,
                                              fontSize: 25.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '---------------------------------------------------------------------------',
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: borderColor(context),
                                            fontSize: 16.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(locale.isDirectionRTL(context)?
                                          'مقاس الإطار':"Tyre Size",
                                          style: TextStyle(
                                            color: borderColor(context),
                                            fontSize: 18.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        Expanded(
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final double containerWidth = constraints.maxWidth;
                                              final int itemsPerRow = 4;
                                              final double spacing = 10;
                                              final double buttonWidth =
                                                  (containerWidth - (spacing * (itemsPerRow - 1))) /
                                                      itemsPerRow;
                                              final double buttonHeight = 35.h;
                                              final double rowSpacing = 25.h;

                                              return Container(
                                                width: double.infinity,
                                                height: ((tireSizeOptions.length / itemsPerRow)
                                                    .ceil()) *
                                                    (buttonHeight + rowSpacing),
                                                child: Stack(
                                                  children: tireSizeOptions.asMap().entries.map(
                                                        (entry) {
                                                      final index = entry.key;
                                                      final sizeValue = entry.value;
                                                      final int row = index ~/ itemsPerRow;
                                                      final int col = index % itemsPerRow;
                                                      final double left =
                                                          col * (buttonWidth + spacing);
                                                      final double top =
                                                          row * (buttonHeight + rowSpacing);
                                                      final bool isSelected =
                                                          tempSelectedSize == sizeValue;

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
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 9,
                                                            ),
                                                            decoration: ShapeDecoration(
                                                              color: isSelected
                                                                  ? const Color(0xffBA1B1B)
                                                                  : null,
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                  width: 1.w,
                                                                  color: isSelected
                                                                      ? accentColor
                                                                      : borderColor(context),
                                                                ),
                                                                borderRadius:
                                                                BorderRadius.circular(5.sp),
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                sizeValue,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: isSelected
                                                                      ? textColor(context)
                                                                      : borderColor(context),
                                                                  fontSize: isSelected
                                                                      ? 16.sp
                                                                      : 14.sp,
                                                                  fontFamily: 'Graphik Arabic',
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedTireSize = tempSelectedSize;
                                                });
                                                Navigator.pop(context);
                                                context
                                                    .read<TireCubit>()
                                                    .filterTiresBySize(selectedTireSize);
                                              },
                                              child: Container(
                                                width: 240.w,
                                                height: 50.h,
                                                padding: const EdgeInsets.all(10),
                                                decoration: ShapeDecoration(
                                                  color: const Color(0xFFBA1B1B),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15.sp),
                                                  ),
                                                ),
                                                child: Text(  locale.isDirectionRTL(context) ? 'عرض النتائج' : 'Show Results',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.sp,
                                                    fontFamily: 'Graphik Arabic',
                                                    fontWeight: FontWeight.w600,
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
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: selectedTireSize != null
                                  ? accentColor
                                  : boxcolor(context),
                              borderRadius: BorderRadius.circular(10.sp),
                              border: Border.all(
                                width: 1.5.w,
                                color: borderColor(context),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/icons/icon_filter.png',
                                color: textColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                SizedBox(height: 12.h,),
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
                        color: borderColor(context),
                        fontSize: 13.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),

                SizedBox(height: 6.h),

                /// -------------------- خطوات التقدم --------------------
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
                      color:textColor(context),
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
                              final isSelected = selectedTireIndex == actualIndex;

                              void toggleSelection() {
                                setState(() {
                                  if (isSelected) {
                                    selectedTireIndex = null; // إلغاء الاختيار
                                  } else {
                                    selectedTireIndex = actualIndex; // اختيار الكفر
                                  }
                                });
                              }

                              return GestureDetector(
                                onTap: toggleSelection,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.h),
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.white
                                        : Colors.black,
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      width: 1.5.w,
                                      color: isSelected ? const Color(0xFFBA1B1B) : const Color(0xFF9B9B9B),
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
                                          onChanged: (_) {
                                            toggleSelection();
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          side: BorderSide(
                                            color: isSelected ? const Color(0xFFBA1B1B) : const Color(0xFF474747),
                                            width: 1.2,
                                          ),
                                          checkColor: Colors.white,
                                          activeColor: const Color(0xFFBA1B1B),
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
                                                Expanded(
                                                  child: Text(
                                                    tire.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
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
                                                SizedBox(width: 8.w),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "${tire.price}",
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
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 12.h),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 60.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                              ? borderColor(context)
                                              :  borderColor(context)
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
                                        color:  borderColor(context),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        '${currentPage + 1}',
                                        style: TextStyle(
                                          color: textColor(context),
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
                                      color: accentColor,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      '$currentPage',
                                      style: TextStyle(
                                        color: textColor(context),
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
                                              ? borderColor(context)
                                              : borderColor(context)
                                    ),
                                  ),
                                ],
                              ),
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
                        locale.isDirectionRTL(context)?
                        "عدد الإطارات":"Number of Tyres",
                        style:  TextStyle(
                          color:textColor(context),
                          fontSize: 16.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w700,
                          height: 1.5.h,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor(context),
                          border: Border.all(color:borderColor(context),width: 1.5.w),
                          borderRadius: BorderRadius.circular(12.sp),
                          boxShadow: const [
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double buttonSize = constraints.maxWidth * 0.40;
                            buttonSize = buttonSize.clamp(25.sp, 40.sp);
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
                                      color: const Color(0xFFBA1B1B),
                                      shape: BoxShape.rectangle,
                                      borderRadius: Directionality.of(context) == TextDirection.rtl
                                          ? BorderRadius.only(
                                        topRight: Radius.circular(10.sp),
                                        bottomRight: Radius.circular(10.sp),
                                      )
                                          : BorderRadius.only(
                                        topLeft: Radius.circular(10.sp),
                                        bottomLeft: Radius.circular(10.sp),
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
                                      duration: const Duration(milliseconds: 250),
                                      style: TextStyle(
                                        color: textColor(context),
                                        fontSize: 26.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w700,
                                      ),
                                      child: Text("$count"),
                                    ),
                                  ),
                                ),

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
                                      color: const Color(0xFFBA1B1B),
                                      shape: BoxShape.rectangle,
                                      borderRadius: Directionality.of(context) == TextDirection.rtl
                                          ? BorderRadius.only(
                                        topLeft: Radius.circular(10.sp),
                                        bottomLeft: Radius.circular(10.sp),
                                      )
                                          : BorderRadius.only(
                                        topRight: Radius.circular(10.sp),
                                        bottomRight: Radius.circular(10.sp),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.sp,
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
                SizedBox(height: 12.h,),
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
                            color:textColor(context),
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
                MultiImagePickerWidget(
                  onImagesSelected: (files) {
                    selectedCarDocs = files;
                    print('عدد الصور المختارة: ${selectedCarDocs.length}');
                  },
                ),                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomButton(
        textAr: "التالي",
        textEn: "Next",
        onPressed: () {
          if (_selectedUserCarId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى اختيار السيارة")),
            );
            return;
          }
          if (selectedTireIndex == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى اختيار الإطار")),
            );
            return;
          }

          if (kiloReadController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى إدخال قراءة العداد")),
            );
            return;
          }

          // الحصول على الإطار المختار
          final tireState = context.read<TireCubit>().state;
          final selectedTire = (tireState is TireLoaded)
              ? tireState.tires[selectedTireIndex!]
              : null;

          if (selectedTire == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى اختيار الإطار")),
            );
            return;
          }

          // الانتقال لصفحة مراجعة الطلب
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ReviewRequestPage(
                title: widget.title,
                icon: widget.icon,
                slug: widget.slug,
                selectedUserCarId: _selectedUserCarId,
                selectedProduct: selectedTire,
                notes: notesController.text.isNotEmpty ? notesController.text : null,
                kiloRead: kiloReadController.text.isNotEmpty ? kiloReadController.text : null,
                selectedCarDocs: selectedCarDocs,
                count: count.toString(), // عدد الإطارات
              ),
            ),
          );
        },
      ),

      /*   //هنا زرار التالي في اخر الصفحه
      bottomNavigationBar: CustomBottomButton(
        textAr: "التالي",
        textEn: "Add My Car",
        onPressed: () {
          // تحديد الإطار المختار
          final tireCubit = context.read<TireCubit>();
          final selectedTire = (tireCubit.state is TireLoaded && selectedTireIndex != null)
              ? (tireCubit.state as TireLoaded).tires[selectedTireIndex!]
              : null;

          if (_selectedUserCarId == null) {
            // رسالة خطأ إذا لم يتم اختيار سيارة
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("يرجى اختيار سيارة")),
            );
            return;
          }

          if (selectedTire == null) {
            // رسالة خطأ إذا لم يتم اختيار إطار
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("يرجى اختيار إطار")),
            );
            return;
          }

          // الانتقال إلى صفحة مراجعة الطلب
    //  Navigator.push(
    //    context,
    //    MaterialPageRoute(
    //      builder: (context) => ReviewRequestPage(
    //        selectedUserCarId: _selectedUserCarId,
    //        selectedProduct: selectedTire,
    //        notes: notesController.text,
    //        kiloRead: kiloReadController.text,
    //        selectedCarDoc: selectedCarDoc,
    //        title: widget.title,
    //        icon: widget.icon,
    //      //  tireCount: count, // إضافة عدد الإطارات
    //      ),
    //    ),
    // );

          // طباعة البيانات للأغراض التجريبية
          print("✅ Selected Car ID: $_selectedUserCarId");
          print("✅ Selected Tire: ${selectedTire.name}");
          print("📝 Notes: ${notesController.text}");
          print("🚗 Car Kilometer Reading: ${kiloReadController.text}");
          print("🛞 Tire Count: $count");
          print("📄 Selected Car Doc: ${selectedCarDoc?.path ?? 'None'}");
        },
      ),
*/
    );
  }
}

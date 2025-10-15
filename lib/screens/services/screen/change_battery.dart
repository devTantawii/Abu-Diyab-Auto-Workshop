import 'dart:io';

import 'package:abu_diyab_workshop/screens/services/cubit/battery_cubit.dart'
    hide BatteryLoaded;
import 'package:abu_diyab_workshop/screens/services/screen/review-request.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/multi_image_picker.dart';
import '../../../widgets/progress_bar.dart';

import '../../my_car/cubit/all_cars_cubit.dart';

import '../../my_car/screen/widget/image_picker.dart';
import '../cubit/battery_state.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/NotesAndCarCounter-Section.dart';
import '../widgets/car_selection_widget.dart';
import '../widgets/custom_app_bar.dart';

class ChangeBattery extends StatefulWidget {
  final String title;
  final String description;
  final String icon;
  final String slug; // ✅ أضف ده

  const ChangeBattery({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.slug,
  });

  @override
  State<ChangeBattery> createState() => _ChangeBatteryState();
}

class _ChangeBatteryState extends State<ChangeBattery> {
  // File? selectedCarDoc;
  List<File> selectedCarDocs = [];

  int? _selectedBatteryIndex;
  String? selectedAh; // ✅ متغير لتخزين القيمة المختارة
  late CarCubit _cubit;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();

  int? _selectedUserCarId;
  int currentPage = 1; // الصفحة الحالية
  final int itemsPerPage = 4; // عدد المنتجات لكل صفحة

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = CarCubit();
    _loadCars(); // optional: fetch cars here
    context.read<BatteryCubit>().fetchBatteries();
  }

  final List<String> amperOptions = [
    "35Ah",
    "45Ah",
    "55Ah",
    "60Ah",
    "70Ah",
    "80Ah",
    "90Ah",
    "100Ah",
  ];

  Future<void> _loadCars() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    await _cubit.fetchCars(token);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor(context),
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
          ),
          color: backgroundColor(context),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (selectedAh != null) {
                          setState(() {
                            selectedAh = null;
                          });
                          context.read<BatteryCubit>().fetchBatteries(
                            amper: null,
                          );
                        } else {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (context) {
                              String? tempSelectedAh = selectedAh;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: const Color(0xFF9B9B9B),
                                            fontSize: 16.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'الأمبير',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: const Color(0xFF474747),
                                            fontSize: 18,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Expanded(
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final double containerWidth =
                                                  constraints.maxWidth;
                                              final int itemsPerRow = 4;
                                              final double spacing = 10;
                                              final double buttonWidth =
                                                  (containerWidth -
                                                      (spacing *
                                                          (itemsPerRow - 1))) /
                                                  itemsPerRow;
                                              final double buttonHeight = 45;
                                              final double rowSpacing = 15;

                                              return Container(
                                                width: double.infinity,
                                                height:
                                                    ((amperOptions.length /
                                                            itemsPerRow)
                                                        .ceil()) *
                                                    (buttonHeight + rowSpacing),
                                                child: Stack(
                                                  children:
                                                      amperOptions.asMap().entries.map((
                                                        entry,
                                                      ) {
                                                        final index = entry.key;
                                                        final String
                                                        amperValue =
                                                            entry.value;
                                                        final int row =
                                                            index ~/
                                                            itemsPerRow;
                                                        final int col =
                                                            index % itemsPerRow;

                                                        final double left =
                                                            col *
                                                            (buttonWidth +
                                                                spacing);
                                                        final double top =
                                                            row *
                                                            (buttonHeight +
                                                                rowSpacing);
                                                        final bool isSelected =
                                                            tempSelectedAh ==
                                                            amperValue;

                                                        return Positioned(
                                                          left: left,
                                                          top: top,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              setModalState(() {
                                                                tempSelectedAh =
                                                                    amperValue;
                                                              });
                                                            },
                                                            child: Container(
                                                              width:
                                                                  buttonWidth,
                                                              height:
                                                                  buttonHeight,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 9,
                                                                  ),
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
                                                                  amperValue,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                    color:
                                                                        isSelected
                                                                            ? Colors.black
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
                                        const SizedBox(height: 12),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedAh = tempSelectedAh;
                                                });
                                                Navigator.pop(context);
                                                context
                                                    .read<BatteryCubit>()
                                                    .fetchBatteries(
                                                      amper: selectedAh,
                                                    );
                                              },
                                              child: Container(
                                                width: 240.w,
                                                height: 50.h,
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                decoration: ShapeDecoration(
                                                  color: const Color(
                                                    0xFFBA1B1B,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'عرض النتائج',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.sp,
                                                    fontFamily:
                                                        'Graphik Arabic',
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

                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color:
                              selectedAh != null
                                  ? const Color(0x67BA1B1B)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                selectedAh != null
                                    ? const Color(0xFFBA1B1B)
                                    : const Color(0xFFA4A4A4),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              selectedAh != null
                                  ? Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                  )
                                  : Image.asset(
                                    'assets/icons/icon_filter.png',
                                    color: textColor(context),
                                  ),

                          //  color: textColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProgressBar(active: true),
                    ProgressBar(),
                    ProgressBar(),
                  ],
                ),
                CarsSection(
                  onCarSelected: (userCarId) {
                    setState(() {
                      _selectedUserCarId = userCarId;
                    });
                  },
                ),

                /// ---------------- الخدمات ----------------
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Align(
                    alignment:
                        locale.isDirectionRTL(context)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Text(
                      locale.isDirectionRTL(context)
                          ? "الخدمات المتوفرة"
                          : 'Available Services',
                      style: TextStyle(
                        color: textColor(context),
                        fontSize: 14.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // ---------------- عرض البيانات ----------------
                BlocBuilder<BatteryCubit, BatteryState>(
                  builder: (context, state) {
                    if (state is BatteryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BatteryLoaded) {
                      final batteries = state.response.data;

                      if (batteries.isEmpty) {
                        return const Center(
                          child: Text("لا توجد بطاريات متاحة"),
                        );
                      }

                      // Pagination
                      final totalPages =
                          (batteries.length / itemsPerPage).ceil();

                      if (currentPage > totalPages) {
                        currentPage = totalPages > 0 ? totalPages : 1;
                      }
                      if (currentPage < 1) currentPage = 1;

                      final startIndex = (currentPage - 1) * itemsPerPage;
                      final endIndex =
                          (startIndex + itemsPerPage) > batteries.length
                              ? batteries.length
                              : startIndex + itemsPerPage;

                      final currentBatteries = batteries.sublist(
                        startIndex.clamp(0, batteries.length),
                        endIndex.clamp(0, batteries.length),
                      );

                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currentBatteries.length,
                            itemBuilder: (context, index) {
                              final battery = currentBatteries[index];
                              final actualIndex = startIndex + index;
                              final isSelected =
                                  _selectedBatteryIndex == actualIndex;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedBatteryIndex = actualIndex;
                                  });
                                },
                                child: Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: boxcolor(context),
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(
                                        width: 1.5.w,
                                        color:
                                            isSelected
                                                ? const Color(0xFFBA1B1B)
                                                : const Color(0xFF9B9B9B),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Transform.scale(
                                          scale: 1.2.sp,
                                          child: Checkbox(
                                            value: isSelected,
                                            onChanged: (v) {
                                              setState(() {
                                                if (v == true) {
                                                  _selectedBatteryIndex = actualIndex; // اختيار هذا العنصر فقط
                                                } else {
                                                  _selectedBatteryIndex = null; // إلغاء الاختيار
                                                }
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            side: BorderSide(
                                              color: isSelected ? const Color(0xFFBA1B1B) : const Color(0xFF474747),
                                              width: 1.2,
                                            ),
                                            checkColor: Colors.white, // لون الصح
                                            activeColor: const Color(0xFFBA1B1B), // لون الخلفية لما متعلم
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),

                                        /*
                                        Transform.scale(
                                          scale: 1.2.sp,
                                          child: Icon(
                                            isSelected
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color:
                                                isSelected
                                                    ? const Color(0xFFBA1B1B)
                                                    : const Color(0xFF474747),
                                          ),
                                        ),
                                      */  SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      battery.name,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: textColor(
                                                          context,
                                                        ),
                                                        fontSize: 16.sp,
                                                        fontFamily:
                                                            'Graphik Arabic',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${battery.price} SAR",
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
                                                locale.isDirectionRTL(context)
                                                    ? "النوع:${battery.name}"
                                                    : "The kind: ${battery.name}",
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: borderColor(context),
                                                ),
                                              ),
                                              Text(
                                                locale.isDirectionRTL(context)
                                                    ? "بلد المنشى: ${battery.country}"
                                                    : "Country of Origin:  ${battery.country}",
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: borderColor(context),
                                                ),
                                              ),
                                              Text(
                                                locale.isDirectionRTL(context)
                                                    ? "تفاصيل المقاس: ${battery.quantity}"
                                                    : "Size details: ${battery.quantity}",
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: borderColor(context),
                                                ),
                                              ),
                                              Text(
                                                locale.isDirectionRTL(context)
                                                    ? "الكمية المتاحة: ${battery.quantity}"
                                                    : "Available quantity: ${battery.quantity}",
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: borderColor(context),
                                                ),
                                              ),
                                              Text(
                                                locale.isDirectionRTL(context)
                                                    ? "الكمية المتاحة: ${battery.quantity}"
                                                    : "Available quantity: ${battery.quantity}",
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: borderColor(context),
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
                                        color: Colors.white,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                if (currentPage < totalPages)
                                  SizedBox(width: 8.w),
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
                    } else if (state is BatteryError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
                NotesAndCarCounterSection(
                  notesController: notesController,
                  kiloReadController: kiloReadController,
                ),
                SizedBox(height: 15.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'المرفقات ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '(اختياري)',
                        style: TextStyle(
                          color: const Color(0xFF474747),
                          fontSize: 12.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 10.h),

                MultiImagePickerWidget(
                  onImagesSelected: (files) {
                    selectedCarDocs = files;
                    print('عدد الصور المختارة: ${selectedCarDocs.length}');
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
          // تحقق من البيانات المطلوبة
          if (_selectedUserCarId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى اختيار السيارة")),
            );
            return;
          }

          if (_selectedBatteryIndex == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى اختيار البطارية")),
            );
            return;
          }

          if (kiloReadController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى إدخال قراءة العداد")),
            );
            return;
          }

          // ✅ إذا كانت كل البيانات تمام
          final selectedBattery =
              (context.read<BatteryCubit>().state as BatteryLoaded)
                  .response
                  .data[_selectedBatteryIndex!];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (BuildContext context) => ReviewRequestPage(
                    title: widget.title,
                    icon: widget.icon,
                    slug: widget.slug,
                    selectedUserCarId: _selectedUserCarId,
                    selectedProduct: selectedBattery,
                    notes:
                        notesController.text.isNotEmpty
                            ? notesController.text
                            : null,
                    kiloRead:
                        kiloReadController.text.isNotEmpty
                            ? kiloReadController.text
                            : null,
                    selectedCarDocs: selectedCarDocs,
                  ),
            ),
          );
        },
      ),
    );
  }
}

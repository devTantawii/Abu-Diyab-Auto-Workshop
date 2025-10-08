import 'dart:io';

import 'package:abu_diyab_workshop/screens/services/cubit/battery_cubit.dart'
    hide BatteryLoaded;
import 'package:abu_diyab_workshop/screens/services/widgets/car_brand_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/language/locale.dart';
import '../../my_car/cubit/CarModelCubit.dart';
import '../../my_car/cubit/CarModelState.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../my_car/cubit/all_cars_state.dart';
import '../../my_car/cubit/car_brand_cubit.dart';
import '../../my_car/cubit/car_brand_state.dart';
import '../../my_car/model/all_cars_model.dart';
import '../../my_car/screen/widget/details_item.dart';
import '../../my_car/screen/widget/image_picker.dart';
import '../../my_car/widget/bottom_add_car.dart';
import '../cubit/battery_state.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/car_model_widget.dart';
import '../widgets/car_selection_widget.dart';
import '../widgets/custom_app_bar.dart';

class ChangeBattery extends StatefulWidget {
  const ChangeBattery({super.key});

  @override
  State<ChangeBattery> createState() => _ChangeBatteryState();
}

class _ChangeBatteryState extends State<ChangeBattery> {
  File? selectedCarDoc;
  int? _selectedBatteryIndex;
  String? selectedAh; // ✅ متغير لتخزين القيمة المختارة
  late CarCubit _cubit;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
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
    await _cubit.fetchCars(token); // 🔁 جلب البيانات
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (selectedAh != null) {
                          // لو في فلتر محدد، امسحه مباشرة
                          setState(() {
                            selectedAh = null;
                          });
                          // ممكن كمان تعمل fetch للبيانات بدون فلتر
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
                              String? tempSelectedAh =
                                  selectedAh; // قيمة مؤقتة للاختيار داخل الـ bottom sheet
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
                        child:
                            selectedAh != null
                                ? Icon(
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
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'تغيير بطارية',
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
                    SizedBox(width: 5),
                    Image.asset(
                      'assets/icons/technical-support.png',
                      height: 20.h,
                      width: 20.w,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'خدمة تغيير البطارية في مكانك اطلب وأختر المقاس والبراند المطلوب.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF474747),
                    fontSize: 13.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _progressBar(active: true),
                    _progressBar(),
                    _progressBar(),
                  ],
                ),
                CarsSection(
                  onCarSelected: (brandId, modelId) {
                    setState(() {
                      _selectedCarBrandId = brandId;
                      _selectedCarModelId = modelId;
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
              final totalPages = (batteries.length / itemsPerPage).ceil();

              if (currentPage > totalPages) {
                currentPage = totalPages > 0 ? totalPages : 1;
              }
              if (currentPage < 1) currentPage = 1;

              final startIndex = (currentPage - 1) * itemsPerPage;
              final endIndex = (startIndex + itemsPerPage) > batteries.length
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
                      final isSelected = _selectedBatteryIndex == actualIndex;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBatteryIndex = actualIndex;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 16.h),
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
                                child: Icon(
                                  isSelected
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: isSelected ? const Color(0xFFBA1B1B) : const Color(0xFF474747),
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
                                            battery.name,
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
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${battery.price} SAR",
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
                                    Text("البلد: ${battery.country}"),
                                    Text("الأمبير: ${battery.amper}"),
                                    Text("الكمية المتاحة: ${battery.quantity}"),
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

                  // Pagination UI
                  Container(
                    width: double.infinity,
                    height: 60.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
            } else if (state is BatteryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
          ),
                SizedBox(height: 10.h),

                SizedBox(
                  width: 74.w,
                  height: 20.h,
                  child: Text(
                    'الملاحظات',
                    textAlign: TextAlign.right,
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
                SizedBox(height: 30.h),

                Container(
                  decoration: ShapeDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.50, color: Color(0xFF9B9B9B)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: TextField(
                      maxLines: null,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hint: Text('الرجاء كتابة ملاحظاتك ....',),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                          height: 1.57,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "ممشى السياره"
                        : "Car counter",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                  child: Row(
                    textDirection:
                        locale.isDirectionRTL(context)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    children: [
                      Expanded(
                        child: DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashPattern: const [6, 3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(8.r),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: TextField(
                            //  controller: kiloReadController,
                            decoration: InputDecoration(
                              hintText: '0000000',
                              hintStyle: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white38,
                                fontSize: 13.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                              hintTextDirection:
                                  locale.isDirectionRTL(context)
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h,
                              ),
                              border: InputBorder.none,
                            ),
                            textDirection:
                                locale.isDirectionRTL(context)
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        locale.isDirectionRTL(context) ? 'كم' : 'KM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15.h),

                // --- الاستمارة (اختياري) ---
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
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFF4D4D4D)
                                    : Colors.white,
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
          // ✅ 1. طباعة ID السيارة المختارة
          print("✅ Selected Car ID: $_selectedCarBrandId");

          // ✅ 2. جلب البطارية المختارة (واحد فقط)
          final battState = context.read<BatteryCubit>().state;
          if (battState is BatteryLoaded) {
            if (_selectedBatteryIndex != null) {
              final battery = battState.response.data[_selectedBatteryIndex!];
              final selectedBattery = {
                "id": battery.id,
                "name": battery.name,
                "price": battery.price,
              };

              print("✅ Selected Battery:");
              print(
                " - ${selectedBattery['name']} (ID: ${selectedBattery['id']}, Price: ${selectedBattery['price']} ريال)",
              );
            } else {
              print("⚠️ No battery selected yet.");
            }
          } else {
            print("⚠️ No batteries loaded yet.");
          }

          // ✅ 3. طباعة الملاحظات
          print("📝 Notes: ${notesController.text}");

          // ✅ 4. طباعة ممشى السيارة
          print("🚗 Car Kilometer Reading: ${kiloReadController.text}");
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

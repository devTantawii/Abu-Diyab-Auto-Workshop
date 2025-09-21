import 'dart:io';

import 'package:abu_diyab_workshop/screens/services/cubit/battery_cubit.dart' hide BatteryLoaded;
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
import '../cubit/battery_state.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/Service-Custom-AppBar.dart';
import '../widgets/car_model_widget.dart';

class ChangeBattery extends StatefulWidget {
  const ChangeBattery({super.key});

  @override
  State<ChangeBattery> createState() => _ChangeBatteryState();
}

class _ChangeBatteryState extends State<ChangeBattery> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;
  List<bool> selections = [];

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFFD27A7A),
      appBar: CustomGradientAppBar(
        title: "إنشاء طلب",
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
                    Image.asset(
                      'assets/icons/technical-support.png',
                      height: 20.h,
                      width: 20.w,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                /// ---------------- ماركة السيارة ----------------
                CarBrandWidget(
                  titleAr: "ماركة السيارة",
                  titleEn: "Car brand",
                  selectedCarBrandId: _selectedCarBrandId,
                  onBrandSelected: (id) {
                    setState(() {
                      _selectedCarBrandId = id;
                      _selectedCarModelId = null;
                    });

                    /// هنا نستدعي موديلات السيارة
                    context.read<CarModelCubit>().fetchCarModels(id);
                  },
                ),

                SizedBox(height: 15.h),

                /// ---------------- الموديل ----------------
                CarModelWidget(
                  titleAr: "موديل السيارة",
                  titleEn: "Car model",
                  selectedCarModelId: _selectedCarModelId,
                  onModelSelected: (id) {
                    setState(() {
                      _selectedCarModelId = id;
                    });

                    /// هنا لو محتاج تجيب بيانات بناءً على الموديل
                    context.read<BatteryCubit>().fetchServicesByModel(id);
                  },
                ),
                SizedBox(height: 15.h),

                /// ---------------- الزيوت ----------------
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Align(
                    alignment:
                        locale.isDirectionRTL(context)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Text(
                      locale.isDirectionRTL(context)
                          ? "البطاريات المتاحة"
                          : "Available Oils",
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
                BlocBuilder<BatteryCubit, BatteryState>(
                  builder: (context, state) {
                    if (state is BatteryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BatteryLoaded) {
                      if (state.services == null) {
                        return const Center(child: Text("No services available"));
                      }
                      // إنشاء قائمة الاختيارات فقط عند التحميل
                      if (selections.length != state.services.length) {
                        selections = List<bool>.filled(state.services.length, false);
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.services.length,
                        itemBuilder: (context, index) {
                          final service = state.services[index]; // Service
                          final batteries = service.batteryChanges; // List<Battery>
                          final battery = batteries.isNotEmpty ? batteries[0] : null;

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
                                // ✅ Checkbox
                                Transform.scale(
                                  scale: 1.2.sp,
                                  child: Checkbox(
                                    value: selections[index],
                                    onChanged: (v) {
                                      setState(() {
                                        selections[index] = v ?? false;
                                      });
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
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),

                                SizedBox(width: 12.w),

                                // 📦 تفاصيل البطارية
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 🏷️ اسم الخدمة + السعر
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              service.name,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Theme.of(context).brightness ==
                                                    Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 14.sp,
                                                fontFamily: 'Graphik Arabic',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          if (battery != null)
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

                                      // 📄 تفاصيل البطارية
                                      if (battery != null) ...[
                                        Text("Type: ${battery.type}"),
                                        Text("Country: ${battery.country}"),
                                        Text("Warranty: ${battery.warrantyPeriodMonths} months"),
                                        Text("Size: ${battery.size}"),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
          print("Button Pressed");
        },
      ),
    );
  }
}

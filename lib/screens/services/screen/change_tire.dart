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
                    context.read<TireCubit>().fetchTireServicesByModel(id);
                  },
                ),
                SizedBox(height: 10.h),

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
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.services.length,
                        itemBuilder: (context, serviceIndex) {
                          final service = state.services[serviceIndex];

                          // ✅ كل خدمة ليها لستة من الكفرات
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🏷️ عنوان الخدمة
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                  service.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: service.tires.length,
                                itemBuilder: (context, tireIndex) {
                                  final tire = service.tires[tireIndex];

                                  // ✅ كل كفر ليه حالة تشيك بوكس
                                  bool isSelected = false;

                                  return StatefulBuilder(
                                    builder: (context, setInnerState) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 8.h),
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
                                                value: isSelected,
                                                onChanged: (v) {
                                                  setInnerState(() {
                                                    isSelected = v ?? false;
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
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                            ),

                                            SizedBox(width: 12.w),

                                            // 📦 تفاصيل الكفر
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 🏷️ الاسم + السعر
                                                  Row(
                                                    children: [
                                                      Text(
                                                        tire.brand,
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
                                                  Text(tire.type),
                                                  Text(tire.manufactureYear),
                                                  Text(tire.country),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (state is TireError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
                SizedBox(height: 10.h),
                // هنا الجزء بتاع الملاحظات و ممشي السياره معموله ويديجيت منفصله لوحدها
                NotesAndCarCounterSection(
                  notesController: notesController,
                  kiloReadController: kiloReadController,
                ),

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
          print("Button Pressed");
        },
      ),
    );
  }
}

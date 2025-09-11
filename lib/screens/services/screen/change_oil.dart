import 'dart:io';
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
import '../widgets/CarBrand-Section.dart';
import '../widgets/CarModel-Section.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/NotesAndCarCounter-Section.dart';
import '../widgets/Service-Custom-AppBar.dart';

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
          decoration:BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)),
            color:Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
          ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'تغيير الزيت',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color:Theme.of(context).brightness == Brightness.light
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
                /// ---------------- ماركة السيارة ----------------
                CarBrandSection(
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


                /// ---------------- الموديل ----------------
                CarModelSection(
                  titleAr: "موديل السيارة",
                  titleEn: "Car model",
                  selectedCarModelId: _selectedCarModelId,
                  onModelSelected: (id) {
                    setState(() {
                      _selectedCarModelId = id;
                    });

                    /// هنا لو محتاج تجيب بيانات بناءً على الموديل
                    context.read<OilCubit>().fetchOilsByModel(id);
                  },
                ),
                SizedBox(height: 15.h),

                /// ---------------- الزيوت ----------------
                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "الزيوت المتاحة"
                        : "Available Oils",
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
                SizedBox(height: 10.h),
                BlocBuilder<OilCubit, OilState>(
                  builder: (context, state) {
                    if (state is OilLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OilLoaded) {
                      // ✅ نحتفظ بحالة كل تشيك بوكس
                      final List<bool> selections = List<bool>.filled(
                        state.oils.length,
                        false,
                      );

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.oils.length,
                        itemBuilder: (context, index) {
                          final oil = state.oils[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 16.h,
                            ),
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
                                // ✅ التشيك بوكس
                                StatefulBuilder(
                                  builder: (context, setInnerState) {
                                    return Transform.scale(
                                      scale: 1.2.sp,
                                      child: Checkbox(
                                        value: selections[index],
                                        onChanged: (v) {
                                          setInnerState(() {
                                            selections[index] = v ?? false;
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4.r), // هنا تتحكم في الانحناء
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFF474747),
                                          width: 1.2,
                                        ),
                                        checkColor: Colors.white,
                                        activeColor: const Color(0xFF1FAF38),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    );
                                  },
                                ),


                                SizedBox(width: 12.w),

                                // 📦 تفاصيل الزيت
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 🏷️ العنوان
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
                                          Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                "${oil.price}",
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

                                      // 📄 الوصف
                                      Text(
                                        oil.description != null &&
                                                oil.description!.isNotEmpty
                                            ? oil.description!
                                            : "النوع: ${oil.type} | الماركة: ${oil.brand} | بلد: ${oil.country}",
                                        style: TextStyle(
                                          color:Theme.of(context).brightness == Brightness.light
                                              ? const Color(0xFF474747)
                                              : Colors.white,
                                          fontSize: 11.sp,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.w500,
                                          height: 1.6,
                                        ),
                                      ),

                                      SizedBox(height: 8.h),

                                      // 💰 السعر
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is OilError) {
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
                            color: Theme.of(context).brightness == Brightness.light
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
      bottomNavigationBar:CustomBottomButton(
        textAr: "التالي",
        textEn: "Add My Car",
        onPressed: () {
          print("Button Pressed");
        },
      ),

    );
  }
}

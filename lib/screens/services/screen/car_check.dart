import 'dart:io';
import 'package:abu_diyab_workshop/screens/services/widgets/car_brand_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../../my_car/cubit/CarModelCubit.dart';

import '../../my_car/screen/widget/image_picker.dart';
import '../cubit/car_check_cubit.dart';
import '../cubit/car_check_state.dart';

import '../widgets/Custom-Button.dart';
import '../widgets/NotesAndCarCounter-Section.dart';
import '../widgets/Service-Custom-AppBar.dart';
import '../widgets/car_model_widget.dart';

/// ---------------- Main UI ----------------
class CarCheck extends StatefulWidget {
  const CarCheck({super.key});

  @override
  State<CarCheck> createState() => _CarCheckState();
}

class _CarCheckState extends State<CarCheck> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    kiloReadController.dispose();

    // نفرغ الزيوت لما نخرج من الشاشة

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFD27A7A),
      appBar: CustomGradientAppBar(
        title_ar: "إنشاء طلب",
        onBack: () {
          context.read<CarCheckCubit>().resetCarChecks(); // هنا قبل ما نرجع
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'فحص',
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

                    context.read<CarModelCubit>().fetchCarModels(id);

                    context.read<CarCheckCubit>().resetCarChecks();
                  },
                ),

                /// ---------------- الموديل ----------------
                CarModelWidget(
                  titleAr: "موديل السيارة",
                  titleEn: "Car model",
                  selectedCarModelId: _selectedCarModelId,
                  onModelSelected: (id) {
                    setState(() {
                      _selectedCarModelId = id;
                    });

                    context.read<CarCheckCubit>().fetchCarChecks(id);
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
                BlocBuilder<CarCheckCubit, CarCheckState>(
                  builder: (context, state) {
                    if (state is CarCheckLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CarCheckLoaded) {
                      final data = state.carCheck.data ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
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
                                    value: state.selections[index],
                                    onChanged: (v) {
                                      context
                                          .read<CarCheckCubit>()
                                          .toggleSelection(index, v ?? false);
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

                                // 📦 تفاصيل الـ Item
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 🏷️ الاسم + السعر (لو عنده CarChecks)
                                      Row(
                                        children: [
                                          Text(
                                            item.name ?? "",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : Colors.white,
                                              fontSize: 14.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          if ((item.carChecks?.isNotEmpty ??
                                              false))
                                            Row(
                                              children: [
                                                Text(
                                                  item.carChecks![0].price
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFFBA1B1B,
                                                    ),
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
                                        item.description?.isNotEmpty == true
                                            ? item.description!
                                            : "ID: ${item.id} | Checks: ${item.carChecks?.length ?? 0}",
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).brightness ==
                                                      Brightness.light
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
                      );
                    } else if (state is CarCheckError) {
                      return Center(child: Text("Error: ${state.message}"));
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
        textEn: "Add My Car",
        onPressed: () {
          print("Button Pressed");
        },
      ),
    );
  }
}

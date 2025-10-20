import 'dart:io';
import 'package:abu_diyab_workshop/screens/services/screen/review-request.dart';
import 'package:abu_diyab_workshop/screens/services/widgets/car_brand_widget.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
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
  final String title;
  final String description;
  final String icon;
  final String slug; // ✅ أضف ده


  const ChangeOil({
    super.key,
    required this.title,
    required this.description,
    required this.icon, required this.slug,
  });

  @override
  State<ChangeOil> createState() => _ChangeOilState();
}

class _ChangeOilState extends State<ChangeOil> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  String? selectedViscosity;
  List<File> selectedCarDocs = [];

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
  int? _selectedUserCarId;

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
      backgroundColor: scaffoldBackgroundColor(context),
      appBar: CustomGradientAppBar(
        title_ar: "إنشاء طلب",
        title_en: "Create Request",
        onBack: () {
          context.read<OilCubit>().resetOils(); // هنا قبل ما نرجع
          Navigator.pop(context);
        },
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),color:backgroundColor(context),    ),        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(12.w),
            child: Column( textDirection: locale.isDirectionRTL(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
              children: [
                GestureDetector(
                  onTap: () {
                    if (selectedViscosity != null) {
                      setState(() {
                        selectedViscosity = null;
                      });
                      context.read<OilCubit>().filterOilsByViscosity(null);
                    } else {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.sp),
                          ),
                        ),
                        builder: (context) {
                          String? tempSelectedViscosity = selectedViscosity;
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
                                      child: Text(             locale.isDirectionRTL(context) ? 'الفلترة' : 'Filtering',
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
                                    Text(
                                      locale.isDirectionRTL(context) ? 'لزوجه الزيت' : 'Oil viscosity',
                                      style: TextStyle(
                                        color: Color(0xFF616465),
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
                                            height: ((viscosityOptions.length / itemsPerRow)
                                                .ceil()) *
                                                (buttonHeight + rowSpacing),
                                            child: Stack(
                                              children: viscosityOptions.asMap().entries.map(
                                                    (entry) {
                                                  final index = entry.key;
                                                  final String viscosityValue = entry.value;
                                                  final int row = index ~/ itemsPerRow;
                                                  final int col = index % itemsPerRow;
                                                  final double left =
                                                      col * (buttonWidth + spacing);
                                                  final double top =
                                                      row * (buttonHeight + rowSpacing);
                                                  final bool isSelected =
                                                      tempSelectedViscosity == viscosityValue;

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
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 9,
                                                        ),
                                                        decoration: ShapeDecoration(
                                                          color: isSelected
                                                              ? Color(0xFFBA1B1B).withOpacity(0.2)
                                                              : null,
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              width: 2.w,
                                                              color: isSelected
                                                                  ? Color(0xFFBA1B1B)
                                                                  : Colors.grey,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius.circular(5.sp),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            viscosityValue,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: isSelected
                                                                  ? Colors.black
                                                                  : Color(0xFF616465),
                                                              fontSize: isSelected ? 14.sp : 14.sp,
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
                                              selectedViscosity = tempSelectedViscosity;
                                            });
                                            Navigator.pop(context);
                                            context
                                                .read<OilCubit>()
                                                .filterOilsByViscosity(selectedViscosity);
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
                          color: selectedViscosity != null
                              ? Color(0xFFBA1B1B).withOpacity(0.2)
                              : boxcolor(context),
                          borderRadius: BorderRadius.circular(10.sp),
                          border: Border.all(
                            width: 1.5.w,
                            color:  selectedViscosity != null
                                ? Color(0xFFBA1B1B)
                                :borderColor(context),
                          ),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(10.0),
                          child:
                          selectedViscosity != null
                              ? Icon(Icons.cancel_outlined)
                              : Image.asset(
                            'assets/icons/icon_filter.png',
                            color: textColor(context),
                          ),
                          
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
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

                //       /// -------------------- قسم السيارات --------------------
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


                      if (currentPage > totalPages)
                        currentPage = totalPages > 0 ? totalPages : 1;
                      if (currentPage < 1) currentPage = 1;

                      final startIndex = (currentPage - 1) * itemsPerPage;
                      final endIndex =
                          (startIndex + itemsPerPage) > data.length
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
                              final isSelected = _selectedOilIndex == actualIndex;

                              void toggleSelection() {
                                setState(() {
                                  if (isSelected) {
                                    _selectedOilIndex = null;
                                    context.read<OilCubit>().toggleSelection(actualIndex, false);
                                  } else {
                                    _selectedOilIndex = actualIndex;
                                    context.read<OilCubit>().toggleSelection(actualIndex, true);
                                  }
                                });
                              }

                              return GestureDetector(
                                onTap: toggleSelection,
                                child: Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    margin: EdgeInsets.symmetric(vertical: 16.h),
                                    padding: EdgeInsets.symmetric( vertical : 12.h,  horizontal :12.h),
                                    decoration: BoxDecoration(
                                      color: boxcolor(context),
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
                                              toggleSelection(); // هنا شغّل نفس الأكشن
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
                                                  ),
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
                                // Left arrow now = Next
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
                                    Icons.arrow_left, // تبقى في اليسار
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

                                // Right arrow now = Previous
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
                                    Icons.arrow_right, // تبقى في اليمين
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
                SizedBox(height: 10.h),

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

          if (_selectedOilIndex == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى اختيار الزيت")),
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
          final selectedOil = (context.read<OilCubit>().state as OilLoaded).oils[_selectedOilIndex!];



          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (BuildContext context) => ReviewRequestPage(
                title: widget.title,
                icon: widget.icon,
                slug: widget.slug,
                selectedUserCarId: _selectedUserCarId,
                selectedProduct: selectedOil,
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

      /*   //هنا زرار التالي في اخر الصفحه
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
   */ );
  }
}

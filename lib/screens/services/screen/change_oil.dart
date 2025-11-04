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
  final String slug;

  const ChangeOil({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.slug,
  });

  @override
  State<ChangeOil> createState() => _ChangeOilState();
}

class _ChangeOilState extends State<ChangeOil> {
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
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
  final int itemsPerPage = 5;
  final ScrollController _scrollController = ScrollController();
  int? _selectedOilIndex;
  int? _selectedUserCarId;

  @override
  void initState() {
    super.initState();
    context.read<OilCubit>().fetchOils();
  }

  @override
  void dispose() {
    notesController.dispose();
    kiloReadController.dispose();
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // دالة البحث + الفلتر
  void _onSearchChanged() {
    final query = searchController.text.trim();
    context.read<OilCubit>().searchOils(
      search: query.isEmpty ? null : query,
      viscosity: selectedViscosity,
    );
  }

  // عرض الفلتر
  void _showViscosityFilter() {
    String? temp = selectedViscosity;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 350.h,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor(context),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
          ),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.isDirectionRTL(context) ? 'الفلترة' : 'Filtering',
                style: TextStyle(fontSize: 25.sp, color: accentColor, fontWeight: FontWeight.w600),
              ),
              Divider(color: borderColor(context)),
              Text(
                AppLocalizations.of(context)!.isDirectionRTL(context) ? 'لزوجة الزيت' : 'Oil viscosity',
                style: TextStyle(fontSize: 18.sp, color: Color(0xFF616465), fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    const itemsPerRow = 4;
                    final width = (constraints.maxWidth - 30) / itemsPerRow;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: itemsPerRow,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: viscosityOptions.length,
                      itemBuilder: (_, i) {
                        final v = viscosityOptions[i];
                        final selected = temp == v;
                        return GestureDetector(
                          onTap: () => setModalState(() => temp = v),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected ? Color(0xFFBA1B1B).withOpacity(0.2) : null,
                              border: Border.all(color: selected ? Color(0xFFBA1B1B) : Colors.grey, width: 2.w),
                              borderRadius: BorderRadius.circular(5.sp),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              v,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: selected ? Colors.black : Color(0xFF616465),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: () {
                  setState(() => selectedViscosity = temp);
                  Navigator.pop(context);
                  _onSearchChanged();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBA1B1B),
                  minimumSize: Size(240.w, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
                ),
                child: Text(
                  AppLocalizations.of(context)!.isDirectionRTL(context) ? 'عرض النتائج' : 'Show Results',
                  style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          context.read<OilCubit>().resetOils();
          Navigator.pop(context);
        },
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
        child: Column(
          children: [
            // ============= الجزء الثابت: البحث + الفلتر =============
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      // حقل البحث
                      Expanded(
                        child: Container(
                          height: 50.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: boxcolor(context),
                            borderRadius: BorderRadius.circular(10.sp),
                            border: Border.all(color: borderColor(context), width: 1.5.w),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search_outlined,size: 20.sp,),

                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (_) => _onSearchChanged(),
                                  textDirection: locale.isDirectionRTL(context) ? TextDirection.rtl : TextDirection.ltr,
                                  decoration: InputDecoration(
                                    hintText: locale.isDirectionRTL(context) ? 'ابحث عن زيت...' : 'Search oil...',
                                    hintStyle: TextStyle(color: textColor(context).withOpacity(0.5), fontSize: 14.sp),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: TextStyle(color: textColor(context), fontSize: 14.sp),
                                ),
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: searchController,
                                builder: (_, value, __) => value.text.isNotEmpty
                                    ? GestureDetector(
                                  onTap: () {
                                    searchController.clear();
                                    _onSearchChanged();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: Icon(Icons.close, size: 20.sp, color: Colors.black),
                                  ),
                                )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // زر الفلتر
                      GestureDetector(
                        onTap: () {
                          if (selectedViscosity != null) {
                            setState(() => selectedViscosity = null);
                            _onSearchChanged();
                          } else {
                            _showViscosityFilter();
                          }
                        },
                        child: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: selectedViscosity != null
                                ? Color(0xFFBA1B1B).withOpacity(0.2)
                                : boxcolor(context),
                            borderRadius: BorderRadius.circular(10.sp),
                            border: Border.all(
                              width: 1.5.w,
                              color: selectedViscosity != null ? Color(0xFFBA1B1B) : borderColor(context),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: selectedViscosity != null
                                ? Icon(Icons.cancel_outlined, color: Colors.black)
                                : Image.asset('assets/icons/icon_filter.png', color: textColor(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),

            // ============= الجزء القابل للسكرول =============
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    textDirection: locale.isDirectionRTL(context) ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      // العنوان والوصف
                      Row(
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Image.network(
                            widget.icon,
                            height: 20.h,
                            width: 20.w,
                            errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: 20.h),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Text(
                            widget.description,
                            style: TextStyle(
                              color: borderColor(context),
                              fontSize: 13.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),

                      // خطوات التقدم
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ProgressBar(active: true),
                          ProgressBar(),
                          ProgressBar(),
                        ],
                      ),

                      // قسم السيارات
                      CarsSection(
                        onCarSelected: (userCarId) {
                          setState(() => _selectedUserCarId = userCarId);
                        },
                      ),

                      // الزيوت
                      Align(
                        alignment: locale.isDirectionRTL(context) ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          locale.isDirectionRTL(context) ? "الخدمات المتوفرة" : 'Available Services',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // قائمة الزيوت
                      BlocBuilder<OilCubit, OilState>(
                        builder: (context, state) {
                          if (state is OilLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state is OilLoaded) {
                            final oils = state.oils;
                            if (oils.isEmpty) {
                              return Center(
                                child: Text(
                                  locale.isDirectionRTL(context) ? "لا توجد زيوت متاحة" : "No oils available",
                                  style: TextStyle(fontSize: 18.sp, color: textColor(context)),
                                ),
                              );
                            }

                            final totalPages = (oils.length / itemsPerPage).ceil();
                            if (currentPage > totalPages) currentPage = totalPages;
                            if (currentPage < 1) currentPage = 1;

                            final startIndex = (currentPage - 1) * itemsPerPage;
                            final endIndex = (startIndex + itemsPerPage).clamp(0, oils.length);
                            final currentItems = oils.sublist(startIndex, endIndex);

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

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedOilIndex = isSelected ? null : actualIndex;
                                        });
                                      },
                                      child: Center(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          margin: EdgeInsets.symmetric(vertical: 16.h),
                                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
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
                                                    setState(() {
                                                      _selectedOilIndex = isSelected ? null : actualIndex;
                                                    });
                                                  },
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
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
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              color: textColor(context),
                                                              fontSize: 14.sp,
                                                              fontFamily: 'Graphik Arabic',
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              oil.price,
                                                              style: TextStyle(
                                                                color: Color(0xFFBA1B1B),
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
                                                        color: borderColor(context),
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

                                // Pagination
                                Container(
                                  width: double.infinity,
                                  height: 60.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: currentPage < totalPages
                                            ? () => setState(() => currentPage++)
                                            : null,
                                        child: Icon(
                                          Icons.arrow_left,
                                          size: 50.sp,
                                          color: currentPage < totalPages ? Colors.black : Colors.black.withOpacity(0.25),
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
                                            style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w600),
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
                                          style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      GestureDetector(
                                        onTap: currentPage > 1
                                            ? () => setState(() => currentPage--)
                                            : null,
                                        child: Icon(
                                          Icons.arrow_right,
                                          size: 50.sp,
                                          color: currentPage > 1 ? Colors.black : Colors.black.withOpacity(0.25),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          if (state is OilError) {
                            return Center(child: Text(state.message));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: 10.h),

                      NotesAndCarCounterSection(
                        notesController: notesController,
                        kiloReadController: kiloReadController,
                      ),
                      SizedBox(height: 10.h),

                      Align(
                        alignment: locale.isDirectionRTL(context) ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: locale.isDirectionRTL(context) ? 'إستمارة السيارة ' : 'Car Registration ',
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: locale.isDirectionRTL(context) ? '( أختياري )' : '( Optional )',
                                style: TextStyle(color: const Color(0xFF4D4D4D), fontSize: 12.sp, fontFamily: 'Graphik Arabic', fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          textAlign: locale.isDirectionRTL(context) ? TextAlign.right : TextAlign.left,
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
          ],
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

          final selectedOil = (context.read<OilCubit>().state as OilLoaded).oils[_selectedOilIndex!];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReviewRequestPage(
                title: widget.title,
                icon: widget.icon,
                slug: widget.slug,
                selectedUserCarId: _selectedUserCarId,
                selectedProduct: selectedOil,
                notes: notesController.text.isNotEmpty ? notesController.text : null,
                kiloRead: kiloReadController.text.isNotEmpty ? kiloReadController.text : null,
                selectedCarDocs: selectedCarDocs,
              ),
            ),
          );
        },
      ),
    );
  }
}
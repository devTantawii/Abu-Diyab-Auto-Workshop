import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/api.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/langCode.dart';
import '../../../../core/language/locale.dart';
import '../../../../widgets/app_bar_widget.dart';
import '../../../main/screen/main_screen.dart';
import '../../../services/widgets/custom_app_bar.dart';
import '../../cubit/CarModelCubit.dart';
import '../../cubit/CarModelState.dart';
import '../../cubit/all_cars_state.dart';
import '../../cubit/car_brand_cubit.dart';
import '../../cubit/car_brand_state.dart';
import '../../cubit/all_cars_cubit.dart';
import 'image_picker.dart';
import 'nemra.dart';

class EditCar extends StatefulWidget {
  final int carId;

  const EditCar({super.key, required this.carId});

  @override
  State<EditCar> createState() => _EditCarState();
}

class _EditCarState extends State<EditCar> {
  final TextEditingController arabicLettersController = TextEditingController();
  final TextEditingController arabicNumbersController = TextEditingController();
  final List<String> years = List.generate(
    50,
    (index) => (DateTime.now().year - index).toString(),
  );
  int selectedYearIndex = 0;
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;

  final TextEditingController carNameController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  String? existingCarCertificateUrl;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCarData();
  }

  Future<void> fetchCarData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await Dio().get(
        '$carShowApi${widget.carId}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": langCode == '' ? "en" : langCode,
          },
        ),
      );

      final data = response.data['data'];

       final boardParts = data['licence_plate']?.split(' ') ?? [];
      final letters =
          boardParts.length >= 2
              ? boardParts.sublist(0, boardParts.length - 1).join(' ')
              : '';
      final numbers = boardParts.isNotEmpty ? boardParts.last : '';

       final carYear =
          data['year']?.toString() ?? DateTime.now().year.toString();
      final yearIndex = years.contains(carYear) ? years.indexOf(carYear) : 0;

      setState(() {
        carNameController.text = data['name'] ?? '';
        kiloReadController.text = data['kilometer']?.toString() ?? '';
        arabicLettersController.text = letters;
        arabicNumbersController.text = numbers;

        _selectedCarBrandId = data['car_brand']?['id'] ?? 0;
        _selectedCarModelId = data['car_model']?['id'] ?? 0;

        selectedYearIndex = yearIndex;

        existingCarCertificateUrl =
            data['car_certificate'];

        isLoading = false;
      });

      if (_selectedCarBrandId != null && _selectedCarBrandId != 0) {
        context.read<CarModelCubit>().fetchCarModels(_selectedCarBrandId!);
      }
    } catch (e) {
      debugPrint('Error fetching car data: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ حدث خطأ أثناء جلب بيانات السيارة")),
      );
    }
  }

  String _digitsToEn(String input) {
    const Map<String, String> arabicIndic = {
      "٠": "0",
      "١": "1",
      "٢": "2",
      "٣": "3",
      "٤": "4",
      "٥": "5",
      "٦": "6",
      "٧": "7",
      "٨": "8",
      "٩": "9",
    };
    const Map<String, String> persianIndic = {
      "۰": "0",
      "۱": "1",
      "۲": "2",
      "۳": "3",
      "۴": "4",
      "۵": "5",
      "۶": "6",
      "۷": "7",
      "۸": "8",
      "۹": "9",
    };
    final buffer = StringBuffer();
    for (final ch in input.characters) {
      if (arabicIndic.containsKey(ch))
        buffer.write(arabicIndic[ch]);
      else if (persianIndic.containsKey(ch))
        buffer.write(persianIndic[ch]);
      else
        buffer.write(ch);
    }
    return buffer.toString();
  }

  String _cleanLetters(String input) {
    String s = input.trim();
    s = s.replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '');
    s = s.replaceAll(RegExp(r'\s+'), '');
    return s;
  }

  String _buildBoardNo({
    required String lettersRaw,
    required String numbersRaw,
  }) {
    final letters = _cleanLetters(lettersRaw);
    final lettersWithSpaces = letters.split('').join(' ');
    final numbersEn = _digitsToEn(numbersRaw.trim());
    return "$lettersWithSpaces $numbersEn".trim();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;

    final bgColor = isLight ? Colors.white : Colors.black;
    final cardColor = isLight ? Colors.white : const Color(0xFF1E1E1E);
    final textColor = isLight ? Colors.black : Colors.white;
    final hintColor = isLight ? Colors.black54 : Colors.white54;
    final borderColor = isLight ? Colors.grey.shade300 : Colors.white24;
    final shadowColor = isLight ? Colors.black12 : Colors.transparent;

    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return BlocListener<CarCubit, CarState>(
      listener: (context, state) async {
        if (state is UpdateCarLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
           if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }

          if (state is UpdateCarSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context, 'updated');
          } else if (state is UpdateCarError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
      child: GestureDetector(  onTap: () {
        FocusScope.of(context).unfocus();
      },
        child: Scaffold(
          backgroundColor:
              Theme.of(context).brightness == Brightness.light
                  ? Color(0xFFEAEAEA)
                  : Colors.black87,
          appBar: CustomGradientAppBar(
            title_ar: "عدل سيارتك",
            title_en: "Edit Your Car",
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              textDirection:
                  locale!.isDirectionRTL(context)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              children: [
                 Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? 'رقم لوحة السيارة'
                        : 'Car plate number',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Nemra(
                        arabicLettersController: arabicLettersController,
                        englishNumbersController: arabicNumbersController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                 Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "ماركة السيارة"
                        : "Car brand",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                BlocBuilder<CarBrandCubit, CarBrandState>(
                  builder: (context, state) {
                    if (state is CarBrandLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is CarBrandLoaded) {
                      return SizedBox(
                        height: 110.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.brands.length,
                          itemBuilder: (context, index) {
                            final car = state.brands[index];
                            final isSelected = _selectedCarBrandId == car.id;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCarBrandId = car.id;
                                  _selectedCarModelId = null;
                                });
                                context.read<CarModelCubit>().fetchCarModels(
                                  car.id,
                                );
                              },
                              child: Container(
                                width: 80.w,
                                height: 70.h,
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? buttonPrimaryBgColor(
                                            context,
                                          ).withOpacity(0.3)
                                          : Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? buttonPrimaryBgColor(context)
                                            : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      car.image,
                                      width: 30.w,
                                      height: 30.h,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error, size: 20),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      car.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.black
                                                : Colors.grey,

                                        fontSize: 12.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    if (state is CarBrandError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),

                SizedBox(height: 15.h),

                 Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "موديل السيارة"
                        : "Car model",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                BlocBuilder<CarModelCubit, CarModelState>(
                  builder: (context, state) {
                    if (state is CarModelLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is CarModelLoaded) {
                      return SizedBox(
                        height: 30.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.models.length,
                          itemBuilder: (context, index) {
                            final car = state.models[index];
                            final isSelected = _selectedCarModelId == car.id;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCarModelId = car.id;
                                });
                              },
                              child: Container(
                                width: 70.w,
                                height: 30.h,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? buttonPrimaryBgColor(
                                            context,
                                          ).withOpacity(0.3)
                                          : Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? buttonPrimaryBgColor(context)
                                            : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  car.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.black
                                            : Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    if (state is CarModelError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),

                SizedBox(height: 15.h),

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
                                  ? 'اسم السيارة '
                                  : 'Car name ',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text:
                              locale.isDirectionRTL(context)
                                  ? '( اختياري )'
                                  : '( Optional )',
                          style: TextStyle(
                            color: const Color(0xFF4D4D4D),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  decoration: ShapeDecoration(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: TextField(
                    controller: carNameController,
                    decoration: InputDecoration(
                      hintText:
                          locale.isDirectionRTL(context)
                              ? "سيارة الدوام، سيارة العائلة، سيارة أحمد"
                              : "Work car, family car, Ahmed's car",
                      hintStyle: TextStyle(color: hintColor),

                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                 Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "سنة الصنع"
                        : "Year of manufacture",
                    style: TextStyle(
                      color: textColor,

                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 80.h,
                  child: ListWheelScrollView.useDelegate(
                    controller: FixedExtentScrollController(
                      initialItem: selectedYearIndex,
                    ),
                     itemExtent: 30.h,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged:
                        (index) => setState(() => selectedYearIndex = index),
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        if (index < 0 || index >= years.length) return null;
                        final isSelected = index == selectedYearIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          color:
                          isSelected ? Color(0x3F006D92) : Colors.transparent,

                          child: Center(
                            child: Text(
                              years[index],
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? textColor : hintColor,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: years.length,
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

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
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: ShapeDecoration(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DottedBorder(
                          color: borderColor,
                          strokeWidth: 1,
                          dashPattern: const [6, 3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(8.r),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: TextField(
                            controller: kiloReadController,
                            decoration: InputDecoration(
                              hintText: '0000000',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        locale.isDirectionRTL(context) ? 'كم' : 'KM',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15.h),


                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? 'إستمارة السيارة ( أختياري )'
                        : 'Car Registration ( Optional )',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                UploadFormWidget(
                  existingImageUrl: existingCarCertificateUrl,
                  onImageSelected: (file) => selectedCarDoc = file,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color:
                Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.white10,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: buttonPrimaryBgColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('token') ?? '';

                      if (_selectedCarBrandId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("الرجاء اختيار ماركة السيارة"),
                          ),
                        );
                        return;
                      }

                      if (_selectedCarModelId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("الرجاء اختيار موديل السيارة"),
                          ),
                        );
                        return;
                      }

                      if (arabicLettersController.text.trim().isEmpty ||
                          arabicNumbersController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("الرجاء إدخال رقم اللوحة"),
                          ),
                        );
                        return;
                      }

                       showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  locale.isDirectionRTL(context)
                                      ? 'هل تريد حفظ التعديلات؟'
                                      : 'Do you want to save the changes?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: buttonPrimaryBgColor(context),
                                    fontSize: 22.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20.h),

                                Image.asset(
                                  'assets/images/save_changes.png',
                                  height: 130.h,
                                  width: 130.w,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  locale.isDirectionRTL(context)
                                      ? 'تم تغيير معلومات السيارة، تبينا نحفظها؟'
                                      : 'The car information has changed, should we save it?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize: 20.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 50.h,

                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: buttonPrimaryBgColor(
                                              context,
                                            ),

                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                10.r,
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(
                                              context,
                                            );

                                            final boardNoFinal = _buildBoardNo(
                                              lettersRaw:
                                                  arabicLettersController.text,
                                              numbersRaw:
                                                  arabicNumbersController.text,
                                            );

                                            final kiloRead =
                                                int.tryParse(
                                                  _digitsToEn(
                                                    kiloReadController.text
                                                        .trim(),
                                                  ),
                                                ) ??
                                                0;

                                            await context
                                                .read<CarCubit>()
                                                .updateCar(
                                                  carId: widget.carId,
                                                  token: token,
                                                  carBrandId:
                                                      _selectedCarBrandId ?? 0,
                                                  carModelId:
                                                      _selectedCarModelId ?? 0,
                                                  creationYear:
                                                      years[selectedYearIndex],
                                                  boardNo: boardNoFinal,
                                                  translationName:
                                                      carNameController.text
                                                          .trim(),
                                                  kiloRead: kiloRead,
                                                  carDocs: selectedCarDoc,
                                                );
                                          },
                                          child: Text(
                                            'أكيد',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 18.w),
                                    Expanded(
                                      child: Container(
                                        height: 50.h,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[400],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                10.r,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'تراجع',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w500,
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
                    child: Text(
                      locale.isDirectionRTL(context)
                          ? 'حفظ التعديلات'
                          : 'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Graphik Arabic',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.white10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('token') ?? '';

                      bool confirm = await showDeleteCarBottomSheet(context);

                      false;

                      if (!confirm) return;

                      try {
                        final response = await Dio().delete(
                          '$carDeleteApi${widget.carId}',
                          options: Options(
                            headers: {
                              'Authorization': 'Bearer $token',
                              "Accept-Language": langCode == '' ? "en" : langCode,
                            },
                          ),
                        );

                        if (response.statusCode == 200 ||
                            response.statusCode == 204) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                locale.isDirectionRTL(context)
                                    ? 'تم حذف السيارة بنجاح'
                                    : 'Car deleted successfully',
                              ),
                            ),
                          );
                          Navigator.pop(
                            context,
                            'deleted',
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              locale.isDirectionRTL(context)
                                  ? 'فشل الحذف'
                                  : 'Failed to delete car',
                            ),
                          ),
                        );
                      }
                    },

                    child: Text(
                      locale.isDirectionRTL(context)
                          ? 'حذف السيارة'
                          : 'Delete Car',
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showDeleteCarBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          width: 1.sw,
           height: 0.48.sh,
           margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(16.w),
          decoration: ShapeDecoration(
            color:
                Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Color(0xFF1D1D1D),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.w, color: const Color(0xFF9B9B9B)),
              borderRadius: BorderRadius.circular(15.r),
            ),
            shadows: [
              BoxShadow(
                color: const Color(0x3F000000),
                blurRadius: 8.r,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
               Text(
                'هل تريد حذف السيارة؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: buttonPrimaryBgColor(context),

                  fontSize: 22.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 20.h),

               SizedBox(
                height: 140.h,
                width: 140.w,
                child: Image.asset(
                  "assets/icons/delete_car.png",
                  fit: BoxFit.contain,
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Color(0xFF1D1D1D)
                          : Colors.white70,
                ),
              ),

              SizedBox(height: 20.h),

               Text(
                'إذا حذفتها، بتنمسح كل بياناتها من حسابك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Color(0xFF1D1D1D)
                          : Colors.white70,
                  fontSize: 18.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

               Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: Container(
                        height: 50.h,
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: ShapeDecoration(
                          color: buttonPrimaryBgColor(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'نعم، احذفها',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        height: 50.h,
                        margin: EdgeInsets.only(left: 8.w),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.5.w,
                              color: const Color(0xFF9B9B9B),
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'رجوع',
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
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

    return result ?? false;
  }
}

/*
import 'dart:io';

import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/language/locale.dart';
import '../../../widgets/map_select_location.dart';
import '../../../widgets/progress_bar.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../my_car/cubit/all_cars_state.dart';
import '../../my_car/model/all_cars_model.dart';
import '../../orders/model/payment_preview_model.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/custom_app_bar.dart';
import 'final-review.dart';

class ReviewRequestPage extends StatefulWidget {
  final int? selectedUserCarId;
  final dynamic selectedProduct;
  final String? notes;
  final String? kiloRead;
  final List<File>? selectedCarDocs;
  final String title;
  final String icon;
  final String slug; // ✅ أضف ده
  final String? count; // ✅ أضف ده
  final String? isCarWorking;

  const ReviewRequestPage({
    super.key,
    this.selectedUserCarId,
    this.selectedProduct,
    this.notes,
    this.kiloRead,
    required this.title,
    required this.icon,
    required this.slug,
    this.selectedCarDocs,  this.count, this.isCarWorking,
  });

  @override
  State<ReviewRequestPage> createState() => _ReviewRequestPageState();
}

class _ReviewRequestPageState extends State<ReviewRequestPage> {
  int selectedDeliveryMethod = 0;
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;
  Car? selectedCar;
  bool isCarLoading = false;
  bool isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    //  print("========= 📥 DATA RECEIVED FROM PREVIOUS PAGE =========");
    //  print("🧾 الخدمة: ${widget.title}");
    //  print("🪪 النوع (slug): ${widget.slug}");
    //  print("🚗 رقم السيارة: ${widget.selectedUserCarId}");
    //  print("🔋 المنتج المختار: ${widget.selectedProduct?.name}");
    //  print("🔋 المنتج المختار: ${widget.selectedProduct?.id}");
    //  print("💰 السعر: ${widget.selectedProduct?.price}");
    //  print("📝 الملاحظات: ${widget.notes}");
    //  print("📏 قراءة العداد: ${widget.kiloRead}");
    //  if (widget.selectedCarDocs != null && widget.selectedCarDocs!.isNotEmpty) {
    //    for (int i = 0; i < widget.selectedCarDocs!.length; i++) {
    //      print("📎 المرفق ${i + 1}: ${widget.selectedCarDocs![i].path}");
    //    }
    //  } else {
    //    print("📎 لا يوجد مرفقات.");
    //  }
    //  print("======================================================");
    context.read<CarCubit>().getUserCar(widget.selectedUserCarId!);
  }

  DateTime? selectedDateTime;
  String selectedAddress = "KSA";
  String? _selectedAddress;
  int selectedIndex = 0;
  double? _selectedLat;
  double? _selectedLng;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth =
        (screenWidth - 48) / 2;
    double buttonHeight = 50;
    final locale = AppLocalizations.of(context);
    return Scaffold(
      // backgroundColor:
      //     Theme.of(context).brightness == Brightness.light
      //         ? Color(0xFFD27A7A)
      //         : const Color(0xFF6F5252),
      appBar: CustomGradientAppBar(
        title_ar: "جدولة الطلب",
        title_en: "My Orders",
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
          color:
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
        ),

        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //           Text(
              //             "🚘 رقم ماركة السيارة: ${widget.selectedUserCarId ?? 'غير محدد'}",
              //           ),
              //           const SizedBox(height: 8),

              //           if (widget.selectedProduct != null) ...[
              //             Text("🔋  المختارة: ${widget.selectedProduct.name}"),
              //             Text("💰 السعر: ${widget.selectedProduct.price} ريال"),
              //          //   Text("🇸🇦 بلد المنشأ: ${widget.selectedProduct.country}"),
              //           ] else
              //             const Text("⚠️ لم يتم اختيار بطارية بعد."),
              //           const SizedBox(height: 10),

              //           Text(
              //             "📝 الملاحظات: ${widget.notes?.isNotEmpty == true ? widget.notes : 'لا توجد ملاحظات'}",
              //           ),
              //           Text("📏 قراءة العداد: ${widget.kiloRead ?? 'غير مدخل'} كم"),
              //           const SizedBox(height: 10),

              //         if (widget.selectedCarDocs != null && widget.selectedCarDocs!.isNotEmpty)
              //           SizedBox(
              //             height: 120,
              //             child: ListView.separated(
              //               scrollDirection: Axis.horizontal,
              //               itemCount: widget.selectedCarDocs!.length,
              //               separatorBuilder: (_, __) => SizedBox(width: 10),
              //               itemBuilder: (context, index) {
              //                 return ClipRRect(
              //                   borderRadius: BorderRadius.circular(10),
              //                   child: Image.file(
              //                     widget.selectedCarDocs![index],
              //                     width: 120,
              //                     height: 120,
              //                     fit: BoxFit.cover,
              //                   ),
              //                 );
              //               },
              //             ),
              //           )
              //         else
              //           const Text("📄 لم يتم إرفاق صور."),

              //         const SizedBox(height: 25),

              //           Text("📅 اختر اليوم:", style: TextStyle(fontSize: 16.sp)),


              Text(widget.isCarWorking??""),

              SizedBox(height: 4.h),
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

              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProgressBar(),
                  ProgressBar(active: true),
                  ProgressBar(),
                ],
              ),

              SizedBox(height: 15.h),

              Row(
                children: [
                  Text(
                    " السياره ",
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              BlocBuilder<CarCubit, CarState>(
                builder: (context, state) {
                  if (state is SingleCarLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SingleCarLoaded) {
                    final car = state.car;
                    return Container(
                      height: 107.h,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : const Color(0xff1D1D1D),
                        border: Border.all(color: Colors.grey, width: 1.5.w),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      padding: EdgeInsets.all(8.sp),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: double.infinity,
                            width: 100.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                car.carCertificate ?? "",
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Image.asset(
                                      "assets/images/main_pack.png",
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "الموديل:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),

                                    Text(
                                      " ${car.carBrand['name']} ${car.carModel['name']} ${car.year ?? ''}",
                                      style: TextStyle(
                                        color: Color(0xFFBA1B1B),
                                        fontSize: 13.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                        height: 1.69,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      "رقم اللوحة:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),

                                    Text(
                                      " ${car.licencePlate}",
                                      style: TextStyle(
                                        color: Color(0xFFBA1B1B),
                                        fontSize: 13.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                        height: 1.69,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      "الممشى:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      " ${car.kilometer ?? '--'} كم",
                                      style: TextStyle(
                                        color: Color(0xFFBA1B1B),
                                        fontSize: 13.sp,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w600,
                                        height: 1.69,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is SingleCarError) {
                    return Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              SizedBox(height: 15.h),

              Row(
                children: [
                  Text(
                    "العنوان",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LocationPickerFull()),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        double lat = result['lat'];
                        double lng = result['lng'];
                        String address = result['address'];

                        print("الموقع المختار: $lat, $lng");
                        print("العنوان: $address");

                        setState(() {
                          _selectedAddress = address;
                          _selectedLat = lat;
                          _selectedLng = lng;
                        });
                      }
                    },
                    child: Center(
                      child: Text(
                        "+ إضافة عنوان جديد",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFBA1B1B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 1.5.w),
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Color(0xff1D1D1D),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _selectedAddress ?? "",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            isFetchingLocation = true; // بدء التحميل
                          });

                          try {
                            bool serviceEnabled;
                            LocationPermission permission;

                            serviceEnabled = await Geolocator.isLocationServiceEnabled();
                            if (!serviceEnabled) {
                              print('⚠️ خدمة الموقع غير مفعلة');
                              setState(() => isFetchingLocation = false);
                              return;
                            }

                            permission = await Geolocator.checkPermission();
                            if (permission == LocationPermission.denied) {
                              permission = await Geolocator.requestPermission();
                              if (permission == LocationPermission.denied) {
                                print('❌ تم رفض إذن الموقع');
                                setState(() => isFetchingLocation = false);
                                return;
                              }
                            }

                            if (permission == LocationPermission.deniedForever) {
                              print('🚫 تم رفض إذن الموقع نهائيًا');
                              setState(() => isFetchingLocation = false);
                              return;
                            }

                            Position position = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );

                            List<Placemark> placemarks = await placemarkFromCoordinates(
                              position.latitude,
                              position.longitude,
                            );

                            if (placemarks.isNotEmpty) {
                              Placemark place = placemarks.first;
                              String address =
                                  "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

                              setState(() {
                                _selectedAddress = address;
                                _selectedLat = position.latitude;
                                _selectedLng = position.longitude;
                              });

                              print('📍 الموقع الحالي: $address');
                            } else {
                              print('لم يتم العثور على اسم المكان');
                            }
                          } catch (e) {
                            print('❗ خطأ أثناء جلب الموقع: $e');
                          } finally {
                            setState(() {
                              isFetchingLocation = false; // انتهى التحميل
                            });
                          }
                        },
                        child: isFetchingLocation
                            ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Color(0xFFBA1B1B),
                          ),
                        )
                            : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, color: Color(0xFFBA1B1B)),
                            SizedBox(width: 6.w),
                            Text(
                              "العنوان الحالي",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFBA1B1B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Text(
                    "طريقة التوصيل",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFBA1B1B),
                    ),
                  ),
                  SizedBox(width: 7.w),

                  Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFBA1B1B),
                      shape: OvalBorder(),
                    ),

                    child: Center(
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.38,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSelectableButton(
                    index: 0,
                    width: buttonWidth,
                    height: buttonHeight,
                    text: 'سطحة',
                  ),
                  SizedBox(width: 16),
                buildSelectableButton(
                    index: 1,
                    width: buttonWidth,
                    height: buttonHeight,
                    text: 'في المركز',
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Text(
                "اليوم و التاريخ",
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),

              Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // زر اختيار التاريخ والوقت
                    GestureDetector(
                      onTap: () async {
                        // تحديد اللغة بناءً على لغة النظام أو التطبيق
                        bool isArabic =
                            Localizations.localeOf(context).languageCode ==
                            'ar';

                        // اختيار الألوان حسب الثيم الحالي
                        bool isDark =
                            Theme.of(context).brightness == Brightness.dark;

                        DateTime? dateTime = await showOmniDateTimePicker(
                          context: context,
                          initialDate: selectedDateTime ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          is24HourMode: true,
                          isShowSeconds: false,

                          // 🖌️ إعداد الألوان والثيم حسب الـ Mode
                          theme: ThemeData(
                            brightness:
                                isDark ? Brightness.dark : Brightness.light,
                            colorScheme:
                                isDark
                                    ? ColorScheme.dark(
                                      primary: Color(0xFFBA1B1B),
                                      // أزرار مميزة للوضع الداكن
                                      onPrimary: Colors.black,
                                      surface: const Color(0xFF222222),
                                      onSurface: Colors.white,
                                    )
                                    : ColorScheme.light(
                                      primary: const Color(0xFFBA1B1B),
                                      // بنفسجي ناعم للوضع الفاتح
                                      onPrimary: Colors.white,
                                      surface: const Color(0xFFF6F4F9),
                                      onSurface: Colors.black87,
                                    ),
                            dialogBackgroundColor:
                                isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        );

                        if (dateTime != null) {
                          setState(() {
                            selectedDateTime = dateTime;
                          });
                        }
                      },

                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 14.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade400
                                    : Colors.white30,
                          ),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : const Color(0xFF1E1E1E),
                          boxShadow: [
                            if (Theme.of(context).brightness ==
                                Brightness.light)
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDateTime == null
                                  ? (Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? "اختر اليوم و التاريخ"
                                      : "Select date & time")
                                  : "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}  ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black87
                                        : Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? const Color(0xFFBA1B1B)
                                      : Color(0xFFBA1B1B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomButton(
        textAr: "مراجعة الطلب",
        textEn: "Review Order",
        onPressed: () async {
          // ✅ التحقق من وجود العنوان
          if (_selectedAddress == null || _selectedLat == null || _selectedLng == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("يرجى اختيار العنوان أولاً"))
            );
            return;
          }

          // ✅ التحقق من وجود التاريخ والوقت
          if (selectedDateTime == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("يرجى اختيار اليوم و الوقت"))
            );
            return;
          }

          // ✅ التحقق من اختيار طريقة التوصيل
          if (selectedIndex != 0 && selectedIndex != 1) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("يرجى اختيار طريقة التوصيل"))
            );
            return;
          }

          final dio = Dio();
          final url = "$mainApi/app/elwarsha/payments/preview";

          // تحديد طريقة التوصيل حسب الزر المختار
          String deliveryMethod = selectedIndex == 0 ? "towTruck" : "inWorkshop";

          // تجهيز البيانات اللي جمعها المستخدم
          final formData = FormData.fromMap({
            "payment_method": "card",
            "payload": {
              "user_car_id": widget.selectedUserCarId,
              "delivery_method": deliveryMethod,
              "date":
              "${selectedDateTime!.year}-${selectedDateTime!.month.toString().padLeft(2, '0')}-${selectedDateTime!.day.toString().padLeft(2, '0')}",
              "time":
              "${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}",
              "address": _selectedAddress,
              "notes": widget.notes ?? "",
              "kilometers": int.tryParse(widget.kiloRead ?? "0") ?? 0,
              "is_car_working": (widget.isCarWorking == "true" || widget.isCarWorking == "1") ? 1 : 0,
              "items": [
                {
                  "type": widget.slug,
                  "id": (widget.selectedProduct is int)
                      ? widget.selectedProduct
                      : widget.selectedProduct?.id ?? 0,
                  "quantity": int.tryParse(widget.count ?? "1") ?? 1,
                },
              ],
            },
            // إضافة المرفقات لو موجودة
            if (widget.selectedCarDocs != null && widget.selectedCarDocs!.isNotEmpty)
              "attachments": await Future.wait(
                widget.selectedCarDocs!.map(
                      (file) async => await MultipartFile.fromFile(
                    file.path,
                    filename: file.path.split('/').last,
                  ),
                ),
              ),
            "points": 0,
          });

          print("🚀 Sending payment preview data...");
          print(formData);

          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          try {
            final response = await dio.post(
              url,
              data: formData,
              options: Options(
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $token",
                },
              ),
            );

            final data = response.data['data'];
            final model = PaymentPreviewModel.fromJson(data);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FinalReview(
                  model: model,
                  userCarId: widget.selectedUserCarId,
                  selectedProduct: widget.selectedProduct,
                  notes: widget.notes,
                  kiloRead: widget.kiloRead,
                  address: _selectedAddress,
                  dateTime: selectedDateTime,
                  deliveryMethod: selectedIndex == 1 ? "insite" : "outsite",
                  slug: widget.slug,
                  title: widget.title,
                  icon: widget.icon,
                  isCarWorking: widget.isCarWorking,
                  selectedCarDocs: widget.selectedCarDocs,
                  lat: _selectedLat,
                  long: _selectedLng,
                  count:  widget.count,
                ),
              ),
            );
          } catch (e) {
            if (e is DioException) {
              print("❌ Dio Error: ${e.response?.data ?? e.message}");
            } else {
              print("❌ Unexpected Error: $e");
            }
          }
        },
      ),
    );
  }

  Widget buildSelectableButton({
    required int index,
    required double width,
    required double height,
    required String text,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5, color: Color(0xFF9B9B9B)),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
                height: 1.57,
              ),
            ),
            Positioned(
              right: 10,
              top: height / 2 - 10,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFBA1B1B), width: 2),
                  color: isSelected ? Color(0xFFBA1B1B) : Colors.white,
                ),
                child:
                    isSelected
                        ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14, // حجم مناسب داخل الدائرة
                        )
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/car_info_card.dart';
import '../widgets/address_section.dart';
import '../widgets/delivery_method_selector.dart';
import '../widgets/datetime_picker_field.dart';
import '../widgets/header_section.dart';
import '../widgets/review_bottom_button.dart';

import '../../my_car/cubit/all_cars_cubit.dart';

class ReviewRequestPage extends StatefulWidget {
  final int? selectedUserCarId;
  final dynamic selectedProduct;
  final String? notes;
  final String? kiloRead;
  final List<File>? selectedCarDocs;
  final String title;
  final String icon;
  final String slug;
  final String? count;
  final String? isCarWorking;

  const ReviewRequestPage({
    super.key,
    this.selectedUserCarId,
    this.selectedProduct,
    this.notes,
    this.kiloRead,
    required this.title,
    required this.icon,
    required this.slug,
    this.selectedCarDocs,
    this.count,
    this.isCarWorking,
  });

  @override
  State<ReviewRequestPage> createState() => _ReviewRequestPageState();
}

class _ReviewRequestPageState extends State<ReviewRequestPage> {
  // الحالة (State)
  int selectedIndex = 0; // 0 = سطحة , 1 = في المركز
  String? selectedAddress;
  double? selectedLat, selectedLng;
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.selectedUserCarId != null) {
      context.read<CarCubit>().getUserCar(widget.selectedUserCarId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("جدولة الطلب"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1️⃣ العنوان + الأيقونة + progress bar
            ProgressHeader(title: widget.title, iconUrl: widget.icon),

            SizedBox(height: 15.h),

            // 2️⃣ بيانات السيارة
            CarInfoCard(carId: widget.selectedUserCarId),

            SizedBox(height: 15.h),

            // 3️⃣ العنوان
            AddressSection(
              selectedAddress: selectedAddress,
              onAddressSelected: (address, lat, lng) {
                setState(() {
                  selectedAddress = address;
                  selectedLat = lat;
                  selectedLng = lng;
                });
              },
            ),

            SizedBox(height: 15.h),

            // 4️⃣ طريقة التوصيل
        //   DeliveryMethodSelector(
        //     selectedIndex: selectedIndex,
        //     onSelected: (i) => setState(() => selectedIndex = i),
        //   ),
            Row(
              children: [
                Text(
                  "طريقة التوصيل",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBA1B1B),
                  ),
                ),
                SizedBox(width: 7.w),

                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFBA1B1B),
                    shape: OvalBorder(),
                  ),

                  child: Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.38,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSelectableButton(
                  index: 0,
                  width: 165,
                  height:45,
                  text: 'سطحة',
                ),
                SizedBox(width: 16),
                buildSelectableButton(
                  index: 1,
                  width: 165,
                  height: 45,
                  text: 'في المركز',
                ),
              ],
            ),

            SizedBox(height: 15.h),

            // 5️⃣ اليوم و التاريخ
            DateTimePickerField(
              selectedDateTime: selectedDateTime,
              onDateTimeSelected: (dt) => setState(() => selectedDateTime = dt),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),

      // 6️⃣ الزر السفلي
      bottomNavigationBar: ReviewBottomButton(
        widget: widget,
        selectedAddress: selectedAddress,
        selectedLat: selectedLat,
        selectedLng: selectedLng,
        selectedDateTime: selectedDateTime,
        selectedIndex: selectedIndex,
      ),
    );
  }  Widget buildSelectableButton({
    required int index,
    required double width,
    required double height,
    required String text,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5, color: Color(0xFF9B9B9B)),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
                height: 1.57,
              ),
            ),
            Positioned(
              right: 10,
              top: height / 2 - 10,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFBA1B1B), width: 2),
                  color: isSelected ? Color(0xFFBA1B1B) : Colors.white,
                ),
                child:
                isSelected
                    ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14, // حجم مناسب داخل الدائرة
                )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/language/locale.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/Custom-Button.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../orders/model/payment_preview_model.dart';
import '../widgets/review_req_body.dart';
import 'final-review.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/api.dart';

class ReviewRequestPage extends StatefulWidget {
  final int? selectedUserCarId;
  final dynamic selectedProduct;
  final String? notes;
  final String? kiloRead;
  final List<File>? selectedCarDocs;
  final String title;
  final String icon;
  final String slug;
  final String? count;
  final String? isCarWorking;

  const ReviewRequestPage({
    super.key,
    this.selectedUserCarId,
    this.selectedProduct,
    this.notes,
    this.kiloRead,
    this.selectedCarDocs,
    required this.title,
    required this.icon,
    required this.slug,
    this.count,
    this.isCarWorking,
  });

  @override
  State<ReviewRequestPage> createState() => _ReviewRequestPageState();
}

class _ReviewRequestPageState extends State<ReviewRequestPage> {
  int selectedIndex = 0;
  DateTime? selectedDateTime;
  String? selectedAddress;
  double? lat, lng;

  @override
  void initState() {
    super.initState();
    if (widget.selectedUserCarId != null) {
      context.read<CarCubit>().getUserCar(widget.selectedUserCarId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomGradientAppBar(
        title_ar: "جدولة الطلب",
        title_en: "My Orders",
        onBack: () => Navigator.pop(context),
      ),
      body: ReviewRequestBody(
        widget: widget,
        selectedIndex: selectedIndex,
        onDeliveryMethodChanged: (i) => setState(() => selectedIndex = i),
        onDateSelected: (date) => setState(() => selectedDateTime = date),
        onAddressSelected: (addr, lt, ln) => setState(() {
          selectedAddress = addr;
          lat = lt;
          lng = ln;
        }),
        selectedDateTime: selectedDateTime,
        selectedAddress: selectedAddress,
      ),
      bottomNavigationBar: CustomBottomButton(
        textAr: "مراجعة الطلب",
        textEn: "Review Order",
        onPressed: () => _onReviewPressed(context),
      ),
    );
  }

  Future<void> _onReviewPressed(BuildContext context) async {
    if (selectedAddress == null || lat == null || lng == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("يرجى اختيار العنوان أولاً")));
      return;
    }

    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("يرجى اختيار اليوم و الوقت")));
      return;
    }

    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = "$mainApi/app/elwarsha/payments/preview";

    final deliveryMethod = selectedIndex == 0 ? "towTruck" : "inWorkshop";

    final formData = {
      "payment_method": "card",
      "payload": {
        "user_car_id": widget.selectedUserCarId,
        "delivery_method": deliveryMethod,
        "date":
        "${selectedDateTime!.year}-${selectedDateTime!.month.toString().padLeft(2, '0')}-${selectedDateTime!.day.toString().padLeft(2, '0')}",
        "time":
        "${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}",
        "address": selectedAddress,
        "notes": widget.notes ?? "",
        "kilometers": int.tryParse(widget.kiloRead ?? "0") ?? 0,
        "is_car_working": widget.isCarWorking == true ? 1 : 0,

        "items": [
          {
            "type": widget.slug,
            "id": (widget.selectedProduct is int)
                ? widget.selectedProduct
                : widget.selectedProduct?.id ?? 0,
            "quantity": int.tryParse(widget.count ?? "1") ?? 1,
          },
        ],
      },
      "points": 0,
    };

    try {
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      final data = response.data['data'];
      final model = PaymentPreviewModel.fromJson(data);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FinalReview(
            model: model,
            userCarId: widget.selectedUserCarId,
            selectedProduct: widget.selectedProduct,
            notes: widget.notes,
            kiloRead: widget.kiloRead,
            address: selectedAddress,
            dateTime: selectedDateTime,
            deliveryMethod: selectedIndex == 1 ? "insite" : "outsite",
            slug: widget.slug,
            title: widget.title,
            icon: widget.icon,
            isCarWorking: widget.isCarWorking,
            selectedCarDocs: widget.selectedCarDocs,
            lat: lat,
            long: lng,
            count: widget.count,
          ),
        ),
      );
    } catch (e) {
      print("❌ Error sending preview: $e");
    }
  }
}

import 'dart:io';
import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/commponents.dart';
import '../../../widgets/web_payment.dart';
import '../../my_car/cubit/all_cars_cubit.dart';
import '../../my_car/cubit/all_cars_state.dart';
import '../../orders/model/payment_preview_model.dart';
import '../widgets/custom_app_bar.dart';
class FinalReview extends StatefulWidget {
  final PaymentPreviewModel model;
  final int? userCarId;
  final dynamic selectedProduct;
  final String? notes;
  final String? kiloRead;
  final String? address;
  final DateTime? dateTime;
  final String deliveryMethod;
  final String slug;
  final String title;
  final String icon;
  final double? lat;
  final double? long;
  final List<File>? selectedCarDocs;
  final String? count;
  final String? isCarWorking;

  const FinalReview({
    super.key,
    required this.model,
    this.userCarId,
    this.selectedProduct,
    this.notes,
    this.kiloRead,
    this.address,
    this.dateTime,
    required this.deliveryMethod,
    required this.slug,
    required this.title,
    required this.icon,
    this.lat,
    this.long,
    this.selectedCarDocs, this.count, this.isCarWorking,
  });

  @override
  State<FinalReview> createState() => _FinalReviewState();
}

class _FinalReviewState extends State<FinalReview> {
  String? selectedPaymentMethod;
  bool showPaymentMethods = false;
  late final locale = AppLocalizations.of(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:scaffoldBackgroundColor(context),
      appBar: CustomGradientAppBar(
        title_ar: "مراجعة الطلب",
        title_en: "My Orders",
        onBack: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.sp),
                topRight: Radius.circular(15.sp),
              ),color:backgroundColor(context),    ),
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 220.h),
                  child: Column(
                    children: [
                                 //   SizedBox(height: 12.h),
                                 //   Text("🔧 النوع: ${widget.slug}"),
                                 //   Text("🔧 النوع: ${widget.title}"),
                                 //   Text("🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧 النوع: ${widget.count}"),
                                 //   Text("🚗 رقم السيارة: ${widget.userCarId ?? '--'}"),
                                 //   Text("📦 المنتج: ${widget.selectedProduct?.name ?? '--'}"),
                                 //   Text("📦 المنتج: ${widget.selectedProduct?.id ?? '--'}"),
                                 //   Text("📦 المنتج: ${widget.selectedProduct?.name ?? '--'}"),
                                 //   Text("💰 السعر: ${widget.long ?? '--'}"),
                                 //   Text("💰 السعر: ${widget.lat ?? '--'}"),
                                 //   Text("📝 الملاحظات: ${widget.notes ?? 'لا توجد'}"),
                                 //   Text("📏 العداد: ${widget.kiloRead ?? '--'} كم"),
                                 //   Text("📍 العنوان: ${widget.address ?? '--'}"),
                                 //   Text("🚚 طريقة التوصيل: ${widget.deliveryMethod}"),
                                 //   Text(
                                 //     "⏰ التاريخ: ${widget.dateTime != null ? '${widget.dateTime!.day}/${widget.dateTime!.month}/${widget.dateTime!.year} ${widget.dateTime!.hour}:${widget.dateTime!.minute}' : '--'}",
                                 //   ),

                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: textColor(context),
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
                      SizedBox(height: 4.h),

                      Row(
                        children: [
                          Text(
                            "نوع الصيانه : ${widget.title}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 5),

                          Text(
                            "(${widget.deliveryMethod})",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(18, (index) {
                          return Container(
                            width: 18.w,
                            height: 2.h,
                            decoration: BoxDecoration(color: Colors.grey),
                          );
                        }),
                      ),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Text(
                            locale!.isDirectionRTL(context)
                                ? " السيارة "
                                : "The car",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      BlocBuilder<CarCubit, CarState>(
                        builder: (context, state) {
                          if (state is SingleCarLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is SingleCarLoaded) {
                            final car = state.car;
                            return Container(
                              decoration: BoxDecoration(
                                color: boxcolor(context),
                                border: Border.all(color: borderColor(context), width: 1.5.w),
                                borderRadius: BorderRadius.circular(12.sp),
                              ),
                              padding: EdgeInsets.all(8.sp),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100.w,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      child: Image.network(
                                        car.carBrand.icon ?? "",
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Image.asset(
                                          "assets/images/main_pack.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              locale!.isDirectionRTL(context) ? "الموديل:" : "Model:",
                                              style: TextStyle(
                                                color: textColor(context),
                                                fontSize: 12.sp,
                                                fontFamily: 'Graphik Arabic',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              " ${car.carBrand.name} ${car.carModel.name} ${car.year ?? ''}",
                                              style: TextStyle(
                                                color: accentColor,
                                                fontSize: 13.sp,
                                                fontFamily: 'Graphik Arabic',
                                                fontWeight: FontWeight.w600,
                                                height: 1.69,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        Row(
                                          children: [
                                            Text(
                                              locale!.isDirectionRTL(context) ? "رقم اللوحة:" : "license plate number:",
                                              style: TextStyle(
                                                color: textColor(context),
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
                                        SizedBox(height: 6.h),
                                        Row(
                                          children: [
                                            Text(
                                              locale!.isDirectionRTL(context) ? "الممشي:" : "Car mileage:",
                                              style: TextStyle(
                                                color: textColor(context),
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
                                                height: 1.3.h,
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
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(                                        locale!.isDirectionRTL(context) ? "تفاصيل الموعد :" : " Appointment Details",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color:textColor(context)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      Container(
                        decoration: BoxDecoration(
                          color:boxcolor(context),
                          border: Border.all(color:borderColor(context), width: 1.5.w),
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        padding: EdgeInsets.all(8.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  size: 25.sp,
                                  color: accentColor,
                                ),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (locale!.isDirectionRTL(context)
                                          ? "طريقة التوصيل "
                                          : "Delivery option "),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color:textColor(context)
                                      ),
                                    ),
                                    Text(
                                      widget.deliveryMethod,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color:borderColor(context)
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: accentColor,
                                  size: 25.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        locale!.isDirectionRTL(context) ? " العنوان " : "Address ",
                                        textAlign: locale!.isDirectionRTL(context)
                                            ? TextAlign.right
                                            : TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: textColor(context),
                                        ),
                                      ),
                                      Text(
                                        widget.address ?? '--',
                                        textAlign: locale!.isDirectionRTL(context)
                                            ? TextAlign.right
                                            : TextAlign.left,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: borderColor(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Color(0xFFBA1B1B),
                                  size: 25.sp,
                                ),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locale!.isDirectionRTL(context)
                                          ? " الوقت "
                                          : "The time "  ,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color:textColor(context),
                                      ),
                                    ),
                                    Text(
                                      '${widget.dateTime!.hour}:${widget.dateTime!.minute}',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color:borderColor(context),
                                      ),
                                    ),
                                    Text(
                                      "${widget.dateTime!.day}/${widget.dateTime!.month}/${widget.dateTime!.year} ",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color:borderColor(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            locale!.isDirectionRTL(context)
                                ? " استخدم رصيدك المالي : "
                                : "Use your financial balance :"  ,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color:textColor(context),
                            ),
                          ),
                          Spacer(),
                          Text(    locale!.isDirectionRTL(context)
                              ? "  رصيدك: 195 "
                              : "Your balance: 195 "  ,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color:borderColor(context),),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.sp),
                          border: Border.all(color: borderColor(context),width: 1.w),
                          color:boxcolor(context)
                        ),
                        child: Row(
                          textDirection: locale!.isDirectionRTL(context)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: TextField(
                                  textAlign: locale!.isDirectionRTL(context)
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: locale!.isDirectionRTL(context)
                                        ? "ادخل رصيدك"
                                        : "Enter your balance",
                                    hintStyle: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBA1B1B),
                                borderRadius: BorderRadius.only(
                                  topLeft: locale!.isDirectionRTL(context)
                                      ? Radius.circular(8.sp)
                                      : Radius.circular(0.sp),
                                  topRight: locale!.isDirectionRTL(context)
                                      ? Radius.circular(12.sp)
                                      : Radius.circular(8.sp),
                                  bottomLeft: locale!.isDirectionRTL(context)
                                      ? Radius.circular(8.sp)
                                      : Radius.circular(12.sp),
                                  bottomRight: locale!.isDirectionRTL(context)
                                      ? Radius.circular(0.sp)
                                      : Radius.circular(8.sp),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                locale!.isDirectionRTL(context) ? 'تطبيق' : "Apply",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(locale!.isDirectionRTL(context)?
                              " يمكنك إستخدام رصيد محفظتك في دفع رسوم الخدمة ":"You can use your wallet balance to pay the service fee",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color:borderColor(context)
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () {
                          print("تم الضغط على البانر");
                        },
                        child: Container(
                          height: 50.h,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBA1B1B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(locale!.isDirectionRTL(context)?
                                'وفر أكثر مع باقات أبوذياب':"Save more with Abu Diyab packages",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,

                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),

          ), SizedBox(height: 50.h,), Positioned(
            left: .5.w,
            right: .5.w,
            bottom: 0,
            child: Container(
              height: 200.h,
              padding: EdgeInsets.all(16),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: backgroundColor(context),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.5.w,
                    color:borderColor(context),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.sp),
                    topRight: Radius.circular(15.sp),
                  ),
                ),
              ),        child:
            Column(
              children: [
                Directionality(
                  textDirection: locale!.isDirectionRTL(context)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Subtotal"),
                          Spacer(),
                          Text(widget.model.breakdown.itemsSubtotal.toString() ,
                              style: TextStyle(fontSize: 14.sp,color: textColor(context))
                ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Discount"),
                          Spacer(),
                          Text(widget.model.breakdown.offerDiscount.toString()         ,
                              style: TextStyle(fontSize: 14.sp,color: textColor(context))
          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Total"
                              , style: TextStyle(fontSize: 14.sp,color:borderColor(context))),
                          Spacer(),
                          Text(widget.model.breakdown.total.toString(),
                              style: TextStyle(fontSize: 14.sp,color: textColor(context))
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),

                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.model.paymentMethods == null ||
                        widget.model.paymentMethods.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text(locale!.isDirectionRTL(context)?
                              'لا توجد طرق دفع متاحة حالياً':"No payment methods are currently available."
                          ,style: TextStyle(fontSize: 18.sp,color: accentColor),),
                        ),
                      );
                      return;
                    }
                    showModalBottomSheet(
                      context: context,
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.sp),
                        ),
                      ),
                      isScrollControlled: true,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            String? selected = selectedPaymentMethod;
                            return Container(
                              padding:  EdgeInsets.all(16.sp),
                              height: MediaQuery.of(context).size.height * 0.6,
                              decoration: BoxDecoration(
                                color:backgroundColor(context),
                                borderRadius:  BorderRadius.vertical(
                                  top: Radius.circular(20.sp),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40.w,
                                      height: 5.sp,
                                      margin:  EdgeInsets.only(bottom: 16.sp),
                                      decoration: BoxDecoration(
                                        color:borderColor(context),
                                        borderRadius: BorderRadius.circular(12.sp),
                                      ),
                                    ),
                                  ),
                                  Text(locale!.isDirectionRTL(context)?
                                    'طريقة الدفع':"Payment Options",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: textColor(context),
                                      fontSize: 16.sp,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w700,
                                      height: 1.2.h,
                                      letterSpacing: -0.10,
                                    ),
                                  ),
                                  SizedBox(height: 5.h,),
                                  Text(locale!.isDirectionRTL(context)?
                                    'برجاء إختيار طريقة الدفع المناسبة لك.':" choose your preferred payment method.",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: borderColor(context),
                                      fontSize: 16.sp,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w500,
                                      height: 1.2.h,
                                      letterSpacing: -0.10,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: widget.model.paymentMethods.length,
                                      itemBuilder: (context, index) {
                                        final method = widget.model.paymentMethods[index];
                                        final isSelected = selected == method.key;
            
                                        return GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              selected = method.key;
                                            });
                                            setState(() {
                                              selectedPaymentMethod = method.key;
                                            });
                                          },
                                          child: Container(
                                            height: 55.h,
                                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color:backgroundColor(context),
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: borderColor(context),
                                                width: 1.5.w,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: shadowcolor(context),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(  textDirection: locale!.isDirectionRTL(context)
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      method.name,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
            
                                                  Container(
                                                    width: 26.w,
                                                    height: 26.h,
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? Color(0xFFBA1B1B) : Colors.transparent,
            
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: isSelected ? Color(0xFFBA1B1B) : Colors.grey,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: isSelected
                                                        ? Center(child: Icon(Icons.check,size: 14.sp,color: Colors.white,))
                                                        : SizedBox(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (selectedPaymentMethod == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(locale!.isDirectionRTL(context)?
                                              'من فضلك اختر وسيلة الدفع ':"Please select a payment method.",
                                            ),
                                          ),
                                        );
                                        return;
                                      }
            
                                      final prefs =
                                      await SharedPreferences.getInstance();
                                      final token = prefs.getString('token');
                                      if (token == null || token.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'خطأ: لم يتم العثور على التوكن',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      final url =
                                          "https://devapi.a-vsc.com/api/app/elwarsha/payments/initiate";
                                      final formData = FormData();
                                      final fields = {
                                        "payment_method": selectedPaymentMethod,
                                        "payload[user_car_id]": widget.userCarId,
                                        "payload[delivery_method]":
                                        widget.deliveryMethod,
                                        "payload[date]":
                                        "${widget.dateTime?.year}-${widget.dateTime?.month.toString().padLeft(2, '0')}-${widget.dateTime?.day.toString().padLeft(2, '0')}",
                                        "payload[time]":
                                        "${widget.dateTime?.hour.toString().padLeft(2, '0')}:${widget.dateTime?.minute.toString().padLeft(2, '0')}",
                                        "payload[address]": widget.address ?? "",
                                        "payload[notes]": widget.notes ?? "",
                                        "payload[kilometers]":
                                        widget.kiloRead ?? "0",
                                        "payload[lat]": widget.lat ?? "",
                                        "payload[long]": widget.long ?? "",
                                        "payload[is_car_working]": (widget.isCarWorking == "true" || widget.isCarWorking == "1") ? 1 : 0,
                                        "payload[items][0][type]":
                                        widget.slug ?? "0",
                                        "payload[items][0][id]":
                                        (widget.selectedProduct is int)
                                            ? widget.selectedProduct
                                            : widget.selectedProduct?.id ?? 0,
                                        "payload[items][0][quantity]":widget.count?? "1",
            
            
                                      };
            
                                      fields.forEach((key, value) {
                                        formData.fields.add(
                                          MapEntry(key, value.toString()),
                                        );
                                        debugPrint("🧾 FIELD => $key: $value");
                                      });
            
            
                                      if (widget.selectedCarDocs != null &&
                                          widget.selectedCarDocs!.isNotEmpty) {
                                        for (
                                        int i = 0;
                                        i < widget.selectedCarDocs!.length;
                                        i++
                                        ) {
                                          final file = widget.selectedCarDocs![i];
                                          final multipartFile =
                                          await MultipartFile.fromFile(
                                            file.path,
                                            filename: file.path.split('/').last,
                                          );
                                          formData.files.add(
                                            MapEntry("media[$i]", multipartFile),
                                          );
                                          debugPrint(
                                            "📸 FILE => media[$i]: ${file.path}",
                                          );
                                        }
                                      } else {
                                        debugPrint(
                                          "📎 No images selected to upload.",
                                        );
                                      }
            
                                      debugPrint(
                                        "🚀======================================",
                                      );
                                      debugPrint(
                                        "✅ FORM DATA READY TO SEND (${formData.fields.length} fields, ${formData.files.length} files)",
                                      );
                                      debugPrint(
                                        "🚀======================================",
                                      );
            
                                      final dio = Dio(
                                        BaseOptions(
                                          headers: {
                                            "Authorization": "Bearer $token",
                                            "Accept": "application/json",
                                          },
                                        ),
                                      );
            
                                      try {
                                        debugPrint(
                                          "📡 Sending request to: $url ...",
                                        );
            
                                        final response = await dio.post(
                                          url,
                                          data: formData,
                                        );debugPrint(
                                          "📡 Status: ${response.statusCode}",);
                                        debugPrint("📡 Response: ${response.data}");
            
                                        if (response.statusCode == 201 &&
                                            response.data["data"]?["payment_url"] !=
                                                null) {
                                          final paymentUrl =
                                          response.data["data"]["payment_url"];
                                          debugPrint("✅ Payment URL: $paymentUrl");
            
                                          navigateTo(
                                            context,
                                            WebPayment(url: paymentUrl),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                response.data["msg"] ??
                                                    'فشل في بدء عملية الدفع',
                                              ),
                                            ),
                                          );
                                        }
                                      } on DioException catch (e) {
                                        debugPrint(
                                          "❌ Dio error: ${e.response?.data ?? e.message}",
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'خطأ في الاتصال بالخادم: ${e.message}',
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        debugPrint("❌ Unexpected error: $e");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('حدث خطأ غير متوقع'),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      minimumSize:  Size(double.infinity, 30.sp),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.sp),
                                      ),
                                    ),
                                    child:  Text(locale!.isDirectionRTL(context)?
                                      "تأكيد الطلب":"Confirm Order",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:accentColor,
                    minimumSize:  Size(double.infinity, 35.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  child:  Text(locale!.isDirectionRTL(context)?
                  "تأكيد الطلب":"Confirm Order",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ],
      ),

    );
  }
}

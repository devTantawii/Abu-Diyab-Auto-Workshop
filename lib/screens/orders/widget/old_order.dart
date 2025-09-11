import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';

class OldOrder extends StatelessWidget {
  const OldOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      width: 350.w,
      height: 454.h,
      // Makes container responsive
      padding: EdgeInsets.all(12),
      // Add padding instead of hardcoded positions
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).brightness == Brightness.light
                    ? Color(0x3F000000)
                    : Color(0xFF9B8989),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Service name row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'اسم الخدمة :',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                          ?Colors.black
                          :Colors.white,

                        fontSize: 15.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.10,
                      ),
                    ),
                    TextSpan(
                      text: 'غسيل ونظافة',
                      style: TextStyle(
                        color: const Color(0xFFBA1B1B),
                        fontSize: 22.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 8),
              Container(
                width: 23.w,
                height: 23.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icons/car_fact.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),
          SizedBox(height: 3),

          // Status and order number row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'رقــم الطلـب : ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ?Colors.black
                          :Colors.white,                      fontSize: 16.h,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '9704#',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFFBA1B1B),
                      fontSize: 16.h,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: ShapeDecoration(
                  color: const Color(0xFF00B441),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'قيد التنفيذ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.h,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                    height: 1.38,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),
          SizedBox(height: 3),

          // Vehicle details section
          Row(
            //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle image placeholder
              Container(
                width: 93.w,
                height: 85.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/icons/car_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),

              // Vehicle details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'المــوديــل : ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ?Colors.black
                              :Colors.white,                          fontSize: 12.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.83,
                        ),
                      ),
                      SizedBox(width: 8),

                      Text(
                        'جيلي اميجراند 2023',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFBA1B1B),
                          fontSize: 13.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 9),

                  Row(
                    children: [
                      Text(
                        'المــوديــل : ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ?Colors.black
                              :Colors.white,                          fontSize: 12.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.83,
                        ),
                      ),
                      SizedBox(width: 8),

                      Text(
                        'جيلي اميجراند 2023',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFBA1B1B),
                          fontSize: 13.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 9),

                  Row(
                    children: [
                      Text(
                        'المــوديــل : ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ?Colors.black
                              :Colors.white,                          fontSize: 12.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.83,
                        ),
                      ),
                      SizedBox(width: 8),

                      Text(
                        'جيلي اميجراند 2023',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFBA1B1B),
                          fontSize: 13.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),
          SizedBox(height: 3),
          // Delivery estimate
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تاريخ الإنجاز :',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ?Colors.black
                      :Colors.white,                  fontSize: 16,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                  height: 1.38,
                ),
              ),
              SizedBox(width: 8),
              Text(
                ' 5 / 9',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFFBA1B1B),
                  fontSize: 22,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),
          SizedBox(height: 3),
          Center(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 327.w),
              height: 55.h,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1.5,
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/design_money.png',
                      width: 22.w,
                      height: 22.h,
                    ),
                    SizedBox(width: 8.w),

                    Text(
                      'إجمالي الفاتورة:',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.22,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    Text(
                      '1923',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFFBA1B1B),
                        fontSize: 25.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    Image.asset(
                      'assets/icons/ryal.png',
                      width: 22.w,
                      height: 22.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),
          SizedBox(height: 3),

          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFBA1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'إعادة الطلب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                      height: 1.47,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 22),
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.30,
                        color: Theme.of(context).brightness == Brightness.light
                            ?Colors.black
                            :Colors.white,

                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'وش رأيك بالخدمة؟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ?Colors.black
                          :Colors.white,
                      fontSize: 15,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                      height: 1.47,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// lib/screens/final_review/widgets/appointment_details.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';

class AppointmentDetails extends StatelessWidget {
  final String deliveryMethod;
  final String? address;
  final DateTime? dateTime;

  const AppointmentDetails({
    super.key,
    required this.deliveryMethod,
    this.address,
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              locale!.isDirectionRTL(context) ? "تفاصيل الموعد :" : " Appointment Details",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: headingColor(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: buttonBgWhiteColor(context),
            border: Border.all(color: buttonSecondaryBorderColor(context), width: 1.5.w),
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
                    color: typographyMainColor(context),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.isDirectionRTL(context) ? "طريقة التوصيل " : "Delivery option ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: headingColor(context),
                        ),
                      ),
                      Text(
                        deliveryMethod,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: paragraphColor(context),
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
                    color: typographyMainColor(context),
                    size: 25.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.isDirectionRTL(context) ? " العنوان " : "Address ",
                          textAlign: locale.isDirectionRTL(context) ? TextAlign.right : TextAlign.left,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: headingColor(context),
                          ),
                        ),
                        Text(
                          address ?? '--',
                          textAlign: locale.isDirectionRTL(context) ? TextAlign.right : TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: paragraphColor(context),
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
                    color: typographyMainColor(context),
                    size: 25.sp,
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.isDirectionRTL(context) ? " الوقت " : "The time ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: headingColor(context),
                        ),
                      ),
                      Text(
                        '${dateTime!.hour}:${dateTime!.minute}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: paragraphColor(context),
                        ),
                      ),
                      Text(
                        "${dateTime!.day}/${dateTime!.month}/${dateTime!.year} ",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: paragraphColor(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
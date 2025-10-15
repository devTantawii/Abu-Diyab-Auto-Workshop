import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/progress_bar.dart';
import 'address_section.dart';
import 'car_info_card.dart';
import 'datetime_picker_field.dart';
import 'delivery_method_selector.dart';

class ReviewRequestBody extends StatelessWidget {
  final dynamic widget;
  final int selectedIndex;
  final DateTime? selectedDateTime;
  final String? selectedAddress;
  final Function(int) onDeliveryMethodChanged;
  final Function(DateTime) onDateSelected;
  final Function(String, double, double) onAddressSelected;

  const ReviewRequestBody({
    super.key,
    required this.widget,
    required this.selectedIndex,
    required this.onDeliveryMethodChanged,
    required this.onDateSelected,
    required this.onAddressSelected,
    this.selectedDateTime,
    this.selectedAddress,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      //    Text(widget.isCarWorking ?? ""),
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(width: 5),
              Image.network(
                widget.icon ?? '',
                height: 20.h,
                width: 20.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {

                  return Icon(
                    Icons.image_not_supported,
                    size: 20.h,
                    color: Colors.grey,
                  );
                },
              )
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [ProgressBar(), ProgressBar(active: true), ProgressBar()],
          ),
          SizedBox(height: 20.h),
          CarInfoSection(),
          SizedBox(height: 20.h),
          AddressSection(onAddressSelected: onAddressSelected),
          SizedBox(height: 20.h),
          DeliveryMethodSection(
            selectedIndex: selectedIndex,
            onChanged: onDeliveryMethodChanged,
          ),
          SizedBox(height: 20.h),
          DateTimeSection(
            selectedDateTime: selectedDateTime,
            onSelected: onDateSelected,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/language/locale.dart';

class DetailItem extends StatelessWidget {
  final String labelAr;
  final String labelEn;
  final String value;

  const DetailItem({
    super.key,
    required this.labelAr,
    required this.labelEn,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Row(
      children: [
        Text(
          locale!.isDirectionRTL(context)
              ? "$labelAr"
              : "$labelEn",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white54,
            fontSize: 14.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFFBA1B1B),
            fontSize: 14.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
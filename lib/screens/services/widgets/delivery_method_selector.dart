// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class DeliveryMethodSelector extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int index) onSelected;
//
//   const DeliveryMethodSelector({
//     super.key,
//     required this.selectedIndex,
//     required this.onSelected,
//   });
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//       Row(
//                 children: [
//                   Text(
//                     "طريقة التوصيل",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFFBA1B1B),
//                     ),
//                   ),
//                   SizedBox(width: 7.w),
//
//                   Container(
//                     width: 20.w,
//                     height: 20.h,
//                     decoration: ShapeDecoration(
//                       color: const Color(0xFFBA1B1B),
//                       shape: OvalBorder(),
//                     ),
//
//                     child: Center(
//                       child: Text(
//                         '!',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontFamily: 'Graphik Arabic',
//                           fontWeight: FontWeight.w600,
//                           height: 1.38,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildSelectableButton(
//                     index: 0,
//                     width: buttonWidth,
//                     height: buttonHeight,
//                     text: 'سطحة',
//                   ),
//                   SizedBox(width: 16),
//                   buildSelectableButton(
//                     index: 1,
//                     width: buttonWidth,
//                     height: buttonHeight,
//                     text: 'في المركز',
//                   ),
//                 ],
//               ),
//       ],
//     );
//   }
//
//   Widget buildSelectableButton({
//     required int index,
//     required double width,
//     required double height,
//     required String text,
//   }) {
//     bool isSelected = selectedIndex == index;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedIndex = index;
//         });
//       },
//       child: Container(
//         width: width,
//         height: height,
//         clipBehavior: Clip.antiAlias,
//         decoration: ShapeDecoration(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(width: 1.5, color: Color(0xFF9B9B9B)),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           shadows: [
//             BoxShadow(
//               color: Color(0x3F000000),
//               blurRadius: 12,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Text(
//               text,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 14,
//                 fontFamily: 'Graphik Arabic',
//                 fontWeight: FontWeight.w600,
//                 height: 1.57,
//               ),
//             ),
//             Positioned(
//               right: 10,
//               top: height / 2 - 10,
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 200),
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Color(0xFFBA1B1B), width: 2),
//                   color: isSelected ? Color(0xFFBA1B1B) : Colors.white,
//                 ),
//                 child:
//                     isSelected
//                         ? Icon(
//                           Icons.check,
//                           color: Colors.white,
//                           size: 14, // حجم مناسب داخل الدائرة
//                         )
//                         : null,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryMethodSection extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;
  const DeliveryMethodSection({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 48) / 2;
    double height = 50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "طريقة التوصيل",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFBA1B1B),
              ),
            ),
            SizedBox(width: 7.w),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: const ShapeDecoration(
                color: Color(0xFFBA1B1B),
                shape: OvalBorder(),
              ),
              child: const Center(
                child: Text(
                  '!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
            _methodButton(context, 0, "سطحة", width, height),
            SizedBox(width: 16),
            _methodButton(context, 1, "في المركز", width, height),
          ],
        ),
      ],
    );
  }

  Widget _methodButton(
      BuildContext context, int index, String text, double width, double height) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onChanged(index),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.5, color: Color(0xFF9B9B9B)),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
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
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Positioned(
              right: 10,
              top: height / 2 - 10,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                  Border.all(color: const Color(0xFFBA1B1B), width: 2),
                  color: isSelected ? const Color(0xFFBA1B1B) : Colors.white,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

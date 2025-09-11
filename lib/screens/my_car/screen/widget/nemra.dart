import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Nemra extends StatefulWidget {
  const Nemra({
    super.key,
    required this.arabicLettersController,
    required this.englishNumbersController,
  });

  final TextEditingController arabicLettersController;
  final TextEditingController englishNumbersController;

  @override
  State<Nemra> createState() => _NemraState();
}

class _NemraState extends State<Nemra> {
  @override
  void initState() {
    super.initState();
    // ✅ نخلي الحروف تتكتب بشكل منفصل (بمسافات)
    widget.arabicLettersController.addListener(() {
      final rawText =
      widget.arabicLettersController.text.replaceAll(' ', '');
      final spacedText = rawText.split('').join(' ');
      if (widget.arabicLettersController.text != spacedText) {
        widget.arabicLettersController.value =
            widget.arabicLettersController.value.copyWith(
              text: spacedText,
              selection: TextSelection.collapsed(offset: spacedText.length),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ألوان الوضع الفاتح والداكن
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? Colors.white : Colors.black;
    final borderColor = isLight ? Colors.black : Colors.white70;
    final textColor = isLight ? Colors.black : Colors.white;
    final hintColor = isLight ? Colors.black54 : Colors.white54;
    final dotColor = isLight ? Colors.black : Colors.white;

    return Center(
      child: Container(
        width: 193,
        height: 160,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Stack(
          children: [
            // الخط الفاصل الأفقي
            Positioned(
              left: 0,
              top: 80,
              child: Container(
                width: 152,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.5, color: borderColor),
                  ),
                ),
              ),
            ),
            // الفاصل العمودي
            Positioned(
              left: 151,
              top: 0,
              child: Container(
                transform: Matrix4.identity()..rotateZ(1.57),
                width: 160,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.5, color: borderColor),
                  ),
                ),
              ),
            ),
            // العمود الجانبي (العلم + KSA)
            Positioned(
              left: 157,
              top: 10,
              child: SizedBox(
                width: 30,
                child: Column(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 23,
                      child: Image.asset('assets/icons/ksa_flag.png',color: textColor,),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'السعودية',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 8,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'K\nS\nA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: ShapeDecoration(
                        color: dotColor,
                        shape: const OvalBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ الحروف العربية (فوق)
            Positioned(
              left: 15,
              top: 25,
              child: SizedBox(
                width: 120,
                height: 35,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: widget.arabicLettersController,
                    maxLength: 5,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[\u0600-\u06FF\s]'),
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: 'أ ب ج',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: hintColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ✅ الأرقام الإنجليزية (تحت)
            Positioned(
              left: 15,
              top: 105,
              child: SizedBox(
                width: 120,
                height: 35,
                child: TextField(
                  controller: widget.englishNumbersController,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: '1234',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: hintColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

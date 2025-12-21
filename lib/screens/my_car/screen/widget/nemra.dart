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
    widget.arabicLettersController.addListener(() {
      final rawText = widget.arabicLettersController.text.replaceAll(' ', '');
      final spacedText = rawText.split('').join(' ');
      if (widget.arabicLettersController.text != spacedText) {
        widget.arabicLettersController.value = widget
            .arabicLettersController
            .value
            .copyWith(
              text: spacedText,
              selection: TextSelection.collapsed(offset: spacedText.length),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? Colors.white : Colors.black;
    final borderColor = isLight ? Colors.grey.shade400 : Colors.white70;
    final textColor = isLight ? Colors.black : Colors.white;
    final hintColor = isLight ? Colors.black54 : Colors.white54;
    final dotColor = isLight ? Colors.black : Colors.white;

    return Center(
      child: Container(
        width: double.infinity,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset(
                    'assets/icons/ksa_flag.png',
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'السعودية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'KSA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 10,
                  height: 10,
                  decoration: ShapeDecoration(
                    color: dotColor,
                    shape: const OvalBorder(),
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 80,
              color: Colors.black,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 50,
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
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: 'أ ب ج',
                      hintStyle: TextStyle(fontSize: 22, color: hintColor),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              width: 1,
              height: 80,
              color: Colors.black,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 50,
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
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: '1234',
                    hintStyle: TextStyle(fontSize: 22, color: hintColor),
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

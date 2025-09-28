import 'package:abu_diyab_workshop/screens/more/screen/widget/active_bakat.dart';
import 'package:abu_diyab_workshop/screens/more/screen/widget/old_bakat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/language/locale.dart';
import '../../services/widgets/Service-Custom-AppBar.dart';
class BakatScreen extends StatefulWidget {
  const BakatScreen({super.key});
  @override
  State<BakatScreen> createState() => _BakatScreenState();
}
bool _showActiveOrders = true;
class _BakatScreenState extends State<BakatScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color activeOrdersBackgroundColor = _showActiveOrders
        ? const Color(0xFFBA1B1B)
        : isDark
        ? Colors.black
        : Colors.white24;
    final Color oldOrdersBackgroundColor = !_showActiveOrders
        ? const Color(0xFFBA1B1B)
        : isDark
        ? Colors.black
        : Colors.white24;
    return Scaffold(
      backgroundColor:
      Theme.of(context).brightness == Brightness.light
          ? Color(0xFFD27A7A)
          : const Color(0xFF6F5252),
      appBar:  CustomGradientAppBar(
        title_ar:  "الباقات",
        title_en: "packages",
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        decoration:BoxDecoration(
          color:
          Theme.of(context).brightness == Brightness.light
              ? Colors.white: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
        ),
        child: Column(
          children: [
            // Tabs Row
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Active Orders Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showActiveOrders = true;
                        });
                      },
                      child: Container(
                        height: 50.h,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:     Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            width: 1,
                          ),
                          color: activeOrdersBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: Theme.of(context).brightness == Brightness.dark
                              ? [
                          ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            'الباقات الحاليه',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:  Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                              height: 1.22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 35), // Add some spacing between tabs
                  // Old Orders Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showActiveOrders = false;
                        });
                      },
                      child: Container(
                        height: 50.h,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:     Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            width: 1,
                          ),
                          color: oldOrdersBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'الباقات السابقه',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                              height: 1.22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40), // Add some spacing
            // Content Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  child: _showActiveOrders ? ActiveBakatContent() : OldBakatContent(),
                ),
              ),
            ),
          ],
        ),
      ),    );
  }
  Widget ActiveBakatContent() {
    return ListView(
      children: [
        // Your active orders items here
        // Example: the responsive container we created earlier
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ActiveBakat(),
        ),
        // Add more active orders as needed
      ],
    );
  }
  Widget OldBakatContent() {
    return ListView(
      children: [
        // Your old orders items here
        Padding(
          padding: EdgeInsets.all(8.0),
          child: OldBakat(),
        ),
        // Add more old orders as needed
      ],
    );
  }
}
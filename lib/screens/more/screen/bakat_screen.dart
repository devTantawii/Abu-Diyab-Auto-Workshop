import 'package:abu_diyab_workshop/screens/more/screen/widget/active_bakat.dart';
import 'package:abu_diyab_workshop/screens/more/screen/widget/old_bakat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/language/locale.dart';
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
      backgroundColor: Color(0xFFD27A7A),
      appBar: AppBar(
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 130.h,
            padding: EdgeInsets.only(top: 20.h, right: 16.w, left: 16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.light
                    ? [const Color(0xFFBA1B1B), const Color(0xFFD27A7A)]
                    : [const Color(0xFF690505), const Color(0xFF6F5252)],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    locale!.isDirectionRTL(context)
                        ? " الباقات"
                        : "packages ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
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
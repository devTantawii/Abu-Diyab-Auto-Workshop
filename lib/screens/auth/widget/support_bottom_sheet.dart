import 'dart:io';
import 'package:abu_diyab_workshop/screens/auth/widget/help_pop.dart';
import 'package:abu_diyab_workshop/screens/complaint/screens/complaint_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import 'common_question.dart';

class SupportBottomSheet extends StatefulWidget {
  const SupportBottomSheet({Key? key}) : super(key: key);

  @override
  State<SupportBottomSheet> createState() => _SupportBottomSheetState();
}

class _SupportBottomSheetState extends State<SupportBottomSheet> {
  whatsapp() async {
    var contact = "+966559578781";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  insta() async {
    var androidUrl =
        'https://www.instagram.com/abudiyabauto/';
    var iosUrl =
        'https://www.instagram.com/abudiyabauto/';

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  facebook() async {
    var androidUrl =
        'https://www.facebook.com/avscsa/';
    var iosUrl = "https://www.facebook.com/avscsa/";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  snapchat() async {
    var androidUrl = 'https://snapchat.com/t/MXhkWwAF';
    var iosUrl = "https://snapchat.com/t/MXhkWwAF";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  xtwitter() async {
    var androidUrl = 'https://x.com/AVSC_SA';
    var iosUrl = "https://x.com/AVSC_SA";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  tiktok() async {
    var androidUrl = "https://www.tiktok.com/@avscsa";
    var iosUrl = "https://www.tiktok.com/@avscsa";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  linkedin() async {
    var androidUrl =
        "https://www.linkedin.com/in/%D9%85%D8%B1%D9%83%D8%B2-%D8%A3%D8%A8%D9%88%D8%B0%D9%8A%D8%A7%D8%A8-%D9%84%D8%B5%D9%8A%D8%A7%D9%86%D8%A9-%D8%A7%D9%84%D8%B3%D9%8A%D8%A7%D8%B1%D8%A7%D8%AA-231b79354/";
    var iosUrl =
        "https://www.linkedin.com/in/%D9%85%D8%B1%D9%83%D8%B2-%D8%A3%D8%A8%D9%88%D8%B0%D9%8A%D8%A7%D8%A8-%D9%84%D8%B5%D9%8A%D8%A7%D9%86%D8%A9-%D8%A7%D9%84%D8%B3%D9%8A%D8%A7%D8%B1%D8%A7%D8%AA-231b79354/";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  web() async {
    var androidUrl = 'https://flutter.dev';
    var iosUrl = "https://wa.me/?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  email() async {
    final String email = "hadyalsawah52@gmail.com";
    final String subject = Uri.encodeComponent("الدعم الفني");
    final String body = Uri.encodeComponent("السلام عليكم، أحتاج مساعدة.");

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );

    try {
      await launchUrl(emailUri);
    } on Exception {
      // EasyLoading.showError('لا يمكن فتح تطبيق البريد الإلكتروني.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors. white
            : Colors. black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale!.isDirectionRTL(context)
                  ? "وش تبي نساعدك فيه؟"
                  : "What do you want us to help you with?",

              style: TextStyle(
                color:Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 17.sp,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              locale!.isDirectionRTL(context)
                  ? "كل وسائل التواصل تحت خدمتك، اختار اللي يناسبك ."
                  : "All means of communication are at your service, choose what suits you.",

              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ?Colors.black.withValues(alpha: 0.70)
                    : Colors.white,
                fontSize: 12.sp,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: HelpCard(
                    title: locale!.isDirectionRTL(context) ? 'مكالمة' : 'Call',
                    description:
                        locale!.isDirectionRTL(context)
                            ? 'اتصل بنا عن طريق رقمنا الموحد.'
                            : 'Call us through our unified number.',
                    iconPath: 'assets/icons/call_icon.png',
                    onTap: () async {
                      final Uri telUri = Uri(
                        scheme: 'tel',
                        path: '+966559578781',
                      );
                      if (await canLaunchUrl(telUri)) {
                        await launchUrl(telUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              locale!.isDirectionRTL(context)
                                  ? 'لا يمكن فتح الاتصال'
                                  : 'Cannot make the call',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(width: 10), // مسافة بسيطة بين البطاقتين
                Flexible(
                  child: HelpCard(
                    title:
                        locale!.isDirectionRTL(context)
                            ? 'واتس اب'
                            : 'WhatsApp',
                    description:
                        locale!.isDirectionRTL(context)
                            ? 'ابدأ محادثة مع أحد ممثلي خدمة العملاء.'
                            : 'Start a chat with a customer service representative.',
                    iconPath: 'assets/icons/whatsapp_icon.png',
                    onTap: () async {
                      whatsapp();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplaintScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color:Theme.of(context).brightness == Brightness.light
                      ? Colors. white
                      : Colors. black,
                  border: Border.all(color: Color(0xFFAFAFAF), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale!.isDirectionRTL(context)
                          ? "الشكاوي"
                          : "Complaints",
                      style: TextStyle(
                        color:Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 15.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(),
                      child: Image.asset(
                        'assets/icons/complaint.png',
                        fit: BoxFit.contain,color:  typographyMainColor(context)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.h),
            Center(
              child: Text(
                locale!.isDirectionRTL(context)
                    ? "مواقع التواصل الإجتماعي"
                    : "social media sites",
                style: TextStyle(
                  color:Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      insta();
                    },
                    icon: Image.asset(
                      'assets/icons/insta.png',
                      width: 46.w,
                      height: 46.h,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      facebook();
                    },
                    icon: Image.asset(
                      'assets/icons/facebook.png',
                      width: 46.w,
                      height: 46.h,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      snapchat();
                    },
                    icon: Image.asset(
                      'assets/icons/Snapchat.png',
                      width: 46.w,
                      height: 46.h,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      xtwitter();
                    },
                    icon: Image.asset(
                      'assets/icons/x.png',
                      width: 46.w,
                      height: 46.h,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      tiktok();
                    },
                    icon: Image.asset(
                      'assets/icons/tiktok.png',
                      width: 46.w,
                      height: 46.h,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      linkedin();
                    },
                    icon: Image.asset(
                      'assets/icons/linkedin.png',
                      width: 46.w,
                      height: 46.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Center(
              child: Text(
                "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
              ),
            ),
            SizedBox(height: 40.h),
            Center(
              child: Text(
                locale!.isDirectionRTL(context)
                    ? "لزيارة موقعنا الإلكترونى"
                    : "To visit our website",
                //  textAlign: TextAlign.right,
                style: TextStyle(
                  color:Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Center(
              child: IconButton(
                onPressed: () {
                  web();
                },
                icon: Image.asset(
                  'assets/icons/web_icon.png',
                  width: 50.w,
                  height: 50.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

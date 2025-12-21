import 'dart:io';
import 'package:abu_diyab_workshop/screens/auth/widget/help_pop.dart';
import 'package:abu_diyab_workshop/screens/complaint/screens/complaint_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../more/cubit/settings/settings_cubit.dart';

class SupportBottomSheet extends StatefulWidget {
  const SupportBottomSheet({Key? key}) : super(key: key);

  @override
  State<SupportBottomSheet> createState() => _SupportBottomSheetState();
}

class _SupportBottomSheetState extends State<SupportBottomSheet> {

  Map<String, String> settings = {};

  @override
  void initState() {
    super.initState();
    context.read<AppSettingsCubit>().fetchAppSettings();
  }

  Future<void> launchLink(String? androidUrl, String? iosUrl) async {
    if (androidUrl == null && iosUrl == null) return;
    final url = Platform.isIOS ? iosUrl! : androidUrl!;
    try {
      await launchUrl(Uri.parse(url));
    } catch (_) {}
  }

  Future<void> whatsapp() async {
    final contact = settings['whatsapp'] ?? "+966559578781";
    final androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    final iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";
    await launchLink(androidUrl, iosUrl);
  }

  Future<void> insta() async {
    final url = settings['instagram'] ?? "https://www.instagram.com/abudiyabfix/";
    await launchLink(url, url);
  }

  Future<void> facebook() async {
    final url = settings['facebook'] ?? "https://www.facebook.com/avscsa/";
    await launchLink(url, url);
  }

  Future<void> snapchat() async {
    final url = settings['snapchat'] ?? "https://www.snapchat.com/@avscsa";
    await launchLink(url, url);
  }

  Future<void> xtwitter() async {
    final url = settings['x'] ?? "https://x.com/abudiyabfix";
    await launchLink(url, url);
  }

  Future<void> tiktok() async {
    final url = settings['tiktok'] ?? "https://www.tiktok.com/@abudiyabfix";
    await launchLink(url, url);
  }

  Future<void> linkedin() async {
    final url = settings['linkedin'] ?? "https://www.linkedin.com/";
    await launchLink(url, url);
  }

  Future<void> web() async {
    final url = settings['telegram'] ?? "https://www.telegram.com/";
    await launchLink(url, url);
  }

  Future<void> email() async {
    final email = settings['email'] ?? "cs@a-vsc.com";
    final subject = Uri.encodeComponent("الدعم الفني");
    final body = Uri.encodeComponent("السلام عليكم، أحتاج مساعدة.");
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );
    try {
      await launchUrl(emailUri);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, state) {
        if (state is AppSettingsLoaded) {
          settings = state.settings;
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale!.isDirectionRTL(context)
                      ? "وش تبي نساعدك فيه؟"
                      : "What do you want us to help you with?",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 17.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  locale.isDirectionRTL(context)
                      ? "كل وسائل التواصل تحت خدمتك، اختار اللي يناسبك ."
                      : "All means of communication are at your service, choose what suits you.",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.7)
                        : Colors.white,
                    fontSize: 13.sp,
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
                        title: locale.isDirectionRTL(context) ? 'مكالمة' : 'Call',
                        description: locale.isDirectionRTL(context)
                            ? 'اتصل بنا عن طريق رقمنا الموحد.'
                            : 'Call us through our unified number.',
                        iconPath: 'assets/icons/call_icon.png',
                        onTap: () async {
                          final Uri telUri = Uri(
                            scheme: 'tel',
                            path: settings['whatsapp'] ?? "+966559578781",
                          );
                          if (await canLaunchUrl(telUri)) {
                            await launchUrl(telUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  locale.isDirectionRTL(context)
                                      ? 'لا يمكن فتح الاتصال'
                                      : 'Cannot make the call',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: HelpCard(
                        title: locale.isDirectionRTL(context) ? 'واتس اب' : 'WhatsApp',
                        description: locale.isDirectionRTL(context)
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
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                      border: Border.all(color: Color(0xFFAFAFAF), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.isDirectionRTL(context) ? "الشكاوي" : "Complaints",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
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
                          child: Image.asset(
                            'assets/icons/complaint.png',
                            fit: BoxFit.contain,
                            color: typographyMainColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: Text(
                    locale.isDirectionRTL(context) ? "مواقع التواصل الإجتماعي" : "social media sites",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 18.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => insta(),
                        icon: Image.asset('assets/icons/insta.png', width: 46.w, height: 46.h),
                      ),
                      IconButton(
                        onPressed: () => facebook(),
                        icon: Image.asset('assets/icons/facebook.png', width: 46.w, height: 46.h),
                      ),
                      IconButton(
                        onPressed: () => snapchat(),
                        icon: Image.asset('assets/icons/Snapchat.png', width: 46.w, height: 46.h),
                      ),
                      IconButton(
                        onPressed: () => xtwitter(),
                        icon: Image.asset('assets/icons/x.png', width: 46.w, height: 46.h),
                      ),
                      IconButton(
                        onPressed: () => tiktok(),
                        icon: Image.asset('assets/icons/tiktok.png', width: 46.w, height: 46.h),
                      ),
                      IconButton(
                        onPressed: () => linkedin(),
                        icon: Image.asset('assets/icons/linkedin.png', width: 46.w, height: 46.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Center(child: Text("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    locale.isDirectionRTL(context) ? "لزيارة موقعنا الإلكترونى" : "To visit our website",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 18.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: IconButton(
                    onPressed: () => web(),
                    icon: Image.asset('assets/icons/web_icon.png', width: 50.w, height: 50.h),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

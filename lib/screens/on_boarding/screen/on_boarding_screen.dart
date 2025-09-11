import 'package:abu_diyab_workshop/screens/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "خدمات سيارتك",
      "title2": "بضغطة زر!",
      "description":
      "دور على كل خدمات سيارتك، من صيانة وغسيل لقطع غيار، بسهولة تامة وبجودة مضمونة.",
      "image": "assets/images/onboarding1.png",
    },
    {
      "title": "خبراء الصيانة",
      "title2": "بين يديك!",
      "description":
      "اعتمد على أمهر المتخصصين لسيارتك. خدمات احترافية وجودة مضمونة، وين ما كنت ووقت ما تحتاج.",
      "image": "assets/images/onboarding2.png",
    },
    {
      "title": "سيارتك في أمان",
      "title2": "وراحة تامة!",
      "description":
      "لا تشيل همّ الصيانة بعد اليوم! كل اللي تحتاجه لسيارتك، من الألف للياء، صار بيدك. استمتع بقيادة بلا قلق",
      "image": "assets/images/onboarding3.png",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              reverse: false,
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) => OnboardingContent(
                title: onboardingData[index]["title"]!,
                title2: onboardingData[index]["title2"]!,
                description: onboardingData[index]["description"]!,
                image: onboardingData[index]["image"]!,
              ),
            ),
          ),

          // مؤشرات الصفحات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
                  (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: currentPage == index ? 20 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color:
                  currentPage == index ? Color(0xFFBA1B1B) : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // أزرار التنقل
          currentPage == onboardingData.length - 1
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBA1B1B),
                  minimumSize: Size(270, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "ابدأ الآن",
                  style: GoogleFonts.almarai(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
              : Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: Color(0xFFBA1B1B),
                elevation: 0,
              ),
              child: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward
                    : Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title;
  final String title2;
  final String description;
  final String image;

  const OnboardingContent({
    Key? key,
    required this.title,
    required this.title2,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // صورة
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          SizedBox(height: 40),

          // العنوان
          RichText(
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/images/bg_tag.png"),
                      Text(
                        title2,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 25,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

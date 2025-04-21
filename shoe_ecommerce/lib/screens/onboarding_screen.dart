import 'package:shoe_ecommerce/export.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Start Journey With Nike",
      "subtitle": "Smart, Gorgeous & Fashionable Collection",
      "image": "assets/images/1.png",
    },
    {
      "title": "Follow Latest Style Shoes",
      "subtitle": "There Are Many Beautiful And Attractive Plants To Your Room",
      "image": "assets/images/2.png",
    },
    {
      "title": "Summer Shoes Nike 2022",
      "subtitle": "Amet Minim Lit Nodeseru Saku Nandu sit Alique Dolor",
      "image": "assets/images/3.png",
    }
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("assets/images/onboarding_background.png"),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    return OnboardingContent(
                      title: onboardingData[index]["title"]!,
                      subtitle: onboardingData[index]["subtitle"]!,
                      imagePath: onboardingData[index]["image"]!,
                    );
                  },
                ),
              ),
              SizedBox(height: 40.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        onboardingData.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          width: _currentPage == index ? 30.w : 7.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    CustomButton(
                      text: _currentPage == onboardingData.length - 1
                          ? "Get Started"
                          : "Next",
                      onPressed: () {
                        if (_currentPage < onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                      
                         context.go(RouteNames.signIn);
                        }
                      },
                    ),
 
                  ],
                ),
              ),
                SizedBox(height: 20.h),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title, subtitle, imagePath;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Stack(children: [Image.asset("assets/images/NIKE.png", height: 400.h),
            Image.asset(imagePath, height: 400.h)]), 
          const Spacer(),
          Text(
            title,
           
            style: TextStyle(fontFamily: "AirbnbCereal",fontSize: 40.sp, fontWeight: FontWeight.w500,color: AppTheme.textcolor),
          ),
          SizedBox(height: 10.h),
          Text(
            subtitle,

            style: TextStyle(fontFamily: "AirbnbCereal",fontSize: 20.sp,fontWeight: FontWeight.w400, color: const Color(0xFF707B81)),
          ),
        ],
      ),
    );
  }
}

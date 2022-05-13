import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/onboarding_style.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int? currentPage = 0;
  @override
  Widget build(BuildContext context) {
    var controller = PageController();
    controller.addListener(
      () {
        setState(() {
          currentPage = controller.page?.round();
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          MaterialButton(
            onPressed: () {
              navigatePushANDRemoveRout(
                context: context,
                navigateTo: LoginScreen(),
              );
              CachHelper.setData(key: 'isPassed', value: true);
            },
            child: Text(
              'Skip',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.black,
                  ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      bottomSheet: Container(
        height: 60,
        color: const Color(0xff5ADAAC),
        child: currentPage == 2
            ? Center(
                child: MaterialButton(
                  onPressed: () {
                    navigatePushANDRemoveRout(
                      context: context,
                      navigateTo: LoginScreen(),
                    );
                    CachHelper.setData(key: 'isPassed', value: true);
                  },
                  child: Text(
                    'Let\'s get started',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              )
            : Row(
                children: [
                  const Spacer(flex: 2),
                  SmoothPageIndicator(
                    controller: controller, // PageController
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Color.fromARGB(255, 77, 76, 76),
                      dotColor: Colors.white,
                      expansionFactor: 1.1,
                      dotHeight: 12,
                      dotWidth: 12,
                    ), // your preferred effect
                    onDotClicked: (index) {
                      controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    },
                  ),
                  const Spacer(),
                  MaterialButton(
                    onPressed: () {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    },
                    child: Text(
                      'Next',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                ],
              ),
      ),
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: controller,
        children: [
          onBoardingStyle(
              'assets/images/onboard3.png',
              'Welcome to club cast app,the best experience with live streaming apps',
              context),
          onBoardingStyle(
              'assets/images/Podcast.png',
              'Listen to your favourite podcast everywhere and anytime',
              context),
          onBoardingStyle('assets/images/onboard1.jpg',
              'Join and create public and private recordable rooms', context),
        ],
      ),
    );
  }
}

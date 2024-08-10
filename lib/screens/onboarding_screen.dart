import 'package:flutter/material.dart';

import '../screens/onboarding_page1.dart';
import '../screens/onboarding_page2.dart';
import '../screens/onboarding_page3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageViewController = PageController();
  int currentPageViewIndex = 0;
  bool? showOnboardingScreen;
  int ctr = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageViewController,
          onPageChanged: (newIndex) => {
            setState(() {
              currentPageViewIndex = newIndex;
            }),
          },
          children: [
            // Page 1
            OnboardingPage1(pageViewController: pageViewController),
            // Page 2
            OnboardingPage2(pageViewController: pageViewController),
            // Page 3
            OnboardingPage3(pageViewController: pageViewController),
          ],
        ),
      ),
    );
  }
}

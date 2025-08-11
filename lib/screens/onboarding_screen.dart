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
            OnboardingPage1(pageViewController: pageViewController),
            OnboardingPage2(pageViewController: pageViewController),
            OnboardingPage3(pageViewController: pageViewController),
          ],
        ),
      ),
    );
  }
}

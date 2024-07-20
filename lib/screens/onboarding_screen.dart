import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';

import '../widgets/custom_card.dart';
import '../widgets/custom_divider.dart';

import 'package:flutter_svg/flutter_svg.dart';

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
  void initState() {
    super.initState();
    initializeWithSharedPrefs();
  }

  Future<void> initializeWithSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboardingScreen', false);
    showOnboardingScreen = prefs.getBool('showOnboardingScreen');
    debugPrint('onboarding_screen.dart showOnboardingScreen: $showOnboardingScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageViewController,
              onPageChanged: (newIndex) => {
                setState(() {
                  currentPageViewIndex = newIndex;
                }),
              },
              children: [
                // Page 1
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Provider.of<ThemeProvider>(context).globalDarkImageBackgroundColor,
                              ),
                              height: 300,
                              width: 300,
                              padding: const EdgeInsets.all(30),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/storyset_welcome_amico.svg',
                                  height: 250,
                                  width: 250,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text('Welcome to JustPlay!', style: Theme.of(context).textTheme.displayLarge),
                          const CustomDivider(),
                          const SizedBox(height: 20),
                          Text(
                            'A beautiful and straighforward app for quickly playing all your local audio files.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Page 2
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Provider.of<ThemeProvider>(context).globalDarkImageBackgroundColor,
                              ),
                              height: 300,
                              width: 300,
                              padding: const EdgeInsets.all(30),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/storyset_upload_amico.svg',
                                  height: 250,
                                  width: 250,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text('Load your local music library', style: Theme.of(context).textTheme.displayLarge),
                          const CustomDivider(),
                          const SizedBox(height: 20),
                          Text(
                            'Just browse for your device folder, to load all files within.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Page 3
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Provider.of<ThemeProvider>(context).globalDarkImageBackgroundColor,
                              ),
                              height: 300,
                              width: 300,
                              padding: const EdgeInsets.all(30),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/storyset_music_amico.svg',
                                  height: 250,
                                  width: 250,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text('All Set!', style: Theme.of(context).textTheme.displayLarge),
                          const CustomDivider(),
                          const SizedBox(height: 20),
                          Text(
                            'Ready to go! Select a file and play!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: (currentPageViewIndex <= 1)
                ? ElevatedButton(
                    onPressed: () => {
                      pageViewController.nextPage(
                        duration: const Duration(
                          milliseconds: 250,
                        ),
                        curve: Curves.linear,
                      ),
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => {
                      pageViewController.nextPage(
                        duration: const Duration(
                          milliseconds: 250,
                        ),
                        curve: Curves.linear,
                      ),
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Start Playing',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

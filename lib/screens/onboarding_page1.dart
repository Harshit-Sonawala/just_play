import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

import '../widgets/custom_card.dart';
import '../widgets/custom_divider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage1 extends StatefulWidget {
  final PageController pageViewController;

  const OnboardingPage1({
    required this.pageViewController,
    super.key,
  });

  @override
  State<OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<OnboardingPage1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              'A beautiful app for quickly playing all your local audio files.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Please provide the file and audio playback permissions whenever prompted.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: widget.pageViewController,
                count: 3,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  dotColor: Provider.of<ThemeProvider>(context, listen: false).globalDarkDimForegroundColor,
                  activeDotColor: Provider.of<ThemeProvider>(context, listen: false).globalAccentColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                widget.pageViewController.nextPage(
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  curve: Curves.linear,
                ),
              },
              style: Provider.of<ThemeProvider>(context, listen: false).altButtonStyle,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Start',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 24,
                      color: Provider.of<ThemeProvider>(context, listen: false).globalDarkForegroundColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

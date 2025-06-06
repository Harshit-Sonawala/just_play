import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/custom_divider.dart';
import '../widgets/custom_elevated_button.dart';

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
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.tertiary,
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
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Text(
            'Please provide the file and audio playback permissions whenever prompted.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          Center(
            child: SmoothPageIndicator(
              controller: widget.pageViewController,
              count: 3,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                dotColor: Theme.of(context).colorScheme.onSurfaceVariant,
                activeDotColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: () => {
              widget.pageViewController.nextPage(
                duration: const Duration(
                  milliseconds: 250,
                ),
                curve: Curves.linear,
              ),
            },
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            title: 'Start',
            titleStyle: Theme.of(context).textTheme.bodyLarge,
            trailingIcon: Icons.arrow_forward_rounded,
          ),
        ],
      ),
    );
  }
}

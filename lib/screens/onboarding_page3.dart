import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import '../providers/audioplayer_provider.dart';
import '../providers/theme_provider.dart';

import '../widgets/custom_card.dart';
import '../widgets/custom_divider.dart';
import '../screens/playback_screen.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage3 extends StatefulWidget {
  final PageController pageViewController;

  const OnboardingPage3({
    required this.pageViewController,
    super.key,
  });

  @override
  State<OnboardingPage3> createState() => _OnboardingPage3State();
}

class _OnboardingPage3State extends State<OnboardingPage3> {
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PlaybackScreen(),
                  ),
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
                      'Start Playing',
                      style: Theme.of(context).textTheme.titleMedium,
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

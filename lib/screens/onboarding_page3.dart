import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/custom_card.dart';
import '../widgets/custom_divider.dart';
import '../screens/playback_screen.dart';
import '../providers/audioplayer_provider.dart';
import '../providers/theme_provider.dart';

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
  Future<void>? buildLibraryFuture;

  @override
  void initState() {
    super.initState();
    buildLibraryFuture = Provider.of<AudioPlayerProvider>(context, listen: false).generateTrackList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: CustomCard(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<void>(
          future: buildLibraryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Building Media Library...', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Column(
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
              );
            } else {
              // unexpected case
              if (snapshot.hasError) {
                // unexpected case and encounterred error
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                // unexpected case but no error encountered
                return Center(
                  child: Text('$snapshot'),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

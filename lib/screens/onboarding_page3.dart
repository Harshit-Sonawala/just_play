import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/custom_divider.dart';
import '../widgets/custom_elevated_button.dart';
import 'wrapper_screen.dart';
import '../models/track.dart';
import '../providers/database_provider.dart';
import '../providers/audio_player_provider.dart';

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
    buildLibraryFuture = buildLibrary();
  }

  Future<void> buildLibrary() async {
    if (mounted) {
      final databaseProviderListenFalse = Provider.of<DatabaseProvider>(context, listen: false);
      final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);
      // if (!databaseProviderListenFalse.isTrackDatabaseInitialized) {
      //   await databaseProviderListenFalse.initializeTrackDatabase();
      // }

      List<Track> trackList = await audioPlayerProviderListenFalse.generateTrackList();
      await databaseProviderListenFalse.deleteAllTracks();
      await databaseProviderListenFalse.insertTrackList(trackList);
      audioPlayerProviderListenFalse.prefs?.setBool('showOnboardingScreen', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: FutureBuilder<void>(
        future: buildLibraryFuture,
        builder: (context, snapshot) {
          return Column(
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
                      'assets/images/storyset_music_amico.svg',
                      height: 250,
                      width: 250,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (snapshot.connectionState == ConnectionState.waiting)
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Building Library...',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const CustomDivider(),
                      const SizedBox(height: 20),
                      Text(
                        'Scanning all files and extracting metadata. Will only need to do this once.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: CircularProgressIndicator(),
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
                      Center(
                        child: Text(
                          'Please wait while library is built',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )
              else if (snapshot.connectionState == ConnectionState.done)
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Set!',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const CustomDivider(),
                      const SizedBox(height: 20),
                      Text(
                        'Ready to go! Select a file and play!',
                        style: Theme.of(context).textTheme.bodyMedium,
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const WrapperScreen(),
                            ),
                          ),
                        },
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                        title: 'Start Playing',
                        titleStyle: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )
              else if (snapshot.hasError)
                // unexpected case and encounterred error
                Text(
                  'Error: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else
                // unexpected case but no error encountered
                Text(
                  '$snapshot',
                  style: Theme.of(context).textTheme.bodySmall,
                )
            ],
          );
        },
      ),
    );
  }
}

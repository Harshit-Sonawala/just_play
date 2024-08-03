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

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageViewController = PageController();
  int currentPageViewIndex = 0;
  bool? showOnboardingScreen;
  TextEditingController musicDirectoryTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeWithSharedPrefs();
  }

  @override
  void dispose() {
    musicDirectoryTextFieldController.dispose();
    super.dispose();
  }

  Future<void> initializeWithSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboardingScreen', false);
    showOnboardingScreen = prefs.getBool('showOnboardingScreen');
    debugPrint('onboarding_screen.dart showOnboardingScreen: $showOnboardingScreen');
  }

  void showRestartSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Please provide a music directory.',
        ),
        action: SnackBarAction(
          label: 'BROWSE',
          onPressed: () => {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AudioPlayerProvider>(context).currentDirectory != null &&
        Provider.of<AudioPlayerProvider>(context).currentDirectory != '') {
      musicDirectoryTextFieldController.text = Provider.of<AudioPlayerProvider>(context).currentDirectory!;
    } else {
      musicDirectoryTextFieldController.text = '';
    }

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
            Padding(
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
                        controller: pageViewController,
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
                        pageViewController.nextPage(
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
            ),
            // Page 2
            Padding(
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
                      'Just browse for your device folder to load all your music files.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Music Library:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: musicDirectoryTextFieldController,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        String? selectedMusicDirectoryPath = await FilePicker.platform.getDirectoryPath();
                        if (selectedMusicDirectoryPath != null && selectedMusicDirectoryPath != '') {
                          setState(() {
                            Provider.of<AudioPlayerProvider>(context, listen: false)
                                .updateCurrentDirectory(selectedMusicDirectoryPath);
                            Provider.of<AudioPlayerProvider>(context, listen: false).generateTrackList();
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Browse',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.drive_file_move_rounded,
                              size: 24,
                              color: Provider.of<ThemeProvider>(context, listen: false).globalAccentColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: SmoothPageIndicator(
                        controller: pageViewController,
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
                    if (Provider.of<AudioPlayerProvider>(context).currentDirectory != null &&
                        Provider.of<AudioPlayerProvider>(context).currentDirectory != '')
                      ElevatedButton(
                        onPressed: () => {
                          pageViewController.nextPage(
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
                                'Continue',
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
            ),
            // Page 3
            Padding(
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
                        controller: pageViewController,
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
            ),
          ],
        ),
      ),
    );
  }
}

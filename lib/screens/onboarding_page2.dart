import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/custom_divider.dart';
import '../widgets/custom_elevated_button.dart';
import '../providers/audio_player_provider.dart';

class OnboardingPage2 extends StatefulWidget {
  final PageController pageViewController;

  const OnboardingPage2({
    required this.pageViewController,
    super.key,
  });

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  TextEditingController musicDirectoryTextFieldController = TextEditingController();

  @override
  void dispose() {
    musicDirectoryTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AudioPlayerProvider>(context).libraryDirectory != null &&
        Provider.of<AudioPlayerProvider>(context).libraryDirectory != '') {
      musicDirectoryTextFieldController.text = Provider.of<AudioPlayerProvider>(context).libraryDirectory!;
    } else {
      musicDirectoryTextFieldController.text = '';
    }

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
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Text(
            'Music Library:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: false,
                  readOnly: true,
                  controller: musicDirectoryTextFieldController,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            onPressed: () async {
              String? selectedMusicDirectoryPath = await FilePicker.platform.getDirectoryPath();
              if (selectedMusicDirectoryPath != null && selectedMusicDirectoryPath != '') {
                setState(() {
                  Provider.of<AudioPlayerProvider>(context, listen: false)
                      .updateLibraryDirectory(selectedMusicDirectoryPath);
                });
              }
            },
            backgroundColor: Theme.of(context).colorScheme.surfaceBright,
            title: 'Browse',
            titleStyle: Theme.of(context).textTheme.displayMedium,
            icon: Icons.drive_file_move_rounded,
            iconColor: Theme.of(context).colorScheme.primary,
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
          if (Provider.of<AudioPlayerProvider>(context).libraryDirectory != null &&
              Provider.of<AudioPlayerProvider>(context).libraryDirectory != '')
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
              title: 'Continue',
              trailingIcon: Icons.arrow_forward_rounded,
            )
          else
            Center(
              child: Text(
                'Select a folder to continue',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

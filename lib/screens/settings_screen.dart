import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/database_provider.dart';
import '../providers/audio_player_provider.dart';
import '../widgets/custom_divider.dart';
import '../models/track.dart';

import 'package:file_picker/file_picker.dart';
import 'package:restart_app/restart_app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController musicDirectoryTextFieldController = TextEditingController();

  @override
  void dispose() {
    musicDirectoryTextFieldController.dispose();
    super.dispose();
  }

  void showRestartSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Restart app to apply changes.',
        ),
        action: SnackBarAction(
          label: 'RESTART',
          onPressed: () => {Restart.restartApp()},
        ),
      ),
    );
  }

  Future<void> buildLibrary() async {
    List<Track> trackList = await Provider.of<AudioPlayerProvider>(context, listen: false).generateTrackList();
    await Provider.of<DatabaseProvider>(context, listen: false).deleteAllTracks();
    await Provider.of<DatabaseProvider>(context, listen: false).insertTrackList(trackList);
  }

  @override
  Widget build(BuildContext context) {
    musicDirectoryTextFieldController.text = Provider.of<AudioPlayerProvider>(context).libraryDirectory!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const CustomDivider(),
                    const SizedBox(height: 10),
                    Text(
                      'Device Music Directory',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Enter or browse for the music folder on device:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: musicDirectoryTextFieldController,
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.drive_file_move_rounded, size: 28),
                                onPressed: () async {
                                  String? selectedMusicDirectoryPath = await FilePicker.platform.getDirectoryPath();
                                  if (selectedMusicDirectoryPath != null && selectedMusicDirectoryPath != '') {
                                    setState(() {
                                      // musicDirectoryTextFieldController.text = selectedMusicDirectoryPath;
                                      Provider.of<AudioPlayerProvider>(context, listen: false)
                                          .updateLibraryDirectory(selectedMusicDirectoryPath);
                                      buildLibrary();
                                      showRestartSnackbar();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Visual',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const CustomDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enable Dark Theme',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: true,
                          onChanged: (newdarkThemeSwitchValue) => {
                            debugPrint('$newdarkThemeSwitchValue'),
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Accent Color:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/audioplayer_provider.dart';

import '../widgets/custom_divider.dart';

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

  @override
  Widget build(BuildContext context) {
    musicDirectoryTextFieldController.text = Provider.of<AudioPlayerProvider>(context).currentDirectory!;
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
                    icon: const Icon(Icons.arrow_back),
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
                padding: const EdgeInsets.all(10.0),
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
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.create_new_folder_rounded),
                                onPressed: () async {
                                  String? selectedMusicDirectoryPath = await FilePicker.platform.getDirectoryPath();
                                  if (selectedMusicDirectoryPath != null) {
                                    setState(() {
                                      // musicDirectoryTextFieldController.text = selectedMusicDirectoryPath;
                                      Provider.of<AudioPlayerProvider>(context, listen: false)
                                          .updateCurrentDirectory(selectedMusicDirectoryPath);
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

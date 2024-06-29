import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/audioplayer_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final pathTextFieldController = TextEditingController(text: '/storage/emulated/0/Music/03 Majula.mp3');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Path:', style: Theme.of(context).textTheme.displayMedium),
                  ),
                  Expanded(
                    child: TextField(
                      controller: pathTextFieldController,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      Provider.of<AudioPlayerProvider>(context, listen: false)
                          .setAudioPlayerFile(pathTextFieldController.text);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

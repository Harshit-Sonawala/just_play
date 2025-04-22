import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';

import '../widgets/custom_card.dart';

class ShufflerScreen extends StatefulWidget {
  const ShufflerScreen({super.key});

  @override
  State<ShufflerScreen> createState() => _ShufflerScreenState();
}

class _ShufflerScreenState extends State<ShufflerScreen> {
  final List<String> items = [
    'Jason Ross - Stay',
    'Seven Lions - Tokyo (feat. Xira)',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.shuffle_rounded,
                ),
                const SizedBox(width: 12),
                Text(
                  'Shuffler',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ),
          Text(
            'Shuffle play from a wider more random selection of tracks:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CustomCard(
                  child: Center(
                    child: Text(
                      items[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

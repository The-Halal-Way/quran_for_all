import 'package:flutter/material.dart';

class SettingsOfflineCard extends StatelessWidget {
  const SettingsOfflineCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary.withValues(alpha: 0.25),
            colorScheme.tertiary.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Card(
        color: Colors.transparent,
        child: const ListTile(
          leading: Icon(Icons.offline_bolt_rounded),
          title: Text('Offline mode is enabled'),
          subtitle: Text(
            'Quran text and translations are stored locally after setup. Audio is cached after first play.',
          ),
        ),
      ),
    );
  }
}

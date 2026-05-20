import 'package:flutter/material.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer_view.dart';
import 'package:quran_for_all/presentation/views/compass/compass_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/daily_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/powerful_duah_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('This is the dashboard view.'),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to CompassView
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CompassView()),
                );
              },
              child: Text('Go to Compass'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to DailyDuahView
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DailyDuahView()),
                );
              },
              child: Text('Go to Daily Du\'ā\''),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to PowerfulDuahView
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PowerfulDuahView()),
                );
              },
              child: Text('Go to Powerful Du\'ā\''),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrayerView()),
                );
              },
              child: Text('Go to Prayer Times'),
            ),
          ],
        ),
      ),
    );
  }
}

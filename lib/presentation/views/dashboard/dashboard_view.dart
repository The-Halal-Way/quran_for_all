import 'package:flutter/material.dart';
import 'package:quran_for_all/presentation/views/compass/compass_view.dart';

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
          ],
        ),
      ),
    );
  }
}

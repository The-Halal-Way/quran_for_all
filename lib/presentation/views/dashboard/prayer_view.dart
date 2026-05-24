import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';

class PrayerView extends StatefulWidget {
  const PrayerView({super.key});

  @override
  State<PrayerView> createState() => _PrayerViewState();
}

class _PrayerViewState extends State<PrayerView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<DashboardPrayerTimesViewModel>();
      if (!vm.hasData && !vm.isLoading) {
        vm.loadPrayerTimes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardPrayerTimesViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: Center(
        child: vm.isLoading
            ? const CircularProgressIndicator()
            : vm.error.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(vm.error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.loadPrayerTimes(forceRefresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemCount: vm.prayerTimes!.entries.length,
                separatorBuilder: (_, index) => const Divider(),
                itemBuilder: (context, index) {
                  final entry = vm.prayerTimes!.entries.elementAt(index);
                  return ListTile(
                    leading: Icon(_getIcon(entry.key)),
                    title: Text(entry.key),
                    trailing: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
      ),
    );
  }

  IconData _getIcon(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Sunrise':
        return Icons.wb_sunny;
      case 'Dhuhr':
        return Icons.wb_sunny_outlined;
      case 'Asr':
        return Icons.umbrella;
      case 'Maghrib':
        return Icons.nights_stay;
      case 'Isha':
        return Icons.bedtime;
      default:
        return Icons.access_time;
    }
  }
}

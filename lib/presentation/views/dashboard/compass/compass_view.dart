import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/viewmodels/compass/compass_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_ticker_host.dart';

class CompassView extends StatelessWidget {
  const CompassView({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => CompassViewModel()..initialize(),
    child: const CompassTickerHost(),
  );
}

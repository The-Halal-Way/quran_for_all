import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/presentation/viewmodels/compass/compass_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_premium_page_background.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_guidance_card.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_hero_card.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_info_row.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_loading_state.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_top_bar.dart';

class CompassContent extends StatelessWidget {
  const CompassContent({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CompassViewModel>();
    final l10n = context.l10n;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final error = model.initErrorType != CompassInitErrorType.none;

    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: Column(
            children: [
              CompassTopBar(
                isDark: dark,
                directionLabel: model.isInitializing
                    ? l10n.compassInitializing
                    : error
                    ? _errorTitle(context, model.initErrorType)
                    : model.isListening
                    ? l10n.compassNativeActive
                    : l10n.compassNorthUpMode,
              ),
              Expanded(
                child: model.isInitializing
                    ? CompassLoadingState(
                        title: l10n.compassInitializing,
                        isLoading: true,
                      )
                    : error
                    ? CompassLoadingState(
                        title: _errorTitle(context, model.initErrorType),
                        message: _errorBody(context, model.initErrorType),
                        actionLabel: l10n.compassRetry,
                        onRetry: model.retry,
                      )
                    : RefreshIndicator(
                        onRefresh: model.retry,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                          children: [
                            CompassHeroCard(
                              qiblaDegrees: model.qiblaDegrees,
                              heading: model.smoothHeading,
                              isLive: model.isListening,
                              facingMecca: model.facingMecca,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            CompassGuidanceCard(
                              isLive: model.isListening,
                              facingMecca: model.facingMecca,
                              qiblaOffset: model.qiblaOffset,
                              qiblaDegrees: model.qiblaDegrees,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            CompassInfoRow(
                              heading: model.smoothHeading,
                              qiblaDegrees: model.qiblaDegrees,
                              isLive: model.isListening,
                              isApiBearing: model.isApiBearing,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _errorTitle(BuildContext context, CompassInitErrorType type) {
    final l10n = context.l10n;
    return switch (type) {
      CompassInitErrorType.locationDenied => l10n.compassLocationDeniedTitle,
      CompassInitErrorType.locationBlocked => l10n.compassLocationBlockedTitle,
      CompassInitErrorType.locationDisabled =>
        l10n.compassLocationDisabledTitle,
      _ => l10n.compassGenericErrorTitle,
    };
  }

  String _errorBody(BuildContext context, CompassInitErrorType type) {
    final l10n = context.l10n;
    return switch (type) {
      CompassInitErrorType.locationDenied => l10n.compassLocationDeniedBody,
      CompassInitErrorType.locationBlocked => l10n.compassLocationBlockedBody,
      CompassInitErrorType.locationDisabled => l10n.compassLocationDisabledBody,
      _ => l10n.compassGenericErrorBody,
    };
  }
}

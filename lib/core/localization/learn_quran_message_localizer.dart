import 'package:flutter/widgets.dart';

import 'l10n_extensions.dart';

class LearnQuranMessageKeys {
  const LearnQuranMessageKeys._();

  static const String errorLoadProgress = 'learn_error_load_progress';
  static const String errorSaveProgress = 'learn_error_save_progress';
  static const String audioMissingSample = 'learn_audio_missing_sample';
  static const String audioSampleNotFound = 'learn_audio_sample_not_found';
  static const String audioPlayFailed = 'learn_audio_play_failed';
}

String localizeLearnQuranMessage(BuildContext context, String key) {
  switch (key) {
    case LearnQuranMessageKeys.errorLoadProgress:
      return context.l10n.learnVmErrorLoadProgress;
    case LearnQuranMessageKeys.errorSaveProgress:
      return context.l10n.learnVmErrorSaveProgress;
    case LearnQuranMessageKeys.audioMissingSample:
      return context.l10n.learnVmAudioMissingSample;
    case LearnQuranMessageKeys.audioSampleNotFound:
      return context.l10n.learnVmAudioSampleNotFound;
    case LearnQuranMessageKeys.audioPlayFailed:
      return context.l10n.learnVmAudioPlayFailed;
    default:
      return key;
  }
}

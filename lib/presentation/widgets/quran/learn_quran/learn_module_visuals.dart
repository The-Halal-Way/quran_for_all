import 'package:flutter/material.dart';

class LearnModuleVisuals {
  const LearnModuleVisuals({
    required this.icon,
    required this.startColor,
    required this.endColor,
  });

  final IconData icon;
  final Color startColor;
  final Color endColor;

  static LearnModuleVisuals forModule(String moduleId) {
    switch (moduleId) {
      case 'arabic_letters':
        return const LearnModuleVisuals(
          icon: Icons.language_rounded,
          startColor: Color(0xFF0C8A6D),
          endColor: Color(0xFF2FAF8A),
        );
      case 'pronunciation_basics':
        return const LearnModuleVisuals(
          icon: Icons.record_voice_over_rounded,
          startColor: Color(0xFF14727A),
          endColor: Color(0xFF2E9EA8),
        );
      case 'makharij':
        return const LearnModuleVisuals(
          icon: Icons.hearing_rounded,
          startColor: Color(0xFF8A5A1D),
          endColor: Color(0xFFCF8E39),
        );
      case 'tajweed_rules':
        return const LearnModuleVisuals(
          icon: Icons.rule_rounded,
          startColor: Color(0xFF95452D),
          endColor: Color(0xFFCD724F),
        );
      case 'word_by_word':
        return const LearnModuleVisuals(
          icon: Icons.translate_rounded,
          startColor: Color(0xFF2D5F9A),
          endColor: Color(0xFF4C86CA),
        );
      case 'short_surah_practice':
        return const LearnModuleVisuals(
          icon: Icons.auto_stories_rounded,
          startColor: Color(0xFF7E4B96),
          endColor: Color(0xFFA36BC0),
        );
      case 'audio_assisted':
        return const LearnModuleVisuals(
          icon: Icons.headphones_rounded,
          startColor: Color(0xFF1B6A4A),
          endColor: Color(0xFF42A676),
        );
      default:
        return const LearnModuleVisuals(
          icon: Icons.school_rounded,
          startColor: Color(0xFF0B6B5A),
          endColor: Color(0xFFBC5B40),
        );
    }
  }
}

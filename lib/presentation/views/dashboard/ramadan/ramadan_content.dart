import 'ramadan_models.dart';
import 'data/ramadan_essentials_topics.dart';
import 'data/ramadan_daily_life_topics.dart';
import 'data/ramadan_worship_topics.dart';
import 'data/ramadan_women_topics.dart';
import 'data/ramadan_last_ten_topics.dart';
import 'data/ramadan_giving_topics.dart';
import 'data/ramadan_questions_topics.dart';

export 'ramadan_models.dart';

/// Guide topics in the order they appear in the category picker.
const ramadanTopics = <RamadanTopic>[
  ...ramadanEssentialsTopics,
  ...ramadanDailyLifeTopics,
  ...ramadanWorshipTopics,
  ...ramadanWomenTopics,
  ...ramadanLastTenTopics,
  ...ramadanGivingTopics,
  ...ramadanQuestionsTopics,
];

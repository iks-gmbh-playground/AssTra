import 'package:asstra/common/do.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';

import '../common/asstra.constants.dart';

class EndlessQuizProperties extends PersistentProperties {

  static const String lastTotalScore = 'lastTotalScore';
  static const String lastSeriesScore = 'lastSeriesScore';
  static const String lastQuestTimestamp = 'lastQuestTimestamp';

  EndlessQuizProperties.fromString(String instanceAsString) {
    addFromStringToMap(instanceAsString, propertySeparator, properties);
  }

  int getLastTotalScore() {
    return getIntValue(lastTotalScore, 0);
  }

  int getLastSeriesScore() {
    return getIntValue(lastSeriesScore, 0);
  }

  int getLastQuestTimestamp() {
    return getIntValue(lastQuestTimestamp, DateTime.now().millisecond);
  }

  void setLastTotalScore(int value) {
    addProperty(lastTotalScore, value.toString());
  }

  void setLastSeriesScore(int value) {
    addProperty(lastSeriesScore, value.toString());
  }

  void setLastQuestTimestamp(int value) {
    addProperty(lastQuestTimestamp, value.toString());
  }

}

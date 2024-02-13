import '../common/asstra.constants.dart';
import '../common/do.dart';
import '../common/utils/asstra.util.string.dart';

class AssTraConfig extends PersistentProperties {
  static const String millisToWaitForNewQuest = 'millisToWaitForNewQuest';
  static const String numberOfCorrectAnswersToJudgeLearned = 'numberOfCorrectAnswersToJudgeLearned';

  AssTraConfig.fromString(String instanceAsString) {
    addFromStringToMap(instanceAsString, propertySeparator, properties);
  }

  int getNumberOfEntriesInHighscoreList() {
    return getIntValue('numberOfEntriesInHighscoreList', 10);
  }

  int getNumberOfAnswersInQuest() {
    return getIntValue('numberOfAnswersInQuest', 4);
  }

  int getNumberOfSubgroupsForMuchKnowledge() {
    return getIntValue('numberOfSubgroupsForMuchKnowledge', 32);
  }

  int getNumberOfSubgroupsForSomeKnowledge() {
    return getIntValue('numberOfSubgroupsForSomeKnowledge', 16);
  }

  int getNumberOfSubgroupsForLittleKnowledge() {
    return getIntValue('numberOfSubgroupsForLittleKnowledge', 8);
  }

  int getMinListSizeToShowSearchField() {
    return getIntValue('minListSizeToShowSearchField', 5);
  }

  int getNumberOfCorrectAnswersToJudgeLearned() {
    return getIntValue(numberOfCorrectAnswersToJudgeLearned, 3);
  }

  int getMillisToWaitForNewQuest() {
    return getIntValue(millisToWaitForNewQuest, 1000);
  }

  void setMillisToWaitForNewQuest(int value) {
    addProperty(millisToWaitForNewQuest, value.toString());
  }

  void setNumberOfCorrectAnswersToJudgeLearned(int value) {
    addProperty(numberOfCorrectAnswersToJudgeLearned, value.toString());
  }
}

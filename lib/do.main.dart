
import 'package:asstra/common/utils/asstra.util.dialog.dart';
import 'package:hive/hive.dart';

import '2.manage.knowledge.base/do.manage.knowledge.base.dart';
import '3.endless.quiz/do.endlessquiz.dart';
import '4.view.hall.of.fame/do.halloffame.dart';
import '5.change.configuration/do.configuration.dart';
import 'common/asstra.constants.dart';
import 'common/do.dart';
import 'common/utils/asstra.util.string.dart';

class AssTraRuntimeData {
  bool firstAppStart;
  AssTraConfig appConfigData;
  AppLastValueSetting lastValueSetting;
  List<KnowledgeField> knowledgeFields;
  Map<String,List<HallOfFameEntry>> appHallOfFameData;
  EndlessQuizProperties endlessQuizData;
  AssociationsLearned associationsLearned;

  AssTraRuntimeData(this.firstAppStart,
                    this.appConfigData,
                    this.lastValueSetting,
                    this.knowledgeFields,
                    this.appHallOfFameData,
                    this.endlessQuizData,
                    this.associationsLearned);

  List<String> getKnowledgeAreas() {
    List<String> toReturn = List.empty(growable: true);
    knowledgeFields.map((field) => field.knowledgeArea)
                         .where((area) => ! toReturn.contains(area))
                         .forEach((area) => toReturn.add(area));
    return toReturn;
  }

  List<KnowledgeField> getAllKnowledgeFields() {
    return knowledgeFields;
  }

  List<String> getKnowledgeFieldNames(String knowledgeArea) {
    List<String> toReturn = List.empty(growable: true);
    knowledgeFields.where((field) => field.knowledgeArea == knowledgeArea)
                         .forEach((field) => toReturn.add(field.getName()));
    return toReturn;
  }

  KnowledgeField getKnowledgeField(String knowledgeFieldName) {
    return knowledgeFields.firstWhere((field) => field.getName() == knowledgeFieldName);
  }

  bool isKnowledgeFieldNew(KnowledgeField newKnowledgeField) {
    try {
      knowledgeFields.firstWhere((element) => element.getName() == newKnowledgeField.getName());
      return false;
    } catch (exception) {
      return true;
    }
  }

  deleteKnowledgeField(String knowledgeFieldName, context, bool withMessage) async {
    var box = await Hive.openBox(dbBoxNameKnowledge);
    box.delete(knowledgeFieldName);
    var knowledgeField = getKnowledgeField(knowledgeFieldName);
    knowledgeFields.remove(knowledgeField);
    appHallOfFameData.remove(knowledgeFieldName);
    if (getKnowledgeFieldNames(knowledgeField.knowledgeArea).isEmpty) {
      appHallOfFameData.remove(knowledgeField.knowledgeArea);
    }
    deleteAllAssociationsLearned(knowledgeFieldName);
    if (withMessage) AssTraDialogUtil.showInfoBox(context, "Note", "Knowledge field *$knowledgeFieldName* has been deleted.");
  }

  Future<void> saveConfig(AssTraConfig appConfigData) async {
    var box = await Hive.openBox(dbBoxNameProperties);
    box.delete(dbEntryConfig);
    box.put(dbEntryConfig, appConfigData.toString());
  }

  Future<void> saveLastValueSetting(AppLastValueSetting lastValueSetting) async {
    var box = await Hive.openBox(dbBoxNameProperties);
    box.delete(dbEntryLastValueSettings);
    box.put(dbEntryLastValueSettings, lastValueSetting.toString());
  }

  Future<void> saveKnowledgeField(KnowledgeField newKnowledgeField) async {
    bool createHighscoreListForArea = getKnowledgeFieldNames(newKnowledgeField.knowledgeArea).isEmpty;
    knowledgeFields.add(newKnowledgeField);
    var box = await Hive.openBox(dbBoxNameKnowledge);
    box.put(newKnowledgeField.getName(), newKnowledgeField);
    saveHallOfFameHighscoreList(newKnowledgeField.getName(), List<HallOfFameEntry>.empty(growable: true));
    if (createHighscoreListForArea) saveHallOfFameHighscoreList(newKnowledgeField.knowledgeArea, List<HallOfFameEntry>.empty(growable: true));
  }

  Future<void> saveHallOfFameHighscoreList(String newKnowledgeFieldName, List<HallOfFameEntry> highScorelist) async {
    appHallOfFameData.addEntries({newKnowledgeFieldName:highScorelist}.entries);
    var box = await Hive.openBox(dbBoxNameHallOfFame);
    box.put(newKnowledgeFieldName, highScorelist);
  }

  Future<void> saveEndlessQuizData(EndlessQuizProperties quizData) async {
    var box = await Hive.openBox(dbBoxNameProperties);
    box.delete(dbEntryEndlessQuiz);
    box.put(dbEntryEndlessQuiz, quizData.toString());
  }

  Future<void> saveAssociationsLearned(String knowledgeFieldName, bool backwards, String learnedAssociationKey) async {
    String key = knowledgeFieldName;
    if (backwards) {
      if ( ! associationsLearned.backwardsLearned.containsKey(key)) {
        List<String> value = List.empty(growable: true);
        associationsLearned.backwardsLearned.addEntries({key:value}.entries);
      }
      associationsLearned.backwardsLearned[key]?.add(learnedAssociationKey);
    } else {
      if ( ! associationsLearned.forwardsLearned.containsKey(key)) {
        List<String> value = List.empty(growable: true);
        associationsLearned.forwardsLearned.addEntries({key: value}.entries);
      }
      associationsLearned.forwardsLearned[key]?.add(learnedAssociationKey);
    }

    var box = await Hive.openBox(dbBoxNameAssociationLearned);
    box.delete(dbBoxNameAssociationLearned);
    box.put(dbBoxNameAssociationLearned, associationsLearned.toString());
  }


  Future<void> deleteAllAssociationsLearned(String knowledgeFieldName) async {
    associationsLearned.forwardsLearned.remove(knowledgeFieldName);
    associationsLearned.backwardsLearned.remove(knowledgeFieldName);
    var box = await Hive.openBox(dbBoxNameAssociationLearned);
    box.delete(dbBoxNameAssociationLearned);
    box.put(dbBoxNameAssociationLearned, associationsLearned.toString());
  }

  Future<void> deleteAssociationLearned(String knowledgeFieldName, String keyToDelete) async {
    associationsLearned.forwardsLearned[knowledgeFieldName]!.remove(keyToDelete);
    associationsLearned.backwardsLearned[knowledgeFieldName]!.remove(keyToDelete);
    var box = await Hive.openBox(dbBoxNameAssociationLearned);
    box.delete(dbBoxNameAssociationLearned);
    box.put(dbBoxNameAssociationLearned, associationsLearned.toString());
  }
}

class AppLastValueSetting extends PersistentProperties {
  static const String lastKnowledgeFieldAction = 'lastKnowledgeFieldAction';
  static const String lastKnowledgeUsageOrder = 'lastKnowledgeUsageOrder';
  static const String lastNumberOfQuestsToPlayInMatch = 'lastNumberOfQuestsToPlayInMatch';
  static const String lastNumberOfMinutesToPlayInRace = 'lastNumberOfMinutesToPlayInRace';
  static const String lastLibraryFilterMode = 'lastLibraryFilterMode';

  AppLastValueSetting.fromString(String instanceAsString) {
    addFromStringToMap(instanceAsString, propertySeparator, properties);
  }

  String getLastLibraryFilterMode() {
    return getStringValue(lastLibraryFilterMode, "area");
  }

  void setLastLibraryFilterMode(String value) {
    addProperty(lastLibraryFilterMode, value);
  }

  int getLastNumberOfMinutesToPlayInRace() {
    return getIntValue(lastNumberOfMinutesToPlayInRace, 10);
  }

  void setLastNumberOfMinutesToPlayInRace(String value) {
    addProperty(lastNumberOfMinutesToPlayInRace, value);
  }

  int getLastNumberOfQuestsToPlayInMatch() {
    return getIntValue(lastNumberOfQuestsToPlayInMatch, 100);
  }

  void setLastNumberOfQuestsToPlayInMatch(String value) {
    addProperty(lastNumberOfQuestsToPlayInMatch, value);
  }

  void setLastKnowledgeFieldAction(String value) {
    addProperty(lastKnowledgeFieldAction, value);
  }

  String getLastKnowledgeFieldAction() {
    return getStringValue(lastKnowledgeFieldAction, "Import");
  }

  void setLastKnowledgeUsageOrder(String value) {
    addProperty(lastKnowledgeUsageOrder, value);
  }

  String getLastKnowledgeUsageOrder() {
    return getStringValue(lastKnowledgeUsageOrder, "");
  }

  List<String> getLastKnowledgeUsageOrderAsList() {
    return AssTraStringUtil.stringToList(getLastKnowledgeUsageOrder(), toListSeparator);
  }

}

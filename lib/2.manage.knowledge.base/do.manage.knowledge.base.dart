import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../main.dart';

part 'do.manage.knowledge.base.g.dart';

@HiveType(typeId: 0)
class KnowledgeField {
  @HiveField(0)
  late final String knowledgeArea;
  @HiveField(1)
  late final String questionTemplateForward;
  @HiveField(2)
  late final String questionTemplateBackwards;
  @HiveField(3)
  late final String keyName;
  @HiveField(4)
  late final String valueName;
  @HiveField(5)
  late final String type;
  @HiveField(6)
  final Map<String,String> keyValuePairs = {};

  KnowledgeField(this.knowledgeArea, this.keyName, this.valueName, this.type, this.questionTemplateForward, this.questionTemplateBackwards);

  KnowledgeField.empty() {
    knowledgeArea = '';
    keyName = '';
    valueName = '';
    questionTemplateForward = '';
    questionTemplateBackwards = '';
    type = KnowledgeFieldType.oneWay.name;
  }

  void addKeyValuePair(String key, String value) {
    keyValuePairs.addEntries({key:value}.entries);
  }

  void addKeyValuePairAsFirst(String key, String value) {
    Map<String,String> temp = {};
    temp.addAll(keyValuePairs);
    keyValuePairs.clear();
    keyValuePairs.addEntries({key:value}.entries);
    keyValuePairs.addAll(temp);
  }

  bool doesKeyExist(String key) {
    return keyValuePairs.containsKey(key);
  }

  bool doesValueExist(String value) {
    return keyValuePairs.containsValue(value);
  }

  String getAssociationAsString(int index) {
    var key = keyValuePairs.keys.toList().elementAt(index);
    return "$key - ${keyValuePairs[key]!}";
  }

  KnowledgeField.formString(String s) {
    List<String> lines = AssTraStringUtil.stringToList(s, "\n");
    knowledgeArea = lines.elementAt(0).trim();
    List<String> splitResult = toKeyValuePair(lines.elementAt(1));
    keyName = splitResult.elementAt(0).trim();
    valueName = splitResult.elementAt(1).trim();
    questionTemplateForward = lines.elementAt(2).trim();
    questionTemplateBackwards = lines.elementAt(3).trim();

    lines.removeAt(3);
    lines.removeAt(2);
    lines.removeAt(1);
    lines.removeAt(0);
    for (var line in lines) {addAsKeyValuePair(line);}
    type = determineDirectionType();
  }

  String getForwardQuestion(String associationKey) {
    associationKey = checkForBoldFormat(associationKey);
    String template = questionTemplateForward;
    if (questionTemplateForward.isEmpty) {
      template = defaultTextQuestionInQuest;
    }
    return template.replaceAll('<>', associationKey);
  }

  String getBackwardQuestion(String associationValue) {
    associationValue = checkForBoldFormat(associationValue);
    String template = questionTemplateBackwards;
    if (questionTemplateForward.isEmpty) {
      template = defaultTextQuestionInQuest;
    }
    return template.replaceAll('<>', associationValue);
  }

  String checkForBoldFormat(String s) {
    if (! s.startsWith("*")) s = "*" + s;
    if (! s.endsWith("*")) s = s + "*";
    return s;
  }

  void put(String key, String value) {
    keyValuePairs.addEntries({key:value}.entries);
  }

  String getName() {
    return '$keyName - $valueName';
  }

  IconData getIcon() {
    if (type == KnowledgeFieldType.twoWay.name) {
      return twoWayArrow;
    }
    return oneWayArrow;
  }

  ValidationResult validate()
  {
    if (keyName == '' && valueName == '' && keyValuePairs.length == 1 ) {
      return ValidationResult.inputError;
    }

    int limit = appRuntimeData.appConfigData.getNumberOfAnswersInQuest();

    if (keyValuePairs.length <= limit) {
      return ValidationResult.tooFewElements;
    }

    if (type == KnowledgeFieldType.twoWay.name && ! areValuesUnique()) {
      return ValidationResult.oneToOneAssociationBroken;
    }

    return ValidationResult.ok;
  }

  bool areValuesUnique() {
    List uniqueValues = List.empty(growable: true);
    keyValuePairs.values.where((element) => !uniqueValues.contains(element)).forEach((element) {uniqueValues.add(element);});
    return uniqueValues.length == keyValuePairs.length;
  }

  @override
  String toString() {
    final buffer = StringBuffer(knowledgeArea);
    buffer.write('\n');
    buffer.write(getName().replaceFirst('-', '#'));
    buffer.write('\n');
    buffer.write(questionTemplateForward);
    buffer.write('\n');
    buffer.write(questionTemplateBackwards);
    buffer.write('\n');
    keyValuePairs.forEach((key, value) { buffer.write('$key # $value');
    buffer.write('\n');});
    return buffer.toString();
  }

  void addAsKeyValuePair(String line) {
    if (line.startsWith("#")) return; // ignore comment lines
    List<String> splitResult = toKeyValuePair(line);
    if (splitResult.length == 2) {
      String key = splitResult.elementAt(0).trim();
      String value = splitResult.elementAt(1).trim();
      keyValuePairs.addEntries({key:value}.entries);
    }
  }

  List<String> toKeyValuePair(String line) => line.split(propertySeparator);

  String determineDirectionType() {
    if (areValuesUnique()) {
      return KnowledgeFieldType.twoWay.name;
    }
    return KnowledgeFieldType.oneWay.name;
  }

  List<String> getKeyMatches(String searchString) {
    List<String> matches = keyValuePairs.keys.where((element) => element.startsWith(searchString)).toList();
    return matches.map((e) => "$e - ${keyValuePairs[e]!}").toList();
  }

  List<String> getValueMatches(String searchString) {
    List<String> matches = keyValuePairs.keys.where((element) => keyValuePairs[element] != null && keyValuePairs[element]!.startsWith(searchString)).toList();
    return matches.map((e) => "$e - ${keyValuePairs[e]!}").toList();
  }

  void deleteKeyValuePair(String toDelete) {
    var splitResult = toDelete.split(" - ");
    String key = splitResult.elementAt(0);
    keyValuePairs.remove(key);
  }

}

class AssociationsLearned {
  static const String mapSeparator = "###";
  // for each KnowledgeFieldName list of key-values-pairs that are already learned
  Map<String, List<String>> forwardsLearned = {};
  Map<String, List<String>> backwardsLearned = {};

  AssociationsLearned.fromString(String s) {
    if (s.isEmpty) return;
    var splitResult = s.split(mapSeparator);
    forwardsLearned.addAll(AssTraStringUtil.stringToMapWithStringList(splitResult.elementAt(0), keyValueSeparator, propertySeparator, toListSeparator));
    backwardsLearned.addAll(AssTraStringUtil.stringToMapWithStringList(splitResult.elementAt(1), keyValueSeparator, propertySeparator, toListSeparator));
  }

  @override
  String toString() {
    return AssTraStringUtil.mapWithStringListToString(forwardsLearned, keyValueSeparator, propertySeparator, toListSeparator)
           + mapSeparator +
           AssTraStringUtil.mapWithStringListToString(backwardsLearned, keyValueSeparator, propertySeparator, toListSeparator);
  }

  List<String> getForwardLearnedAssociations(String knowledgeFieldName) {
    List<String>? toReturn = forwardsLearned[knowledgeFieldName];
    if (toReturn == null) {
      return List.empty();
    }
    return toReturn;
  }

  List<String> getBackwardLearnedAssociations(String knowledgeFieldName) {
    List<String>? toReturn = backwardsLearned[knowledgeFieldName];
    if (toReturn == null) {
      return List.empty();
    }
    return toReturn;
  }

}
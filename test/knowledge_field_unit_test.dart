import 'package:asstra/2.manage.knowledge.base/do.manage.knowledge.base.dart';
import 'package:asstra/3.endless.quiz/do.endlessquiz.dart';
import 'package:asstra/5.change.configuration/do.configuration.dart';
import 'package:asstra/do.main.dart';
import 'package:asstra/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asstra/common/asstra.constants.dart';

void main() {
  createTestAppRuntimeData();

  test('validate two-way KnowledgeField', () {
    KnowledgeField testData1 = KnowledgeField('Area', 'Land', 'Hauptstadt', KnowledgeFieldType.twoWay.name, '', '');
    testData1.put('Schweden', 'Stockholm');
    testData1.put('Norwegen', 'Oslo');
    testData1.put('Finnland', 'Helinki');
    testData1.put('England', 'London');
    testData1.put('Island', 'Reykjavik');
    expect(ValidationResult.ok, testData1.validate());
  });

  test('invalidate KnowledgeField due to size', () {
    KnowledgeField testData1 = KnowledgeField('Area', 'Land', 'Hauptstadt', KnowledgeFieldType.twoWay.name, '', '');
    testData1.put('Schweden', 'Stockholm');
    testData1.put('Norwegen', 'Oslo');
    testData1.put('Finnland', 'Helinki');
    testData1.put('England', 'London');
    expect(ValidationResult.tooFewElements, testData1.validate());
  });

  test('validate one-way KnowledgeField', () {
    KnowledgeField testData2 = KnowledgeField('Area', 'Land', 'Kontinent', KnowledgeFieldType.oneWay.name, '', '');
    testData2.put('China', 'Asien');
    testData2.put('Australien', 'Ozeanien');
    testData2.put('Brasilien', 'Südamerika');
    testData2.put('Peru', 'Südamerika');
    testData2.put('Mexiko', 'Nordamerika');
    testData2.put('Island', 'Europa');
    expect(ValidationResult.ok, testData2.validate());
  });

  test('invalidate two-way KnowledgeField', () {
    KnowledgeField testData2 = KnowledgeField('Area', 'Land', 'Kontinent', KnowledgeFieldType.twoWay.name, '', '');
    testData2.put('China', 'Asien');
    testData2.put('Australien', 'Ozeanien');
    testData2.put('Brasilien', 'Südamerika');
    testData2.put('Peru', 'Südamerika');
    testData2.put('Mexiko', 'Nordamerika');
    testData2.put('Island', 'Europa');
    expect(ValidationResult.oneToOneAssociationBroken, testData2.validate());
  });

  test('transform KnowledgeField to String', () {
    KnowledgeField knowledgeField = KnowledgeField('Area', 'Land', 'Kontinent', KnowledgeFieldType.twoWay.name, 'Q1?', 'Q2?');
    knowledgeField.put('China', 'Asien');
    knowledgeField.put('Australien', 'Ozeanien');
    String expected = '''Area
Land # Kontinent
Q1?
Q2?
China # Asien
Australien # Ozeanien
''';
    expect(knowledgeField.toString(), expected);
  });

  test('transform a string to KnowledgeField object', () {
    String importString = '''Geography
Country # Capital
What is the capital of <Country>?
In which country is <Capital> the capital?
# a comment line
China # Asien
Australien # Ozeanien''';

    KnowledgeField knowledgeField = KnowledgeField.formString(importString);

    expect(knowledgeField.knowledgeArea, "Geography");
    expect(knowledgeField.getName(), "Country - Capital");
    expect(knowledgeField.getForwardQuestion("Norway"), "What is the capital of Norway?");
    expect(knowledgeField.getBackwardQuestion("Oslo"), "In which country is Oslo the capital?");
    expect(knowledgeField.keyValuePairs.length, 2);
    expect(knowledgeField.toString().trim().split("\n").length, 6);

  });

}

createTestAppRuntimeData() {
  appRuntimeData = AssTraRuntimeData(false,
      AssTraConfig.fromString('numberOfAnswersInQuest=4'),
      AppLastValueSetting.fromString(""),
      List.empty(),
      {},
      EndlessQuizProperties.fromString(""),
      AssociationsLearned.fromString(""));

}

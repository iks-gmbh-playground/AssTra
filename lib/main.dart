import 'dart:io';

import 'package:asstra/6.about/view.about.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/do.main.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '1.library.train.and.play/do.train_and_play.dart';
import '1.library.train.and.play/view.1library.dart';
import '2.manage.knowledge.base/do.manage.knowledge.base.dart';
import '2.manage.knowledge.base/view.manage.overview.dart';
import '3.endless.quiz/do.endlessquiz.dart';
import '3.endless.quiz/view.quizExecution.dart';
import '4.view.hall.of.fame/do.halloffame.dart';
import '4.view.hall.of.fame/view.halloffame.dart';
import '5.change.configuration/do.configuration.dart';
import '5.change.configuration/view.configuration.dart';
import '6.about/text.about.dart';
import 'common/utils/asstra.util.string.dart';
import 'common/widgets/AppMainPage.dart';

const resetDB = false;
late AssTraRuntimeData appRuntimeData;
late AppMainPage appMainPage;
bool firstAppStart = false;

void main() => runApp(const AssTraApp());

class AssTraApp extends StatelessWidget {
  const AssTraApp({super.key});

  @override Widget build(BuildContext context) {
    var asstraColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue.shade800, secondary: Colors.blue.shade300, tertiary: Colors.blue.shade100);

    appMainPage = AppMainPage(title: textMainAppTitle,
                              mainMenuTitle: textMainmenuTitle,
                              appPagesFuture: createAppPages(),
                              mainMenuNames: createPageNames(),
                              waitStateImage: assTraLogo);

    return MaterialApp(
      title: textMainAppName,
      theme: ThemeData(
        colorScheme: asstraColorScheme,
        useMaterial3: true,
      ),
      home: appMainPage
    );
  }

  Future<AssTraRuntimeData> initAppRuntimeData() async {
    await initDB();

    AssTraConfig config = await initConfig();
    List<KnowledgeField> appKnowledgeFieldData = await initKnowledgeFields();
    AppLastValueSetting lastValueSettings = await initLastValueSettings(appKnowledgeFieldData);
    Map<String,List<HallOfFameEntry>> appHallOfFameData = await initHallOfFameData(appKnowledgeFieldData);
    EndlessQuizProperties endlessQuizData = await initEndlessQuizData();
    AssociationsLearned associationsLearned = await initAssociationsLearned();

    appRuntimeData = AssTraRuntimeData(firstAppStart, config, lastValueSettings, appKnowledgeFieldData,
                                       appHallOfFameData, endlessQuizData, associationsLearned);
    return Future<AssTraRuntimeData>.value(appRuntimeData);
  }

  Future<void> initDB() async {
    Directory dbDir = await getApplicationDocumentsDirectory();
    Hive.init('${dbDir.path}/$dbFileName');
  }

  Future<AssTraConfig> initConfig() async {
    var box = await Hive.openBox(dbBoxNameProperties);
    if (resetDB) box.clear();
    var persistedInstanceString = box.get(dbEntryConfig);
    persistedInstanceString ??= "";
    return Future<AssTraConfig>.value(AssTraConfig.fromString(persistedInstanceString));
  }

  Future<List<KnowledgeField>> initKnowledgeFields() async {
    if (! Hive.isAdapterRegistered(KnowledgeFieldAdapter().typeId)) Hive.registerAdapter(KnowledgeFieldAdapter());
    var box = await Hive.openBox(dbBoxNameKnowledge);
    if (resetDB) box.clear();
    List<KnowledgeField> fields = box.values.map((e) => e as KnowledgeField).toList();
    if (fields.isEmpty) {
      firstAppStart = true;
      var defaultKnowledgeFields = await createDefaultKnowledgeFields();
      for (var element in defaultKnowledgeFields) {
        fields.add(element);
        box.put(element.getName(), element);
      }
    }
    return fields;
  }

  Future<AppLastValueSetting> initLastValueSettings(List<KnowledgeField> appKnowledgeFieldData) async {
    var box = await Hive.openBox(dbBoxNameProperties);
    if (resetDB) box.clear();
    var persistedInstanceString = box.get(dbEntryLastValueSettings);
    var knowledgeFieldNameList = appKnowledgeFieldData.map((field) => field.getName()).toList();
    String listAsString = AssTraStringUtil.listToString(knowledgeFieldNameList, toListSeparator);
    persistedInstanceString ??= "${AppLastValueSetting.lastKnowledgeUsageOrder}=$listAsString";
    return Future<AppLastValueSetting>.value(AppLastValueSetting.fromString(persistedInstanceString));
  }

  Future<Map<String,List<HallOfFameEntry>>> initHallOfFameData(List<KnowledgeField> appKnowledgeFieldData) async {
    if (! Hive.isAdapterRegistered(HallOfFameEntryAdapter().typeId)) Hive.registerAdapter(HallOfFameEntryAdapter());
    var box = await Hive.openBox(dbBoxNameHallOfFame);
    if (resetDB) box.clear();
    for (var field in appKnowledgeFieldData) {
      if (! box.keys.contains(field.getName())) {
        box.put(field.getName(), List<HallOfFameEntry>.empty(growable: true));
      }
    }
    appKnowledgeFieldData.map((e) => e.knowledgeArea).forEach((area) { box.put(area, List<HallOfFameEntry>.empty(growable: true)); });

    Map<String,List<HallOfFameEntry>> toReturn = {};
    for (var key in box.keys) {
      List<HallOfFameEntry> value = List<HallOfFameEntry>.empty(growable: true);
      List<dynamic> s = box.get(key);
      for (var element in s) { value.add(element as HallOfFameEntry); }
      toReturn[key] = value;

    }
    return Future<Map<String,List<HallOfFameEntry>>>.value(toReturn);
  }

  Future<EndlessQuizProperties> initEndlessQuizData() async {
    var box = await Hive.openBox(dbBoxNameProperties);
    if (resetDB) box.clear();
    var persistedInstanceString = box.get(dbEntryEndlessQuiz);
    persistedInstanceString ??= "";
    return Future<EndlessQuizProperties>.value(EndlessQuizProperties.fromString(persistedInstanceString));
  }

  Future<AssociationsLearned> initAssociationsLearned() async {
    var box = await Hive.openBox(dbBoxNameAssociationLearned);
    if (resetDB) box.clear();
    var persistedInstanceString = box.get(dbBoxNameAssociationLearned);
    persistedInstanceString ??= "";
    return Future<AssociationsLearned>.value(AssociationsLearned.fromString(persistedInstanceString));
  }

  Future<List<Widget>> createAppPages() {
    final Future<AssTraRuntimeData> dbInitProcess = initAppRuntimeData();
    return dbInitProcess.then((appData) {
      List<Widget> toReturn = List<Widget>.empty(growable: true);
      toReturn.add(AssTraLibrary(libraryData: appData.knowledgeFields));
      toReturn.add(AssTraManageKnowledgeView(libraryData: appData.knowledgeFields));
      toReturn.add(const AssTraEndlessQuizView());
      toReturn.add(AssTraHallOfFameView(highScoreListName: '', newEntryFor: '', execResult: ExecResult.empty()));
      toReturn.add(AssTraConfigView(appRuntimeData.appConfigData));
      toReturn.add(AssTraAboutView(faqNumber: 0));

      if (toReturn.length != createPageNames().length) {
        throw Exception("Illegal Argument: Lists must not mismatch in length!");
      }
      return toReturn;
    });
  }

  List<String> createPageNames() {
    return [textMainmenuGotoLibrary, textMainmenuGotoImportExport, textMainmenuGotoEndlessQuiz,
            textMainmenuGotoHallOfFame, textMainmenuGotoAppConfig, textMainmenuGotoAbout];
  }

  static Future<String> loadAsset(String filePath) async {
    return await rootBundle.loadString(filePath);
  }

  Future<List<KnowledgeField>> createDefaultKnowledgeFields() async {
    List<KnowledgeField> toReturn = List<KnowledgeField>.empty(growable: true);
    String fileContent = await loadAsset('assets/defaultKnowledgeFields/geoLlandErdteil.dat');
    toReturn.add(KnowledgeField.formString(fileContent));
    fileContent = await loadAsset('assets/defaultKnowledgeFields/geoLandHauptstadt.dat');
    toReturn.add(KnowledgeField.formString(fileContent));
    fileContent = await loadAsset('assets/defaultKnowledgeFields/chemSymbolOrderNumber.dat');
    toReturn.add(KnowledgeField.formString(fileContent));
    fileContent = await loadAsset('assets/defaultKnowledgeFields/chemNameSymbol.dat');
    toReturn.add(KnowledgeField.formString(fileContent));
    fileContent = await loadAsset('assets/defaultKnowledgeFields/chemSymbolGroup.dat');
    toReturn.add(KnowledgeField.formString(fileContent));
    fileContent = await loadAsset('assets/defaultKnowledgeFields/abcDE.dat');
    toReturn.add(KnowledgeField.formString(fileContent));
    return toReturn;
  }


}

import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';

import '../2.manage.knowledge.base/do.manage.knowledge.base.dart';

class QuestData {
  final String knowledgeFieldName;
  final String question;
  final String questKey;
  final List<String> possibleAnswers = List.empty(growable: true);
  final String correctAnswer;
  final bool directionReversed;
  String? actualAnswer;

  QuestData(this.knowledgeFieldName, this.question, this.questKey,
            List<String> possibleAnswers, this.correctAnswer,
            this.directionReversed)
  {
    this.possibleAnswers.addAll(possibleAnswers);
  }

  @override
  String toString() {
    return 'QuestData{knowledgeFieldName: $knowledgeFieldName, question: $question, questKey: $questKey, possibleAnswers: $possibleAnswers, correctAnswer: $correctAnswer, directionReversed: $directionReversed, actualAnswer: $actualAnswer}';
  }
}

class ExecResult {
  final ExecConfig execConfig;
  final List<KnowledgeField> knowledgeFields;
  final int durationInMillis;
  final int questsDone;
  final int questsOk;
  final int associationsTotal;
  final int associationsLearned;

  ExecResult(this.execConfig, this.knowledgeFields, this.durationInMillis,
      this.questsDone, this.questsOk,
      this.associationsTotal, this.associationsLearned);

  ExecResult.empty() :
        execConfig = ExecConfig.standard(),
        knowledgeFields = List.empty(),
        durationInMillis = 0,
        questsDone = 0,
        questsOk = 0,
        associationsTotal = 0,
        associationsLearned = 0;

  @override
  String toString() {
    var list = knowledgeFields.map((e) => e.getName()).toList();
    return 'ExecResult{execConfig: $execConfig, knowledgeFields: ${AssTraStringUtil.listToString(list, ", ")}, duration: $durationInMillis, questsDone: $questsDone, questsOk: $questsOk, associationsTotal: $associationsTotal, associationsLearned: $associationsLearned}';
  }
}

class ExecConfig {
  final StartMode startMode;
  final DirectionMode directionMode;
  ExecConfig(this.startMode, this.directionMode);
  ExecConfig.standard() :
        startMode = StartMode.playing,
        directionMode = DirectionMode.forwards;
}

class TrainingConfig extends ExecConfig {
  final TrainingMode trainingMode;
  TrainingConfig(directionMode, this.trainingMode) : super(StartMode.training, directionMode);
}

class PlayingConfig extends ExecConfig {
  final PlayingMode playingMode;
  final int duration;
  PlayingConfig( directionMode, this.playingMode, this.duration) : super(StartMode.playing, directionMode);
}


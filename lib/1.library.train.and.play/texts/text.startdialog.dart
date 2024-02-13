const textStartdialogStartModeQuestion = 'What to start?';
const textStartdialogStartModeText = 'Mode to start';
const textStartdialogDirectionQuestion = 'Which direction?';
const textStartdialogDirectionText = 'Direction Types';
const textStartdialogKnowledgeQuestion = 'Your current knowledge?';
const textStartdialogKnowledgeText = 'State of knowledge';
const textStartdialogGameTypeQuestion = 'Which type of game?';
const textStartdialogGameTypeText = 'Type of Game';
const textStartdialogQuestNumberQuestions = 'How many quests?';
const textStartdialogMinutesNumberQuestions = 'How many minutes?';
const textStartdialogStartButton = 'Start';

const textStartdialogForwards = 'Forwards';
const textStartdialogBackwards = 'Backwards';
const textStartdialogReset = 'Reset';

const textStartdialogInfoGameType='With *Race* you fight mainly against time, with *Match* you fight mainly for a minimum of wrong choices.';
const textStartdialogInfoDirectionTypes='For *One-Way*-Knowledge Fields only the direction *Forwards* is available. For *Two-Way*-Knowledge Fields you may choose alternatively *Backwards* or *Mixed*. In the last case AssTra chooses a direction for each association randomly.';
const textStartdialogInfoStartMode='''*Training*
AssTra presents each association of the given knowledge field so many times until you matched the two terms of the association three times in a sequence correctly. 

*Game*
AssTra presents each association of the given knowledge field only once and collects time and number of wrong matches. 
''';
const textStartdialogInfoCurrentKnowledge='''Imagine, a knowledge field consists of a pool of 1000 associations. While training, AssTra builds randomly subgroups out of the whole pool. When the first subgroups shrinks due to your learning success it is filled up with associations of the second subgroup and so on. Thus, AssTra adapts its training to your knowledge: 

*Much knowledge*
If you have already much knowledge in the given field, the subgroup size is big (x1).

*Some knowledge*
If you have some knowledge in the given field (but not so much), the subgroup is of medium size (x2).

*Little or no knowledge*
If you near to nothing of preexisting knowledge, the subgroup is small (x3).
''';
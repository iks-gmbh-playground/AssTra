import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const dbFileName = 'AssTra.db';
const dbBoxNameKnowledge = 'KnowledgeFields';
const dbBoxNameHallOfFame = 'HallOfFame';
const dbBoxNameAssociationLearned = 'AssociationLearned';
/**
 * Properties based data is
 * - config settings
 * - last value used settings
 * - endless quiz data
 */
const dbBoxNameProperties = 'AssTraProperties';
const dbEntryConfig = "Configuration";
const dbEntryLastValueSettings = "LastValuesUsed";
const dbEntryEndlessQuiz = "EndlessQuiz";

const iksLogo = Image(image: AssetImage('assets/IKSLogo.png'));
const iksLogoOhneSchrift = Image(image: AssetImage('assets/IKS.png'));
const assTraLogo = Image(image: AssetImage('assets/AssTraLogo.png'));
const noImage = Image(image: AssetImage('assets/IKSLogo.png'));

const libraryFilterFieldIcon = IconData(0xe51e, fontFamily: 'MaterialIcons');
const libraryFilterAreaIcon = CupertinoIcons.rectangle_grid_1x2_fill;
const twoWayArrow = CupertinoIcons.arrow_right_arrow_left;
const oneWayArrow = CupertinoIcons.arrow_right;
const searchIcon = CupertinoIcons.search;
const addIcon = CupertinoIcons.add_circled_solid;
const deleteIcon = CupertinoIcons.delete;
const warningIconColor = Colors.orange;
const infoIcon = CupertinoIcons.info;
const problemIcon = CupertinoIcons.alarm;
const standardSortIcon = CupertinoIcons.line_horizontal_3_decrease_circle;
const abcSortIcon = CupertinoIcons.sort_up_circle_fill;
const zxySortIcon = CupertinoIcons.sort_down_circle_fill;

const IconData collegeHatIcon = IconData(0xe559, fontFamily: 'MaterialIcons');
const warningIcon = IconData(0xe6cb, fontFamily: 'MaterialIcons');
const infoIconColor = Color.fromRGBO(0, 0, 255, 100);
const problemIconColor = Color.fromRGBO(250, 0, 0, 100);
var deactivatedButtonStyle = ElevatedButton.styleFrom(foregroundColor: Colors.black,
                                                      backgroundColor: Colors.white54,
                                                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
var okButtonStyle = ElevatedButton.styleFrom(foregroundColor: Colors.white,
                                             backgroundColor: Colors.green.shade700,
                                             textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
var cancelButtonStyle = ElevatedButton.styleFrom(foregroundColor: Colors.white,
    backgroundColor: Colors.blue.shade700,
    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));

const TextStyle standardTextStyle = TextStyle(fontFamily: 'Bold', fontSize: 20.0, color: Colors.purple);
const TextStyle smallTextStyle = TextStyle(fontFamily: 'Plain', fontSize: 16.0, color: Colors.black);
const animatedTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red);
const animatedColors = [Colors.green, Colors.yellow, Colors.orange, Colors.red];

const keyValueSeparator = '=';
const propertySeparator = '#';
const toListSeparator = '|';

const maxQuestToPlayAllowed = 1000;
const maxMinutesToPlayAllowed = 180;

final ButtonStyle neutralButtonStyle = deactivatedButtonStyle;
final ButtonStyle pressedButtonStyle = ElevatedButton.styleFrom(foregroundColor: Colors.white,
                                                                backgroundColor: Colors.purple,
                                                                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));

enum KnowledgeFieldType { oneWay, twoWay }
enum ValidationResult  {ok, tooFewElements, oneToOneAssociationBroken, inputError}
enum SortMode {standard, abc, zxy}

enum StartMode { training('Training'), playing('Game');
  const StartMode(this.displayValue);
  final String displayValue;
}
enum DirectionMode { forwards('Forwards'), backwards('Backwards'), mixed('Mixed');
  const DirectionMode(this.displayValue);
  final String displayValue;
}
enum TrainingMode { muchKnowledge('Much'), someKnowledge('Some'), littleToNoKnowledge('Little or No');
  const TrainingMode(this.displayValue);
  final String displayValue;
}
enum PlayingMode { match('Match'), race('Race'), endlessQuiz('Endless Quiz');
  const PlayingMode(this.displayValue);
  final String displayValue;
}

